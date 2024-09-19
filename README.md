# FATES (and CTSM) Unofficial Installation Guide on Local Machines - Work-In-Progress

***This guide is a work-in-progress and is not yet complete.***

This repository provides an **unofficial guide** for installing the FATES program on MacOS. There are a couple fo ways to install the required packages to run the model. The first way uses Homebrew to install some of the dependencies and then continues installing packages from source, and the second way requires installing everything from source. If you have, for example, MacOS Big Sur, you can install everything from source. If you have MacOS Sonoma, you can also install everything from source, but need to use an old and beta version of command lines tools. Therefore, If you have Sonoma, I recommend the combiantion between Homebrew and source installation. If you have MacOS Big Sur, you can install everything from source. 

I also provide a guide to installing Python using [Homebrew](./python_homebrew_setup.md) and [Miniconda](./python_config_macos_sonoma.md) on macOS Sonoma. I use Homebrew to install python, but you can use Miniconda if you prefer. I prefer brew because I can also install pyenv and pyenv-virtualenv, which I use to manage my python versions and environments.

## Disclaimer
- This guide is **not officially endorsed** by any development team.
- **I do not offer support** for this guide or the installation process.
- The guide is (currently) maintained **solely by me**, and updates are made based on my availability.

Use at your own discretion.

## Table of Contents
- [Supported Operating Systems](#supported-operating-systems)
- [Shell scripts to run FATES](#shellscripts)
- [Troubleshooting](#troubleshooting)

## Supported Operating Systems


Choose the guide for your operating system:
- [macOS Sonoma Homebrew & Source Installation - Intel](./os-macos-sonoma-intel-homebrew.md) - **My preferred method**
- [macOS Sonoma Source Installation - Intel](./os-macos-sonoma-intel.md)
- [macOS Big Sur Source Installation - Intel](./os-macos-bigsur-intel.md)

## Shell scripts to run FATES
I included a few basic shell scripts to test the the installation of the models. These scripts are located in the  [shell_scripts](./shell_scripts) directory.

## Troubleshooting
**No personal support is provided**.
