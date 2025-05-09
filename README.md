# GaussianBroadening
 Purpose : Perform a Gaussian broadening on a set of impulse signal data as input.
           
           You must input the range and the step of the output data in the proper order.
           No output file to be written, 
           since it is designed to output to the standard screen to work with gnuplot
           
           If you want an output file with final data, uncomment the related 2 lines.
           You would get 'g-broadened.dat'
 Usage   :  ./command input_file min max step sigma
 
 UsageEx :  plot '< gbroad.x input.dat width Xmin Xmax Xstep < ' u 1:2
 ...
 
           in which, sigma     : the standard deviation of the Gaussian distribution is ⁠σ⁠ (sigma)
                     Xmin, Xmax: the range of X in the output
                     Xstep     : the increment of X in the output
------------------------------------------------------------------------------------------------------------
# Version 2 usage

gfortran -o GB_v2.x GB_v2.f90 

./command input_file sigma
