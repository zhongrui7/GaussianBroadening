# GaussianBroadening
The Purpose of this code is to perform a Gaussian broadening on a set of impulse signal data as input. 

Sigma will be calculated from the height of the impulses signal.   

You must input the range and the step of the output data in the proper order.     

No output file to be written, since it is designed to output to standard screen so as to work with gnuplot, as usage shown below. 
If you want to get an output file with final data,  uncomment related 2 lines.  you would get 'g-broadened.dat' 

Usage:  ./command input_file min max step sigma

UsageEx : plot '&lt; gbroad.x input.dat width Xmin Xmax Xstep &lt; ' 
! ... !           in which, 

width     : FWHM, full width at half maximum,        e.g., 3.0 !                     
Xmin, Xmax: the range of X in output, e.g., 500          3000 !                     
Xstep     : the increment of X in the output,  e.g., 2 !
