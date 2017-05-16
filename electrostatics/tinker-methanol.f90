!module share_type
!end module
!-----------------------------------------------------------------------------
program PGA_for_fitting
!-----------------------------------------------------------------------------
use mpi
!use share_type
implicit none
TYPE :: myData0
    double precision :: para(17)
    double precision :: rank
END TYPE myData0
TYPE :: myData
    double precision :: num(17)
    integer :: my_id
END TYPE myData
integer :: i, j, N, istat
type (myData0), allocatable :: array0(:)
type (myData), allocatable :: array(:)
integer :: ierr, myid, nprocs
integer, parameter :: length=32
integer :: chrom(length)
double precision, allocatable :: rand(:), x(:)
integer :: xsite, rand0, rand1
double precision :: parents(2)
integer, parameter :: Nconfigs=579
double precision :: Ftt(Nconfigs), DFTE(Nconfigs)
character(18) :: fname, efile
character(11) :: folder
double precision :: mse, correl, xiyi, sxi, syi, sxi2, syi2
double precision :: sam, rate
integer :: countt

open(29, file="c_in.txt", form="formatted")
read(29, *) N
allocate(array(N), array0(N), stat=istat)
do i =1, N
   read(29, *) array0(i)%para(1:17), array0(i)%rank
enddo 
close(29)

call MPI_INIT(ierr)
call MPI_COMM_RANK(MPI_COMM_WORLD, myid, ierr)
call MPI_COMM_SIZE(MPI_COMM_WORLD, nprocs, ierr)

sam = 0d0
countt = 0
do i =1, N 
   call random_number(rate)
   sam = sam + array0(i)%rank
   !if (myid == 0) print *, sam
   if (i==1 .or. sam<rate ) then
       array(i)%num(1:17)=array0(i)%para(1:17)
       array(i)%my_id =i
   elseif (i /= 1 .and. sam >= rate ) then
       countt =countt +1
       array(i)%num(1:17) = array0(countt)%para(1:17)
       array(i)%my_id = countt
   endif
       !if (myid==0) write (*, *) i, array(i)%num(1), array(i)%my_id
enddo

allocate(x(17), rand(nprocs), stat=istat)
call random_number(rand)
rand0 = ceiling(rand(mod(myid+1,nprocs)+1)*N)
rand1 = ceiling(rand(mod(myid+2,nprocs)+1)*N)
do i =2, 17
999 &   
    call random_number(rand)
    xsite = floor(rand(mod(myid+3,nprocs)+1)*32)
    !print *, myid, i, xsite, rand0, rand1
    parents(1)= array(rand0)%num(i)
    parents(2)= array(rand1)%num(i)
    call crossover(parents, xsite, chrom)
    if(rand(mod(myid+4,nprocs)+1)<0.90) call mutation(chrom, length-xsite, chrom)
    call decypher(chrom, x(i))
    if((i==2) .and. (x(i)>0.9 .or. x(i)<0d0)) goto 999
    if((i==3) .and. (x(i)>0.9 .or. x(i)<0d0)) goto 999
    if((i==4) .and. (x(i)>0.9 .or. x(i)<0d0)) goto 999
    if((i==5) .and. (x(i)>0.9 .or. x(i)<0d0)) goto 999
    if((i==6) .and. (x(i)>0.9 .or. x(i)<0d0)) goto 999
    if((i==7) .and. (x(i)>0.9 .or. x(i)<0d0)) goto 999
    if((i==8) .and. (x(i)>0.9 .or. x(i)<0d0)) goto 999
    if((i==9) .and. (x(i)>0.9 .or. x(i)<0d0)) goto 999
    if((i==10) .and. (x(i)>0.9 .or. x(i)<0d0)) goto 999
    if((i==11) .and. (x(i)>0.9 .or. x(i)<0d0)) goto 999
    if((i==12) .and. (x(i)>0.9 .or. x(i)<0d0)) goto 999
    if((i==13) .and. (x(i)>0.9 .or. x(i)<0d0)) goto 999
    if((i==14) .and. (x(i)>0.9 .or. x(i)<0d0)) goto 999
    if((i==15) .and. (x(i)>0.9 .or. x(i)<0d0)) goto 999
    if((i==16) .and. (x(i)>0.9 .or. x(i)<0d0)) goto 999
    if((i==17) .and. (x(i)>0.9 .or. x(i)<0d0)) goto 999
    call MPI_BARRIER(MPI_COMM_WORLD, ierr)
