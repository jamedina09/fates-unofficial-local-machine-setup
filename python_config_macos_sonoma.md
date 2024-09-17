## Anadonda. 

Anaconda will install Python and several other packages. Everything will be bundle together.
Anaconda also comes with conda. Conda is a package manager that will help you install packages that are not included in Anaconda.
Along with conda, and Anaconda packages, it comes with other tools such as Jupyter notebooks, Jupyter lab, and Spyder.

If you do not want to use Anaconda, you can install Python from the official Python website.
However, using Anaconda is recommended because is nice to create environments and manage packages.

## Installing Anaconda

Go to:
https://www.anaconda.com/download

Insert your email and you'll get a link to download Anaconda.

## Use Python
You will have a base python version. My version is Python 3.12.4. You can check your version by typing in the terminal:
```bash
python --version
```

## Create a new environment
You can create a new environment by typing in the terminal:

```bash
conda create --name test_env python=3.7
```

## Activate the environment

```bash
conda activate test_env
```

## Check installed packages
    
```bash
conda list
```

## Install a package

```bash
conda install numpy
```

## Check the installed packages

```bash
conda list
```

## Check the version of Python

```bash
python --version
```

## Deactivate the environment

```bash
conda deactivate
```

## Delete the environment

```bash
conda remove --name test_env --all
```



