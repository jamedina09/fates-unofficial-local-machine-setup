## Port CTSM Using Homebrew on MacOS Sonoma

## Homebrew
Homebrew is a package manager for macOS that simplifies the installation of software packages and libraries. It provides a convenient way to install, update, and manage software dependencies on macOS systems. Homebrew uses a formula system to define how software packages are built and installed, making it easy to install and maintain a wide range of software tools and libraries.

The link for Homebrew is: https://brew.sh/

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


##  GCC
```bash
brew install gcc@14 
cd /usr/local/bin
````

Create symbolic links to the gcc, g++, and gfortran executables.

```bash
ln -s gcc-14 gcc
ln -s g++-14 g++
ln -s gfortran-14 gfortran
````
## Modify brew env variables

Check the environment variables used by default by brew by typing:

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


## OpenMPI
```bash
brew install open-mpi --cc=gcc-14 --build-from-source
````

<!--- brew install mpich --cc=gcc-14 --build-from-source -->


## HDF5
```bash
brew install hdf5-mpi --cc=gcc-14 --build-from-source
````

<!-- brew install hdf5 --cc=gcc-14 --build-from-source  -->

## NETCDF
```bash
brew install pnetcdf --cc=gcc-14 --build-from-source 
````
Check installation by typing: 
```bash
pnetcdf-config --all
````

<!---
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
-->

## To avoid potential problems with brew
Homebrew always upgrades the packages when there is a new version. For example, if brew automatically upgrades gcc, then, packages like open-mpi or pnetcdf won't work properly. The solution is to tell brew to not update certain packages with the option brew pin.More details here:

https://docs.brew.sh/FAQ#how-do-i-stop-certain-formulae-from-being-updated

```bash
brew pin gcc@14 
brew pin open-mpi
brew pin hdf5-mpi
brew pin pnetcdf
````

## Testing installations

I provide testing files in the folder testing. You can download them and test the installation of the packages.

Inside each file, you will find at the end the command to compile the file. 

## ESMF

To run the model, we need to install the National Unified Operational Prediction Capability (NUOPC) layer, which is a common model architecture for constructing coupled models from a set of interoperable components.

The link to download is here: https://earthsystemmodeling.org/

- Create a folder in the home directory to install ESMF. 

```bash
cd ~
mkdir opt
cd opt

````

- Download the .tar.gz file to that folder and unzip it. 

```bash
wget https://github.com/esmf-org/esmf/archive/refs/tags/v8.6.1.tar.gz
tar -zxvf v8.6.1.tar.gz
cd esmf-8.6.1
````

- Export environmental variables:

```bash
export ESMF_DIR=/Users/MedinaJA/esmf/esmf-8.6.1
export ESMF_COMPILER=gfortran
export ESMF_COMM=openmpi
export ESMF_PNETCDF=pnetcdf-config
export ESMF_PNETCDF_INCLUDE=/usr/local/Cellar/pnetcdf/1.13.0/include
export ESMF_PNETCDF_LIBPATH=/usr/local/Cellar/pnetcdf/1.13.0/lib
export ESMF_PNETCDF_LIBS='-lpnetcdf'
export ESMF_PIO=internal
````
- Install as follows:

```bash
gmake -j8 
gmake install
````

## INSTALL CTSM

-	Clone the CTSM repository to your home directory from the specified GitHub URL:
```bash
git clone git@github.com:ESCOMP/CTSM.git --branch ctsm5.1.dev160 temp-folder && mv temp-folder CTSM_5_1_dev160
````

Note: if you see complaints about git-lfs, install:
```bash
brew install git-lfs
````

## INSTALL FATES

-	Move into the newly cloned CTSM directory - make sure you go to the right one.
```bash
cd CTSM_5_1_dev160
````
-	Run the script to manage external dependencies and check out required code
```bash
./manage_externals/checkout_externals
````

## MACHINE AND COMPILERS DEFINITION
In your home directory, you need to have a folder called .cime. Inside this folder, there are a couple fo files that you need to modify. 

More details can be found here: https://esmci.github.io/cime/versions/master/html/users_guide/porting-cime.html

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

````