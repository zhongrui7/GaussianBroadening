!---------------------------
PROGRAM GaussianBroadening
!------------------------------------------------------------------------------------------------------------
! Purpose : Perform a Gaussian broadening on a set of impulse signal data as input.
! 
! Suppose the input data are sorted in ascending order
! Usage:  ./command input_file sigma
! ...
!          in which, command     : Gb_v2.x
!                    input_file  : filename of impulse data
!                    sigma       : The standard deviation of the distribution is ⁠σ⁠ (sigma)
!------------------------------------------------------------------------------------------------------------
!
implicit none

integer, parameter     :: dp = kind(1.0d0)
real(dp), allocatable  :: X0(:), Y0(:) ! 0 - input, no 0 - output
real(dp) ::  X, Y, Xmin, Xmax, sigma, step, pi  
integer  :: i, j, nline, stat  ! nline: number of lines
integer, parameter     :: inputfile = 10, outputfile = 20
character(len=20)      :: arg, input, output
character(len=100)     :: temp
logical  :: alive

pi = 2.0 * acos(0.0_dp)

CALL getarg(1, arg)
input = trim(arg)

inquire(file=input, exist=alive)
if( .not. alive) then
   write(*,*) input, "input_file does not exist! "
   write(*,*) input, "Usage:  ./command input_file sigma"
   stop
end if

call getarg(2, arg)
read(arg, *) sigma
step = sigma/10

! Open and count the number of lines in the input file
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

! Read in data from the input file
do i = 1, nline
     read(unit=inputfile,FMT=*,iostat=stat) X0(i), Y0(i)
end do

Xmin = X0(1) - 5.0*sigma
Xmax = X0(nline) + 5.0*sigma

! Create a new filename with the suffix
 output = trim(input) // trim("_GB.dat")
 open(unit=outputfile,file=output, status='replace',  action='write')
 write(outputfile,*) "./command input_file step sigma"
 write(outputfile,*) " inputfile= ", input
 write(outputfile,*) " step= ", step
 write(outputfile,*) " sigma= ",sigma

X = Xmin
do while(X .le. Xmax)
     Y = 0.0
     do i = 1, nline
       if( abs(X - X0(i)) .le. 3 * sigma ) then
         Y = Y + Y0(i)/(sigma*sqrt(2*pi)) * exp(-1.0*(X - X0(i))**2.0 &
             /(2.0*sigma*sigma) )
       end if
     end do
   ! Uncomment the following line if you want to export the broadening result to a file
   !  write(unit=outputfile,fmt="(F9.1,1X,F15.8)") X, Y
     write(*,fmt="(F9.1,1X,F15.8)") X, Y
     X = X + step
end do

! release memory
deallocate(X0, Y0)

stop
END PROGRAM GaussianBroadening
