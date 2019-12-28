!---------------------------
PROGRAM GaussianBroadening
!------------------------------------------------------------------------------------------------------------
!
! Purpose : Perform a Gaussian broadening on a set of impulse signal
! data as input.
!           Sigma will be calculated from the height of the impulses  signal.
!           You must input the range and the step of the output data in
!           the proper order.
!           No output file to be written, since it is designed to output
!           to standard screen
!           so as to work with gnuplot, as usage shown below.
!           if you want to get an output file with final data,
!           uncomment related 2 lines.
!           you would get 'g-broadened.dat'
! Usage:  ./command input_file min max step sigma
! UsageEx : plot '< gbroad.x input.dat width Xmin Xmax Xstep < ' u 1:2
! ...
!           in which, width     : FWHM, full width at half maximum,        e.g., 3.0
!                     Xmin, Xmax: the range of X in output, e.g., 500          3000
!                     Xstep     : the increment of X in the output,  e.g., 2
!------------------------------------------------------------------------------------------------------------
!
implicit none

integer, parameter     :: dp = kind(1.0d0)
character(len=20)      :: arg, input
character(len=100)     :: temp
real(dp), allocatable  :: X0(:), Y0(:) ! 0 - input, no 0 - output
integer,parameter      :: inputfile = 10, outputfile = 20
real(dp) ::  X, Y, Xmin, Xmax, Ysum, Yavg, sigma, step, pi ! sigma2 is sigmasquare
integer  :: i, j, nline, stat  ! nline: number of lines
logical  :: alive

CALL getarg(1, arg)
input = trim(arg)

inquire(file=input, exist=alive)
if( .not. alive) then
   write(*,*) input, "input_file does not exist! "
   write(*,*) input, "Usage:  ./command input_file min max step sigma"
   stop
end if

call getarg(2, arg)
read(arg, *) Xmin
call getarg(3, arg)
read(arg, *) Xmax
call getarg(4, arg)
read(arg, *) step
call getarg(5, arg)
read(arg, *) sigma

! open and count number of lines in input file
open(unit=inputfile, file=input, access="sequential", status="old")

nline = 0
do
     read(unit=inputfile, FMT=*, END=100) temp
     nline = nline + 1
end do
100 continue

rewind(inputfile)

! allocate memory for arrays X0, Y0
allocate(X0(1:nline), Y0(1:nline))

! read in data from input file
do i = 1, nline
     read(unit=inputfile,FMT=*,iostat=stat) X0(i), Y0(i)
end do

! Uncomment the following line if you want to output to file
! open(unit=outputfile,file="g-broadended.dat", status='replace',  action='write')
! write(outputfile,*) "./command input_file Xmin Xmax step sigma"
! write(outputfile,*) " inputfile= ", input
! write(outputfile,*) " Xmin= ", Xmin
! write(outputfile,*) " Xmax= ", Xmax
! write(outputfile,*) " step= ", step
! write(outputfile,*) " sigma= ",sigma

pi = 2.0 * acos(0.0_dp)

X = Xmin
do while(X .le. Xmax)
     Y = 0.0
     do i = 1, nline
       if( abs(X - X0(i)) .le. 3 * sigma ) then
         Y = Y + Y0(i)/(sigma*sqrt(2*pi)) * exp(-1.0*(X - X0(i))**2.0 &
             /(2.0*sigma*sigma) )
       end if
     end do
   ! uncomment the following line if you want to output to file
   !  write(unit=outputfile,fmt="(F9.1,1X,F15.8)") X, Y
     write(*,fmt="(F9.1,1X,F15.8)") X, Y
     X = X + step
end do

! release memory
deallocate(X0, Y0)

stop
END PROGRAM GaussianBroadening
