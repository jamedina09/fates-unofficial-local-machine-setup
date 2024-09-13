program main
    use mpi
  
    integer error, id, p
  
    call MPI_Init ( error )
    call MPI_Comm_size ( MPI_COMM_WORLD, p, error )
    call MPI_Comm_rank ( MPI_COMM_WORLD, id, error )
    write (*,*) 'Hello: ', id, '/', p
    call MPI_Finalize ( error )
  end
! mpif90 -o hello hello.f90
! mpirun -np 4 ./hello