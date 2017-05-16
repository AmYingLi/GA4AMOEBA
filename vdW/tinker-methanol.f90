!module share_type
!end module
!-----------------------------------------------------------------------------
program PGA_for_fitting
!-----------------------------------------------------------------------------
use mpi
!use share_type
implicit none
TYPE :: myData
    double precision :: num(12)
    integer :: my_rank
END TYPE myData
integer :: i, j, N, istat
type (myData), allocatable :: array(:)
integer :: ierr, myid, nprocs
integer, parameter :: length=32
integer :: chrom(length)
double precision, allocatable :: rand(:), x(:)
integer :: xsite, rand0, rand1
double precision :: parents(2)
integer, parameter :: Nconfigs=751
double precision :: Ftt(Nconfigs), DFTE(Nconfigs)
character(24) :: fname, efile
character(11) :: folder
double precision :: mse, corrl, sum_xy, sum_x2, sum_y2, sum_x, sum_y
double precision :: sam, rate
integer :: countt

open(29, file="c_in.txt", form="formatted")
read(29, *) N
allocate(array(N), stat=istat)
do i =1, N
   read(29, *) array(i)%num(1:12), array(i)%my_rank
enddo 
close(29)
 
call MPI_INIT(ierr)
call MPI_COMM_RANK(MPI_COMM_WORLD, myid, ierr)
call MPI_COMM_SIZE(MPI_COMM_WORLD, nprocs, ierr)

allocate(x(12), rand(nprocs), stat=istat)
do i =2, 12
999 &   
    call random_number(rand)
    rand0 = ceiling(rand(mod(myid+1,nprocs)+1)*N)
    rand1 = ceiling(rand(mod(myid+2,nprocs)+1)*N)
    xsite = floor(rand(mod(myid+3,nprocs)+1)*32)
    if(rand0==0.or.rand1==0) goto 999
    parents(1)= array(rand0)%num(i)
    parents(2)= array(rand1)%num(i)
    call crossover(parents, xsite, chrom)
    if(rand(mod(myid+4,nprocs)+1)<0.75) call mutation(chrom, length-xsite, chrom)
    call decypher(chrom, x(i))
    if((i==2) .and. (x(i)>4.0 .or. x(i)<3.0)) goto 999
    if((i==3) .and. (x(i)>0.15 .or. x(i)<0.10)) goto 999
    if((i==4) .and. (x(i)>3.0 .or. x(i)<2.0)) goto 999
    if((i==5) .and. (x(i)>0.02 .or. x(i)<0.01)) goto 999
    if((i==6) .and. (x(i)>0.95 .or. x(i)<0.9)) goto 999
    if((i==7) .and. (x(i)>4.0 .or. x(i)<3.0)) goto 999
    if((i==8) .and. (x(i)>0.15 .or. x(i)<0.10)) goto 999
    if((i==9) .and. (x(i)>3.0 .or. x(i)<2.0)) goto 999
    if((i==10) .and. (x(i)>0.03 .or. x(i)<0.02)) goto 999
    if((i==11) .and. (x(i)>0.95 .or. x(i)<0.9)) goto 999
    if((i==12) .and. (x(i)>2.250 .or. x(i)<1.250)) goto 999
    call MPI_BARRIER(MPI_COMM_WORLD, ierr)
enddo

