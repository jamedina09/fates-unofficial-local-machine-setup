## Port CTSM Using Homebrew and Source Packages on MacOS Sonoma

I am using a combination between Homebrew and source installation packages because of simplicity. With Sonoma, Apple have provided an updated Xcode version 15.0 (and Command Line Tools) which does not allow to install GCC from source; or I have not found a way to do it. With previos versions of MacOS, I was able to install GCC and the other packages from source. If you want a go at it, you can try to install GCC from source, and details are explained in [macOS Sonoma Source Installation - Intel](./os-macos-sonoma-intel.md). For simplicity, I will use Homebrew to install GCC, and then use that installation to install the other packages from source. 

## Homebrew

Homebrew is a package manager for macOS that simplifies the installation of software packages and libraries. It provides a convenient way to install, update, and manage software dependencies on macOS systems. Homebrew uses a formula system to define how software packages are built and installed, making it easy to install and maintain a wide range of software tools and libraries.

The link for Homebrew is: <https://brew.sh/>

To install it, open terminal and type:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
````

It will ask for your password multiple times. Type it and press enter.

### Install cmake, make, and wget

```bash
brew install make cmake wget 
````

Check the installation

```bash
brew list
cmake --version
make --version
wget --version
````

You'll get several messages when installing the packages. One of these messages is as follows:

```bash
GNU "make" has been installed as "gmake".
If you need to use it as "make", you can add a "gnubin" directory
to your PATH from your bashrc like:

    PATH="/usr/local/opt/make/libexec/gnubin:$PATH"
````

To use the installed ***gmake*** instead of the default ***make***, we need to add the following line to the PATH:

```bash
echo 'export PATH=/usr/local/opt/make/libexec/gnubin:$PATH' >> ~/.zshrc
````

Then, reload the .zshrc file.

```bash
source ~/.zshrc
````

## GCC

I'm installing gcc with homebrew. The other packages required by CTSM and FATES will be installed from source.

GCC can be isntalled form source, but you need an older version of command line tools when using the latest version of macOS. In MacOS BigSur, this is not a problem.

```bash
brew install gcc@14 
cd /usr/local/bin
````

Create symbolic links to the gcc and g++, and gfortran executables.

gfortran per-se was already available, so there was no need to create a symbolic link for it.

If that's not the case for you, include the line: ln -s gfortran-14 gfortran

```bash
ln -s gcc-14 gcc
ln -s g++-14 g++
````

Check wether the symbolic links were created successfully by typing:

```bash
gcc --version
g++ --version
gfortran --version

````

## Modify brew env variables

If you install packages using brew, you may want to use gcc-14 by default. To do this, you need to set the environment variables HOMEBREW_CC and HOMEBREW_CXX to gcc-14 and g++-14, respectively.

- Check the environment variables used by default by brew by typing:

```bash
brew --env
````

- To have brew always use gcc, add the following to your .zshrc (or .bash_profile) file:

```bash
alias brew='HOMEBREW_CC=gcc-14 HOMEBREW_CXX=g++-14 brew'
````

- source the .zshrc file to apply the changes.

```bash
source ~/.zshrc
````

- Check the environment variables used by brew again:

```bash
brew --env
````

The output should show the new environment variables.

```bash
HOMEBREW_CC: gcc-14
HOMEBREW_CXX: g++-14
...
````

You'll notice that when I install any package using brew, I explicitly tell brew to use gcc-14 (i.e., --cc=gcc-14). This may not be necessary as I have already set the environment variables to use gcc-14. However, I prefer to be explicit about it.

## Installing packages from source

When installing software packages from source, it is essential to follow a consistent and organized approach to ensure that the build process is successful and that the software is correctly installed. Here are the general steps to install packages from source:

Let's create a folder called "opt" in the home directory. In this folder, we will store all downloaded packages that will be installed from source.

Change directory to the user's home directory

```bash
cd ~
````

- Create a new directory called 'opt'

```bash
mkdir opt
````

- Navigate into the newly created 'opt' directory

```bash
cd ~/opt
````

