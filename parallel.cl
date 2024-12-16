/*
 * rupesh.majhi@tuni.fi
 */

// Dimensions of the rendered window
#define WINDOW_WIDTH 1024
#define WINDOW_HEIGHT 1024

// Number of satellites in the simulation
#define SATELLITE_COUNT 64

// Radius of each satellite (used for determining proximity to a pixel)
#define SATELLITE_RADIUS 3.16f

// Total number of pixels in the rendered window
#define SIZE (WINDOW_HEIGHT * WINDOW_WIDTH)

// Defines a 2D vector with x and y coordinates as floats
typedef struct
{
    float x;
    float y;
} floatvector;

// Stores RGB color values as floats (0.0f to 1.0f)
typedef struct
{
    float red;
    float green;
    float blue;
} color;

// Represents a satellite with color, position, and velocity
typedef struct
{
    color identifier;
    floatvector position;
    floatvector velocity;
} satellite;

// OpenCL kernel
__kernel void
parallelOpenCL (__global satellite *satellites, __global color *pixelsOut,
                const int mousePosX, const int mousePosY,
                const float blackHoleRadius)
{

    // Get global work-item indices
    int idx = get_global_id (0); // Horizontal pixel index (column)
    int idy = get_global_id (1); // Vertical pixel index (row)

    // Compute 1D index for the pixel array
    int index = idx + (idy * WINDOW_WIDTH);

    // Determine the position of the current pixel
    floatvector pixel = { .x = idx, .y = idy };

    // Calculate distance to the black hole
    float dx = pixel.x - mousePosX;
    float dy = pixel.y - mousePosY;
    float distToBlackHoleSquared = dx * dx + dy * dy;

    // If the pixel is within the black hole's radius, set color to black
    if (sqrt (distToBlackHoleSquared) < blackHoleRadius)
        {
            pixelsOut[index].red = 0.0f;
            pixelsOut[index].green = 0.0f;
            pixelsOut[index].blue = 0.0f;
            return;
        }

    // Initialize the pixel's color to black
    color renderColor = { .red = 0.0f, .green = 0.0f, .blue = 0.0f };

    // Variables for tracking the closest satellite and blending weights
    float shortestDistance = INFINITY;
    float weights = 0.0f;
    int hitsSatellite = 0;

    // First loop: Find the closest satellite and check for direct hits
    for (int j = 0; j < SATELLITE_COUNT; ++j)
        {
            // Compute the vector difference between the pixel and satellite
            // position
            floatvector difference
                = { .x = pixel.x - satellites[j].position.x,
                    .y = pixel.y - satellites[j].position.y };

            // Compute the Euclidean distance to the satellite
            float distance = sqrt (difference.x * difference.x
                                   + difference.y * difference.y);

            // If the pixel is within the satellite's radius, set its color to
            // white
            if (distance < SATELLITE_RADIUS)
                {
                    renderColor.red = 1.0f;
                    renderColor.green = 1.0f;
                    renderColor.blue = 1.0f;
                    hitsSatellite = 1; // Mark that the pixel hits a satellite
                    break;
                }
            else
                {
                    // Compute weight based on inverse fourth power of the
                    // distance
                    float weight
                        = 1.0f / (distance * distance * distance * distance);
                    weights += weight;

                    // Update closest satellite color if necessary
                    if (distance < shortestDistance)
                        {
                            shortestDistance = distance;
                            renderColor = satellites[j].identifier;
                        }
                }
        }

    // Blend colors if no direct satellite hit
    if (!hitsSatellite)
        {
            for (int j = 0; j < SATELLITE_COUNT; ++j)
                {
                    floatvector difference
                        = { .x = pixel.x - satellites[j].position.x,
                            .y = pixel.y - satellites[j].position.y };

                    // Compute the square of the distance
                    float dist2 = difference.x * difference.x
                                  + difference.y * difference.y;

                    // Compute the weight based on the inverse square of the
                    // distance
                    float weight = 1.0f / (dist2 * dist2);

                    // Blend satellite color based on weight
                    renderColor.red
                        += (satellites[j].identifier.red * weight / weights)
                           * 3.0f;
                    renderColor.green
                        += (satellites[j].identifier.green * weight / weights)
                           * 3.0f;
                    renderColor.blue
                        += (satellites[j].identifier.blue * weight / weights)
                           * 3.0f;
                }
        }

    // Write the final color to the output buffer
    pixelsOut[index] = renderColor;
}