enddo

write (folder, '("KEY/",i6.6,"/")' ) myid
call system ( "rm -r " // folder)

call system ( "mkdir " // folder )
call system ( " cp command.sh " // folder )
call system ( " cp potential " // folder )

fname="KEY/XXXXXX/2me.key"
write(fname(5:10),'(i6.6)') myid
open(31, file=fname, form="formatted")
write(31, *) "atom          40    1    C     'methanol C'         6    12.011    4"
write(31, *) "atom          41    2    H     'methanol H'         1     1.008    1"
write(31, *) "atom          38    3    O     'methanol O'         8    15.999    2"
write(31, *) "atom          39    4    H     'methanol Ho'        1     1.008    1"
write(31, *) ""
write(31, *) "multipole    40   38   39               0.17663"
write(31, '(39x,3f11.6)') 0.00000,0.00000, x(2)
write(31, '(39x,f11.6)')  x(3)-x(4)
write(31, '(39x,2f11.6)') 0.00000,-x(3)
write(31, '(39x,3f11.6)') 0.00000,0.00000, x(4)
write(31, *) "multipole    41   40   38               0.04176"
write(31, '(39x,3f11.6)') 0.00000,0.00000,-x(5)
write(31, '(39x,f11.6)')  -x(6)+x(7)
write(31, '(39x,2f11.6)') 0.00000,x(6)
write(31, '(39x,3f11.6)') -x(8),0.00000,-x(7)
write(31, *) "multipole    38   39   40              -0.53482"
write(31, '(39x,3f11.6)') x(9),0.00000,x(10)
write(31, '(39x,f11.6)')  x(11)-x(12)
write(31, '(39x,2f11.6)') 0.00000,-x(11)
write(31, '(39x,3f11.6)') -x(13),0.00000,x(12)
write(31, *) "multipole    39   38   40               0.23289"
write(31, '(39x,3f11.6)') -x(14),0.00000,0.00000
write(31, '(39x,f11.6)')  x(15)-x(16)
write(31, '(39x,2f11.6)') 0.00000,-x(15)
write(31, '(39x,3f11.6)') -x(17),0.00000,x(16)
write(31, *) ""
write(31, *) "polarize    40          1.3340     0.3900    38   41"
write(31, *) "polarize    41          0.4960     0.3900    40"
write(31, *) "polarize    38          0.8370     0.3900    39   40"
write(31, *) "polarize    39          0.4960     0.3900    38"
write(31, *) ""
close(31)

!call fitnessEvaluation(fname, x(1))

call chdir (folder)
call system ( "sh command.sh")
call chdir("../../")

efile="KEY/XXXXXX/ESP.iie"
write(efile(5:10),'(i6.6)') myid
open(28, file=efile, form="formatted")
do i =1, Nconfigs
   read(28, *) Ftt(i)
enddo
close(28)


mse = 0d0
do n =1, Nconfigs
   mse = Ftt(n) + mse
enddo
mse = mse/Nconfigs
x(1) = mse

if(myid == 0) write(*,*) nprocs
call MPI_BARRIER(MPI_COMM_WORLD, ierr)

write(*, '(e14.7, 16f12.7, i9)') x(1), x(2:17), myid

call MPI_FINALIZE(ierr)
end program

!---------------------------------------------------------------------------------------------------------------
subroutine mutation(old, xsite, new)
implicit none
integer :: i
integer, intent(in) :: old(32), xsite
integer, intent(out) :: new(32)
new(1:32)=old(1:32)
!do i=1,32
!new(i)= 1- old(i)
!enddo
new(xsite) = 1 - old(xsite)
!new(32-xsite)= 1- old(32-xsite)
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
