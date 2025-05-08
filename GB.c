// ------------------------------------------------------------------------------------------------------------
//  Purpose : Perform a Gaussian broadening on a set of impulse signal data as input.
//! Suppose the input data is sorted in ascending order
// gcc -O2 -lm GB.c -o Gb.x
//! Usage:  ./command input_file sigma
// ...
//          in which, command     : Gb.x
//                    input_file  : filename of impulse data
//                    sigma       : The standard deviation of the distribution is ⁠σ⁠ (sigma)
//------------------------------------------------------------------------------------------------------------
#include <stdio.h>
#include <limits.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{
    if (argc < 3) {
        printf("Usage: ./command input_file sigma\n");
        exit(EXIT_FAILURE);
    }

    int size = 0, i;
    char *line = NULL;
    size_t len = 0;
    ssize_t read;
    double sigma, xMax, xMin, xStep;
    char str1[100]; // Increased size for safety
    char str2[] = "_Gb.dat";

    // Validate sigma
    sigma = atof(argv[2]);
    if (sigma <= 0) {
        printf("Error: sigma must be positive\n");
        exit(EXIT_FAILURE);
    }

    // Check buffer size for str1
    if (strlen(argv[1]) + strlen(str2) >= sizeof(str1)) {
        printf("Error: Input filename too long\n");
        exit(EXIT_FAILURE);
    }
    strcpy(str1, argv[1]);

    FILE *myFile = fopen(argv[1], "r");
    if (myFile == NULL) {
        printf("Error opening input file!\n");
        exit(EXIT_FAILURE);
    }

    // Count lines to determine size
    while ((read = getline(&line, &len, myFile)) != -1) {
        printf("Retrieved line of length %zu:\n", read);
        printf("%s", line);
        size++;
    }
    free(line); // Free line after counting
    line = NULL;

    // Create output filename
    strcat(str1, str2);
    FILE *fp = fopen(str1, "w");
    if (fp == NULL) {
        printf("Error opening output file!\n");
        fclose(myFile);
        exit(EXIT_FAILURE);
    }

    rewind(myFile);

    double xvalue[size];
    double yvalue[size];

    // Read input data
    for (i = 0; i < size; i++) {
        if (fscanf(myFile, "%lf%lf", &xvalue[i], &yvalue[i]) != 2) {
            printf("Error reading input data at line %d\n", i + 1);
            fclose(myFile);
            fclose(fp);
            exit(EXIT_FAILURE);
        }
        printf("Input %d: %lf %lf\n", i, xvalue[i], yvalue[i]);
    }

    // Calculate and export the broadening result
    xMin = xvalue[0] - 5 * sigma;
    xMax = xvalue[size - 1] + 5 * sigma;
    xStep = sigma / 5;

    double x = xMin;
    while (x <= xMax + xStep / 2) { // Added epsilon to handle floating-point precision
        double y = 0.0;
        for (i = 0; i < size; i++) {
            if (fabs(x - xvalue[i]) <= 3 * sigma) {
                y += yvalue[i] / (sigma * sqrt(2 * M_PI)) * \
                     exp(-pow(x - xvalue[i], 2) / (2 * sigma * sigma));
            }
        }
        fprintf(fp, "%lf %lf\n", x, y);
        printf("Output[%d]: %lf %lf\n", i, x, y);
        x += xStep;
    }

    fclose(myFile);
    fclose(fp);
    if (line) {
        free(line);
    }

    return EXIT_SUCCESS;
}