write (folder, '("KEY/",i6.6,"/")' ) myid
call system ( "rm -r " // folder)

call system ( "mkdir " // folder )
call system ( " cp command.sh " // folder )
call system ( " cp amoeba09.prm " // folder )
call system ( " cp analyze " // folder )

fname="KEY/XXXXXX/molecules.key"
write(fname(5:10),'(i6.6)') myid
open(31, file=fname, form="formatted")
write(31, '(a26)') "parameters    amoeba09.prm"
write(31, '(a3,6x,i2,4x,2f10.4)') "vdw", 36, x(2), x(3)
write(31, '(a3,6x,i2,4x,2f10.4,f10.2)') "vdw", 37, x(4), x(5), x(6)
write(31, '(a3,6x,i2,4x,2f10.4)') "vdw", 38, x(7), x(8)
write(31, '(a3,6x,i2,4x,2f10.4,f10.2)') "vdw", 39, x(9), x(10),x(11)
close(31)

open(27, file="./IE_kcal", form="formatted")
do i =1, Nconfigs
   read(27, *) DFTE(i)
enddo
close(27)
call chdir (folder)
call system ( "cp molecules.key methanol.key")
call system ( "sh command.sh")
call chdir("../../")

efile="KEY/XXXXXX/molecules.iie"
write(efile(5:10),'(i6.6)') myid
open(28, file=efile, form="formatted")
do i =1, Nconfigs
   read(28, *) Ftt(i)
enddo
close(28)


mse = 0d0
corrl = 0d0
sum_xy = 0d0
sum_x = 0d0
sum_y = 0d0
sum_x2 = 0d0
sum_y2 = 0d0
do n =1, Nconfigs
   mse = (Ftt(n)-DFTE(n)+x(12))*(Ftt(n)-DFTE(n)+x(12)) + mse
   sum_xy = sum_xy + Ftt(n)*(DFTE(n)-x(12)) 
   sum_x = sum_x + Ftt(n)
   sum_y = sum_y + (DFTE(n)-x(12))
   sum_x2 = sum_x2 + Ftt(n)*Ftt(n)
   sum_y2 = sum_y2 + (DFTE(n)-x(12))*(DFTE(n)-x(12))
enddo
mse = sqrt(mse/Nconfigs)
corrl=(Nconfigs*sum_xy-sum_x*sum_y)/(sqrt(Nconfigs*sum_x2-sum_x*sum_x)*sqrt(Nconfigs*sum_y2-sum_y*sum_y))
if (corrl.gt. 0d0) x(1) = mse +1d0/corrl
if (corrl.le. 0d0) x(1) = mse +999d0

if(myid == 0) write(*,*) nprocs
call MPI_BARRIER(MPI_COMM_WORLD, ierr)

if (x(1)<=array(rand0)%num(1).and.x(1)<=array(rand1)%num(1)) then
   write(*, '(12f16.6, i9)') x(1:12), myid
else
   write(*, '(12f16.6, i9)') array(rand0)%num(1:12), rand0
endif

call MPI_FINALIZE(ierr)
end program

!---------------------------------------------------------------------------------------------------------------
subroutine mutation(old, xsite, new)
implicit none
integer :: i
integer, intent(in) :: old(32), xsite
integer, intent(out) :: new(32)
new(1:32)=old(1:32)
new(xsite) = 1 - old(xsite)
end subroutine 

subroutine crossover(parents, xsite, child)
implicit none
integer :: i
double precision, intent(in) :: parents(2)
integer, intent(in) :: xsite
integer, intent(out) :: child(32)
integer :: parentA(32), parentB(32)
child(1:32) = 0
call cypher(parents(1), parentA)
call cypher(parents(2), parentB)
child(1:xsite)=parentA(1:xsite)
child(xsite+1:32)=parentB(xsite+1:32)
end subroutine

subroutine cypher(input, output)
implicit none
integer :: i
double precision, intent(in) :: input
integer, intent(out) :: output(32)
double precision :: Frac, inputy
integer :: Inte

output(1:32) = 0
if(input<0d0) then
   output(32)=1
   inputy=-1*input
else 
   inputy=input
endif

Inte = int(inputy)
Frac = input - Inte

if (Inte /= 0 ) then
   do i = 1, 16
      output(17-i)=mod(Inte, 2)
      Inte = Inte/2
   enddo
endif

do i=17, 31
   Frac = Frac*2
   output(i)= int(Frac)
   if(output(i)==1) then
      Frac = Frac-output(i)
   endif
enddo
end subroutine

subroutine decypher(input, output)
implicit none
integer :: i
integer, intent(in) :: input(32)
double precision, intent(out) :: output
double precision :: Frac
integer :: Inte

Inte = 0
Frac = 0d0
do i =1, 16
   Inte = Inte + input(i)*2**(16-i)
enddo

do i =17, 31
   Frac = Frac + real (input(i))/2**(i-16)
enddo
output = real(Inte) +Frac
if(input(32)==0) then
   output = 1.d0*(output)
else
   output = -1.d0*(output)
endif
end subroutine