## MPICH

MPICH is an implementation of the Message Passing Interface (MPI), a standardized and widely used programming model for developing parallel and distributed computing applications. MPI is specifically designed for building applications that run on multiple processors or compute nodes, enabling efficient communication and coordination between these processes. MPICH provides the infrastructure and runtime support needed to create and manage parallel programs that can be executed on clusters, supercomputers, and other distributed computing environments.

- Change directory to the user's 'opt' directory

```bash
cd ~/opt
````

- Create a new directory called 'mpich'

```bash
mkdir mpich
````

- Navigate into the newly created 'mpich' directory

```bash
cd mpich
````

- Download the MPICH version 4.2.2 source code archive using wget

```bash
wget https://www.mpich.org/static/downloads/4.2.2/mpich-4.2.2.tar.gz
````

- Extract the downloaded MPICH source code archive

```bash
tar -zxvf mpich-4.2.2.tar.gz
````

- Navigate into the extracted MPICH source code directory

```bash
cd mpich-4.2.2
````

- Configure the MPICH build with specified options:
- Install MPICH in /usr/local/mpich-4.1.2 directory
- Use specific GCC compiler versions for C, C++, and Fortran

```bash
./configure --prefix=/usr/local/mpich \
CC=/usr/local/bin/gcc-14 \
CXX=/usr/local/bin/g++-14 \
FC=/usr/local/bin/gfortran-14 \
FC77=/usr/local/bin/gfortran-14
````

Note that i'm explicitly calling the gcc-14, g++-14, and gfortran-14 compilers. This may not be necessary as I have already created their symbolic links. However, I prefer to be explicit about it.

Also note I'm defining the same gfortran for FC and FC77. Modern Fortran compilers, such as gfortran (from GCC), are capable of compiling both Fortran 77 and newer Fortran standards.

- Build MPICH using multiple CPU cores (specified by -j8)

```bash
sudo make -j8
````

- Install MPICH

```bash
sudo make install
````

- Append the MPICH bin directory to the user's shell PATH in the .zshrc file

```bash
echo 'export PATH=/usr/local/mpich/bin:$PATH' >> ~/.zshrc
````

- Reload the updated .zshrc file to apply the new PATH configuration

```bash
source ~/.zshrc
````

## Testing installations

Here we need to verify whether the installations of GCC and MPICH were successful. Several files are located in the folder "testing". I did not author these testing files; I'll provide the links when I remember where I got them from. These files will help us determine the success of the installations. If the exercises fail, it indicates an incorrect installation, requiring us to repeat the process. Execute these files. If you do not know how to do it, open each file and check the last two commented lines.

## EXPAT

Expat is an XML parsing library that provides a set of functions and tools for reading, interpreting, and manipulating XML (eXtensible Markup Language) documents. XML is a widely used markup language for structuring and representing data in a human-readable and machine-readable format. Expat allows software applications to efficiently parse and process XML data, making it an essential component for various programming tasks involving XML.

- Change directory to the user's 'opt' directory

```bash
cd ~/opt
````

- Create a new directory called 'expat'

```bash
mkdir expat
````

- Navigate into the newly created 'expat' directory

```bash
cd expat
````

- Download the Expat version 2.6.3 source code archive using wget

```bash
wget https://github.com/libexpat/libexpat/releases/download/R_2_6_3/expat-2.6.3.tar.gz
````

- Extract the downloaded Expat source code archive

```bash
tar -zxvf expat-2.6.3.tar.gz
````

- Navigate into the extracted Expat source code directory

```bash
cd expat-2.6.3 
````

- Configure the Expat build using default options
The last two lines are not necessary. I'm just being explicit about the compilers I'm using.

```bash
./configure \
CC=/usr/local/bin/gcc-14 \
CXX=/usr/local/bin/g++-14 \
FC=/usr/local/bin/gfortran-14 \
FC77=/usr/local/bin/gfortran-14
````

- Build Expat using multiple CPU cores (specified by -j8)

```bash
sudo make -j8
````

- Install Expat

```bash
sudo make install
````

