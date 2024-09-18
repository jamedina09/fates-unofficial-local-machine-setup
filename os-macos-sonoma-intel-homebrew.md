## Port CTSM Using Homebrew on MacOS Sonoma

## Homebrew
Homebrew is a package manager for macOS that simplifies the installation of software packages and libraries. It provides a convenient way to install, update, and manage software dependencies on macOS systems. Homebrew uses a formula system to define how software packages are built and installed, making it easy to install and maintain a wide range of software tools and libraries.

The link is: https://brew.sh/

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


BREW
Install brew following:
https://brew.sh/
GCC
brew install gcc@13 cd /usr/local/bin
ln -s gcc-13 gcc
ln -s g++-13 g++
ln -s gfortran-13 gfortran
MPICH
brew install mpich --cc=gcc-13 --build-from-source
NETCDF
brew install netcdf --cc=gcc-13 --build-from-source Check: nc-config --all
NETCDF-FORTRAN
brew install netcdf-fortran --cc=gcc-13 --build-from-source Check: nf-config
NCO
Nco is needed to concatenate netcdf files. brew install nco
NCVIEW brew install ncview
  ESMF
I installed this app on the home directory. For future use, it might be wise to include it inside another folder. I mean, create a folder for external apps in the home directory and install all apps there. This folder can also serve as a directory for manual installation of NetCDF, hdf5, and any other required for CTSM/CESM.
You need to download esmf from: https://earthsystemmodeling.org/ Unzip and install as follows:
export ESMF_DIR=/Users/MedinaJA/esmf-8.4.2
export ESMF_COMPILER=gfortran
export ESMF_COMM=mpich
export ESMF_NETCDF=nc-config
export ESMF_NETCDF_INCLUDE=/usr/local/Cellar/netcdf/4.9.2_1/include export ESMF_NETCDF_LIBPATH=/usr/local/Cellar/netcdf/4.9.2_1/lib export ESMF_NETCDF_LIBS='-lnetcdff -lnetcdf'
gmake -j8 gmake install
## the key file is installed in /Users/MedinaJA/esmf-8.4.2/lib/libO/Darwin.gfortran.64.mpich.default
## So, the key file path is: /Users/MedinaJA/esmf-8.4.2/lib/libO/Darwin.gfortran.64.mpich.default/esmf.mk
## include in config.machine
<environment_variables comp_interface="nuopc"> <env
name="ESMFMKFILE">/Users/MedinaJA/esmf-8.4.2/lib/libO/Darwin.gfortran.64.mpich.default/e smf.mk</env>
</environment_variables>
INSTALL CTSM
git clone git@github.com:ESCOMP/CTSM.git --branch ctsm5.1.dev121
cd CTSM
  ## this developer version is way ahead the last release version. I cannot run the model using the release version, I do not really knwo why, maybe there was a change between release version 35 and the current developing code?
GET FATES ./manage_externals/checkout_externals
FIX MACHINES CONFIG
Make sure that config_machines has the following line.
Machine is homebrew, you can probably change this name later on. The best would be to have your own .cime folder in the home directory, and source control it.
<DIN_LOC_ROOT_CLMFORC>$ENV{HOME}/projects/cesm-inputdata/atm/datm7</DIN_LOC_ ROOT_CLMFORC>
Also, you need to include the following line in machine:
<environment_variables comp_interface="nuopc"> <env
name="ESMFMKFILE">/Users/MedinaJA/esmf-8.4.2/lib/libO/Darwin.gfortran.64.mpich.default/e smf.mk</env>
</environment_variables>
The lines below are important for when tunning global runs. They allow running multiple cores. Check what happens if you use 8 instead of 6 the max_mpitasks_per_node.
<MAX_TASKS_PER_NODE>8</MAX_TASKS_PER_NODE> <MAX_MPITASKS_PER_NODE>6</MAX_MPITASKS_PER_NODE>
TO RUN OLMT chmod +x ./run_olmt_test.sh
TO AVOID PROBLEMS
Homebrew always upgrades the packages when there is a new version. To run FATES, packages such as mpich or netcdf where installed using gcc-13. If brew automatically upgrades
gcc, then, packages like mpich or entcdf wont work properly. This is specially a problem when you installes the driver nuoc. So, the solution is to tell brew to avoid updating certain packages with the option brew pin.
brew pin hdf5
brew pin mpich
brew pin netcdf
brew pin netcdf-fortran brew pin gcc