~~~~~~~~~~~~~~~
#include <stdio.h>
#include <limits.h>
#include <math.h>
#include <stdlib.h>

int main()
{
  int size=0, i;
  char * line = NULL;
  size_t len =0;
  ssize_t read;
  double sigma, xMax, xMin;

  printf("Enter sigma: ");
  scanf ("%lf",&sigma);

  printf("Enter xMax: ");
  scanf ("%lf",&xMax);
  printf("Enter xMin: ");
  scanf ("%lf",&xMin);

  FILE *myFile;
  myFile = fopen("nums.txt", "r");
  if (myFile == NULL)
        exit(EXIT_FAILURE);
 while ((read = getline(&line, &len, myFile)) != -1) {
        printf("Retrieved line of length %zu:\n", read);
        printf("%s", line);
        size++;
  }

  FILE *fp = fopen("result.txt", "w");
  if (fp == NULL)
  {     printf("Error opening file!\n");
      exit(1);
  }

  rewind(myFile);

  double xvalue[size];
  double yvalue[size];

  double range;
  double xStep;

  for (i = 0; i < size; i++)
  {
      fscanf(myFile, "%lf%lf", &xvalue[i], &yvalue[i]);
      printf("Input %d: %lf %lf\n",i, xvalue[i], yvalue[i]);
  }

  // calculate and export the broadening result to a file
  range = xMax-xMin;
  xStep = range/100;

  double x = xMin;
  while(x <= xMax){
    double y = 0.0;
    for ( i = 0; i<size; i++){
      if(fabs(x - xvalue[i]) <= 3 * sigma ){
        y=y+yvalue[i]/(sigma*sqrt(2*acos(-1)))*exp(-1.0*pow((x - xvalue[i]), 2)/(2.0*sigma*sigma));
      }
    }

    fprintf(fp, "%lf %lf\n", x, y);
    printf("Output: %lf %lf\n", x, y);
    x = x + xStep;
 }

  fclose(myFile);
  fclose(fp);
  if (line)
     free(line);
  exit(EXIT_SUCCESS);
}