## ZLIB

ZLIB is a widely used software library for data compression. It provides a set of functions and algorithms for compressing and decompressing data, which is useful for reducing the size of files or data streams for storage or transmission. ZLIB is commonly used in a variety of applications, including file formats like gzip and PNG, network protocols, and software distributions. It employs the Deflate compression algorithm, which combines LZ77 compression and Huffman coding.

Installing libraries like zlib before installing HDF5 (Hierarchical Data Format) and NetCDF (Network Common Data Form) is important because these libraries are often dependencies of HDF5 and NetCDF.

Check latest version here:
<https://www.zlib.net/>

- Navigate to the home directory and create a folder named "zlib" to work in.

```bash
cd ~/opt
mkdir zlib
cd zlib
````

- Download the ZLIB source code archive from the specified URL.

```bash
wget http://www.zlib.net/zlib-1.3.1.tar.gz
````

- Extract and navigate to the downloaded archive.

```bash
tar -zxvf zlib-1.3.1.tar.gz
cd zlib-1.3.1
````

- Configure the build process, specifying the installation prefix. This sets the destination directory for the installed files.

```bash
./configure --prefix=/usr/local/hdf5_zlib
````

- Compile the code and run the tests, making use of multiple CPU cores (-j8).

I included testing in the make command. If you want to skip testing, you can remove the check option.

```bash
sudo make -j8 install
sudo make -j8 check
````

## HDF5

HDF5 (Hierarchical Data Format version 5) is a versatile and flexible file format and library designed for managing and storing large and complex datasets. It is widely used in scientific computing, data analysis, and research environments to handle structured and unstructured data, as well as metadata. HDF5 provides features for data organization, compression, parallel I/O, and portability across different platforms and programming languages. It is especially popular in fields such as astronomy, climate modeling, and other scientific domains where efficient data storage, access, and sharing are essential.

- Navigate to the home directory and create a folder named "hdf5" to work in.

```bash
cd ~/opt
mkdir hdf5
cd hdf5
````

- Download the HDF5 source code archive from the specified URL.

```bash
wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.14/hdf5-1.14.4/src/hdf5-1.14.4-3.tar.gz
````

- Extract and navigate to the downloaded archive.

```bash
tar -zxvf hdf5-1.14.4-3.tar.gz
cd hdf5-1.14.4-3
````

- Configure the build process, specifying the zlib installation directory and installation prefix. Enabling Fortran and parallel features, and using the mpicc compiler for parallel support.

```bash
./configure --with-zlib=/usr/local/hdf5_zlib \
--prefix=/usr/local/hdf5_zlib \
--enable-fortran \
--enable-parallel \
CC=/usr/local/mpich/bin/mpicc \
CXX=/usr/local/mpich/bin/mpicxx \
FC=/usr/local/mpich/bin/mpif90 \
FC77=/usr/local/mpich/bin/mpif77
````

- Compile the code and run tests using multiple CPU cores (-j8).

Testing the installation takes long time. If you want to install and then test, do can do the following. If you dont want to test, you can remove the second line, with the check option.

```bash
sudo make -j8 install
sudo make -j8 check

````

- Add HDF5 binaries to the PATH environment variable.

```bash
echo 'export PATH=/usr/local/hdf5_zlib/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
````

### NETCDF-C

NetCDF (Network Common Data Form) is a set of software libraries and data formats designed for storing, accessing, and sharing scientific data. It provides a standardized way to represent and organize various types of data, making it particularly well-suited for applications in the fields of atmospheric, oceanic, and climate sciences, as well as other scientific domains.

- Navigate to the home directory and create a folder named "netcdf-c" to work in.

```bash
cd ~/opt
mkdir netcdf-c
cd netcdf-c
````

- Download the NetCDF-C source code archive from the provided URL.

```bash
wget https://downloads.unidata.ucar.edu/netcdf-c/4.9.2/netcdf-c-4.9.2.tar.gz
````

- Extract the downloaded archive.

```bash
tar -zxvf netcdf-c-4.9.2.tar.gz
````

