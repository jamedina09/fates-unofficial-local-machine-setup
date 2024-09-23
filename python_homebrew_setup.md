## Python Configuration on MacOS Sonoma Using Homebrew

## Homebrew

Homebrew is a package manager for macOS that simplifies the installation of software packages and libraries. It provides a convenient way to install, update, and manage software dependencies on macOS systems. Homebrew uses a formula system to define how software packages are built and installed, making it easy to install and maintain a wide range of software tools and libraries.

The link for Homebrew is: <https://brew.sh/>

To install it, open terminal and type:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
````

It will ask for your password multiple times. Type it and press enter.

## Packages to create virtual environments

- Install pyenv and pyenv-virtualenv

``` bash
brew install pyenv
brew install pyenv-virtualenv
````

- Configure .zshrc

``` bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
````

- Reload the shell

``` bash
source ~/.zshrc
````

- Check the version of python available to install:

``` bash
pyenv install --list
````

- Install version 3.12.0 to use as global python

``` bash
pyenv install 3.12.0
````

- Set Up a Virtual Environment with the Installed Version

``` bash
pyenv virtualenv 3.12.0 global
````

List installed python versions

``` bash
pyenv versions
````

- Use 'global' if you want to set the python version globally

``` bash
pyenv global global
````

- Use ‘local’ if you want a permanent python version in a directory

``` bash
pyenv local global
````

- Uninstall a virtual environment or a phyton version

``` bash
pyenv uninstall global
````

- Activate or Deactivate the Virtual Environment

``` bash
pyenv activate global
pyenv deactivate gloval_python
````

- Some packages to install in the virtual environment

``` bash
pip install setuptools
````

# Python for FATES

## The script to define pfts in fates requires the following python installation

- Check the version of python to install:

``` bash
pyenv install --list
````

- Install version 3.11.8

``` bash
pyenv install 3.11.8
````

- Set Up a Virtual Environment with the Installed Version

``` bash
pyenv virtualenv 3.11.8 fates_swapper
````

- Activate the Virtual Environment

``` bash
pyenv activate fates_swapper
pyenv deactivate fates_swapper
````

- Use ‘local’ if you want a permanent python version in a directory

``` bash
pyenv local fates_swapper
````

- Install numpy and scipy in the virtual environment

``` bash
pip install numpy==1.26.4 scipy==1.11
````
