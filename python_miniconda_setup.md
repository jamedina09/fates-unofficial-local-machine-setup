## Miniconda-Python Configuration on MacOS Sonoma

Miniconda will install Python and a couple of other packages. Everything will be bundle together.
Miniconda also comes with conda. Conda is a package manager that will help you install packages that are not included by default.

If you do not want to use Miniconda, you can install Python from the official Python website.
However, using Miniconda is easy because is nice to create environments and manage packages.

### Installing Miniconda

Go to:
https://docs.anaconda.com/miniconda/

Download the installer for MacOS, click it, and follow the instructions.

### Use Python
Miniconda install a python version. The installed version in my system is Python 3.12.4. You can check your version by typing in the terminal:
```bash
python --version
```

### Create a new environment
You can create a new environment by typing in the terminal:

```bash
conda create --name test_env python=3.7
```

### Activate the environment

```bash
conda activate test_env
```

### Check the version of Python

```bash
python --version
```
It should be the same version that you installed in the environment.

### Check installed packages
    
```bash
conda list
```

### Install a package

```bash
conda install numpy
```

### Check the installed packages again

The new package should be listed.

```bash
conda list
```

### Deactivate the environment

```bash
conda deactivate
```

### Delete the environment

This environment was created for testing purposes. You can delete it by typing in the terminal:

```bash
conda remove --name test_env --all
```


### Check available environments

```bash
conda env list
```

### Tell conda to not activate the base environment every time you open a terminal

When you open a terminal, conda will activate the base environment by default. You can tell conda to not activate the base environment by typing in the terminal:

```bash
conda config --set auto_activate_base false
```

If you want to activate the base environment, you can type in the terminal:

```bash
conda activate
```

If you want any other environment (e.g., test_env; created above), you can type in the terminal:

```bash
conda activate test_env
```
