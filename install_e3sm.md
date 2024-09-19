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

## Cmake file

E3SM doesnt use config_mahines. Instead, it uses a cmake file.