- Move into the extracted directory.

```bash
cd netcdf-c-4.9.2
````

- Set compiler and linker flags for HDF5 and zlib libraries. Configure the build process, specifying installation prefix and enabling parallel tests.

```bash
./configure \
CPPFLAGS=-I/usr/local/hdf5_zlib/include \
LDFLAGS=-L/usr/local/hdf5_zlib/lib \
--prefix=/usr/local/netcdf \
--enable-parallel-tests \
CC=mpicc \
CXX=mpicxx \
FC=mpif90 \
FC77=mpif77
````

- Compile the code and run tests using multiple CPU cores (-j8).

I included testing in the make command. If you want to skip testing, you can remove the check option.

```bash
sudo make -j8 install
sudo make -j8 check
````

- Add NetCDF binaries to the PATH environment variable.

```bash
echo 'export PATH=/usr/local/netcdf/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
````

- Check NetCDF configuration using nc-config.

```bash
nc-config --all
````

## NETCDF-FORTRAN

NetCDF-Fortran is a component of the NetCDF software suite that provides Fortran language bindings for working with NetCDF data files. Fortran is a programming language commonly used in scientific and engineering applications, and NetCDF-Fortran allows Fortran programs to read from and write to NetCDF files seamlessly. It extends the capabilities of the core NetCDF library by enabling Fortran-specific data manipulation and access.

- Navigate to the home directory and create a folder named "netcdf-fortran" to work in.

```bash
cd ~/opt
mkdir netcdf-fortran
cd netcdf-fortran
````

- Download the NetCDF-Fortran source code archive from the provided URL.

```bash
wget https://downloads.unidata.ucar.edu/netcdf-fortran/4.6.1/netcdf-fortran-4.6.1.tar.gz
````

- Extract the downloaded archive.

```bash
tar -zxvf netcdf-fortran-4.6.1.tar.gz
cd netcdf-fortran-4.6.1
````

- Set the Fortran compiler, compiler flags, and linker flags for NetCDF library. Configure the build process, specifying installation prefix and enabling parallel tests.

```bash
./configure \
CPPFLAGS=-I/usr/local/netcdf/include \
LDFLAGS=-L/usr/local/netcdf/lib \
--prefix=/usr/local/netcdf \
--enable-parallel-tests \
CC=mpicc \
CXX=mpicxx \
FC=mpif90 \
FC77=mpif77
````

- Compile the code and run tests using multiple CPU cores (-).

```bash
sudo make -j8 install
sudo make -j8 check
````

- Check NetCDF configuration using nc-config.

```bash
nf-config –all
````

## ESMF

To run the model, we need to install the National Unified Operational Prediction Capability (NUOPC) layer, which is a common model architecture for constructing coupled models from a set of interoperable components.

The link to download is here: <https://earthsystemmodeling.org/>

- Create a folder in the home directory to install ESMF.

```bash
cd ~
cd opt
mkdir esmf
cd esmf
````

- Download the .tar.gz file to that folder and unzip it.

```bash
wget https://github.com/esmf-org/esmf/archive/refs/tags/v8.6.1.tar.gz
tar -xvf v8.6.1.tar.gz
cd esmf-8.6.1
````

- Export environmental variables:


```bash
export ESMF_DIR=/Users/MedinaJA/opt/esmf/esmf-8.6.1
export ESMF_COMPILER=gfortran
export ESMF_COMM=mpich
export ESMF_NETCDF=nc-config
export ESMF_NETCDF_INCLUDE=/usr/local/netcdf/include
export ESMF_NETCDF_LIBPATH=/usr/local/netcdf/lib
export ESMF_NETCDF_LIBS='-lnetcdff -lnetcdf_c++ -lnetcdf'
````

- Install as follows:

```bash
make -j8
make -j8 check
````

## INSTALL CTSM

- Clone the CTSM repository to your home directory from the specified GitHub URL:

```bash
git clone git@github.com:ESCOMP/CTSM.git --branch ctsm5.1.dev160 temp-folder && mv temp-folder CTSM_5_1_dev160
````

