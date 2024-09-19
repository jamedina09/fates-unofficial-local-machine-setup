## Install E3SM

Define which version of E3SM and FATES you need. Check it here:

<https://fates-users-guide.readthedocs.io/en/latest/user/Table-of-FATES-API-and-HLM-STATUS.html>

- Clone the E3SM repository to your home directory from the specified GitHub URL:

```bash
cd ~ 
git clone git@github.com:E3SM-Project/E3SM.git temp-folder && mv temp-folder E3SM_069c226
cd E3SM_069c226
````

Explore the metadata of the commit hash

```bash
git show 069c226
````

Go to the desired commit hash

```bash
git checkout 069c226
````

- Run the script to manage external dependencies and check out required code

```bash
git submodule update --init --recursive
````

- Check FATES version

```bash
cd components/elm/src/external_models/fates
````

## cmake-macro for E3SM

E3SM transitioned from config_compilers.xml to cmake-macros

I provide my own gnu_SI.cmake file here as example. however, if you have a different config_compilers.xml file, you can use the prodived script to convert it to cmake-macros.

How do you do this?

There is a tool names converter in the directory:

```bash
/Users/XXX/E3SM/cime_config/machines/scripts
````

You need to provide the path where you have located your config_compilers.xml; this is in your .cime directory.

```bash
./converter /Users/XXX/.cime/config_compilers.xml
````

The converted cmake will be store in the directory where the script 'converter' is located.

Copy that 'converted', or new .cmake file to your .cime directory.