Note: if you see complaints about git-lfs, install:

```bash
brew install git-lfs
````

## INSTALL FATES

- Move into the newly cloned CTSM directory - make sure you go to the right one.

```bash
cd CTSM_5_1_dev160
````

- Run the script to manage external dependencies and check out required code

```bash
./manage_externals/checkout_externals
````

## MACHINE AND COMPILERS DEFINITION

In your home directory, you need to have a folder called .cime. Inside this folder, there are a couple fo files that you need to modify.

More details can be found here: <https://esmci.github.io/cime/versions/master/html/users_guide/porting-cime.html>

I have provided my own files in the folder 'personal_cime_configuration_files'. You can download them and modify them according to your needs.

There are a couple of key points that I want to highlight.

You need to include the path for the nuopc driver. In my case, I have the following path:

```bash
<environment_variables comp_interface="nuopc"> <env
name="ESMFMKFILE">/Users/MedinaJA/esmf-8.4.2/lib/libO/Darwin.gfortran.64.mpich.default/esmf.mk</env>
</environment_variables>
````

## Additional packages

There are a couple of additional packages that will make your life easy.

<!---
- NCO is needed to concatenate netcdf files. 
```bash
brew install nco
````

- Ncview is a visual browser for netCDF format files.
```bash
brew install ncview
````
-->

- Panoply is a cross-platform application that plots geo-gridded and other arrays from netCDF, HDF, GRIB, and other datasets.

```bash
brew install --cask panoply
````

## TEST FATES INSTALLATION

Now that we have installed all required packages, let's run a test to check if everything is working properly.

Create a shell script named test_fates.sh

```bash

#!/bin/bash

export CIME_MODEL=cesm
export MACH=SI
export COMP=2000_DATM%QIA_ELM%BGC-FATES_SICE_SOCN_SROF_SGLC_SWAV

export SOURCE_DIR=/Users/MedinaJA/E3SM/cime/scripts # change to the path where your CTSM/cime/sripts is

cd ${SOURCE_DIR}

./create_newcase --case run1_1x1brazil --res 1x1_brazil --compset ${COMP} --mach ${MACH}

cd run1_1x1brazil

./xmlchange --id STOP_N --val 1
./xmlchange --id RUN_STARTDATE --val '2001-01-01'
./xmlchange --id STOP_OPTION --val nyears
./xmlchange --id DATM_CLMNCEP_YR_START --val 1996
./xmlchange --id DATM_CLMNCEP_YR_END --val 1997
./xmlchange --id ELM_FORCE_COLDSTART --val on

./case.setup

# ./preview_namelists
# ./check_input_data
# ./check_input_data --download


./case.build


````

<!--- ## OpenMPI

```bash
brew install open-mpi --cc=gcc-14 --build-from-source
````

 brew install mpich --cc=gcc-14 --build-from-source 

## HDF5

```bash
brew install hdf5-mpi --cc=gcc-14 --build-from-source
````

brew install hdf5 --cc=gcc-14 --build-from-source

## NETCDF

```bash
brew install pnetcdf --cc=gcc-14 --build-from-source 
````

Check installation by typing:

```bash
pnetcdf-config --all
````

## NETCDF
```bash
brew install netcdf --cc=gcc-14 --build-from-source 
````
Check installation by typing: 
```bash
nc-config --all
````

## NETCDF-FORTRAN
```bash
brew install netcdf-fortran --cc=gcc-14 --build-from-source 
````
Check installation by typing: 
```bash
nf-config
````

## To avoid potential problems with brew

Homebrew always upgrades the packages when there is a new version. For example, if brew automatically upgrades gcc, then, packages like open-mpi or pnetcdf won't work properly. The solution is to tell brew to not update certain packages with the option brew pin.More details here:

<https://docs.brew.sh/FAQ#how-do-i-stop-certain-formulae-from-being-updated>

```bash
brew pin gcc@14 
brew pin open-mpi
brew pin hdf5-mpi
brew pin pnetcdf
````
-->
