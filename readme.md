# MIMIC IV PostgreSQL scripts for Docker
This repository contains scripts that can be used to load MIMIC-IV in a PostgreSQL container,
pgAdmin will also be launched.
It uses the scripts provided from the [MIT MIMIC code](https://github.com/MIT-LCP/mimic-code) repository.

[MIMIC-IV 1.0](https://physionet.org/content/mimiciv/1.0/) and 
[MIMIC-IV-ED 1.0](https://physionet.org/content/mimic-iv-ed/1.0/) will be loaded
into a shared PostgreSQL database and the 
[MIMIC-IV concepts](https://github.com/MIT-LCP/mimic-code/tree/main/mimic-iv/concepts)
will be computed.


## How to use
Start by downloading MIMIC into your preferred system directory.
``` bash
mkdir -p mydir && cd mydir
wget -r -N -c -np --user <user> --ask-password https://physionet.org/files/mimiciv/1.0/
wget -r -N -c -np --user <user> --ask-password https://physionet.org/files/mimic-iv-ed/1.0/
```
Then, clone this repository:
``` bash
git clone https://github.com/antheas/mimic-iv-docker
cd mimic-iv-docker
```
And initialize the submodules (MIT code) with the following:
``` bash
git submodule init
git submodule update
```
Copy the file `.env.example` to `.env` and edit it as required:
``` bash
cp .env.example .env
nano .env
```
In the `.env` file, the paths of the datasets in your system are specified.

Then, after installing `docker` and `docker-compose` run:
``` bash
docker-compose up
# Skip pg-admin
docker-compose up mimic-db
```
Monitor the output for errors.
The dataset will load in 1-10 hours, depending on your setup.
Using a 16 core EPYC and loading into a RAM disc, with the optimizations provided,
the process takes 1 and a half hours.

You can `ctrl-C` to cancel.
Follow up with:
``` bash
# Start in the background
docker-compose up -d
# Stop momuntarily
docker-compose stop
# Stop and remove containers, volumes (system is clean after this)
docker-compose down -v
```

Now, you can visit <http://localhost:8080> (pgAdmin) and run some queries.
Tip: you an forward a port using ssh to your local computer by running
`ssh <host> -L 8080:localhost:8080`.

### Search Path
The search path has been altered for you by running the following command from
`init.d/3_mimic_search_path.sql`:
``` sql
alter database :DBNAME set search_path to mimic_core, mimic_hosp, mimic_icu, mimic_ed;
```
As such, you can construct sql queries by ommiting `mimic_*`, so
`select * from mimic_core.admissions` becomes `select * from admissions`.

### In case of errors
If an error occurs during loading, `PostgreSQL` will notice a non-empty db directory
on next startup and will skip initialization.
As such, the mimic-db directory needs to be deleted.
If you didn't change the docker UID and GID you will have to use root to do this:
``` bash
sudo bash -c "rm -rf data/mimic-db/*"  
```
The command is set up in that way such that if `mimic-db` is a mount it won't be
deleted.
The whole command needs to run in bash because the star needs to be expanded using
root rights. 

If you set the UID/GID, then you can just:
``` bash
rm -rf data/mimic-db/*
```

### Using dumps
The PostgreSQL docker container runs the scripts in `/docker-entrypoint-initdb.d`
when initializing.
In the default `.env`, this is the `init.d` directory.
Comment out `MIMIC_DIR_INIT` in `.env` or make it blank to make docker run
`init.d.dump.sh` first, which is a wrapper script.

This script will first load MIMIC-IV normally and then dump it
to `data/dump` (by default) in PostgreSQL format that takes around
10GB.
Loading that dump takes 10-20 minutes as opposed to 1-10 hours for
loading the `.csv.gz` files.

By default, that script will also attempt to load the dump instead on startup.
As such, instead of copying the original mimic data to a server and re-loading
the dataset, you can just transfer the dump.

## Use with your own project
You can use the code with your project by adding a submodule to your git repository
``` bash
git submodule add git@github.com:antheas/mimic-iv-docker <your-dir>
git submodule update --init --recursive
cat <your-dir>/.env >> .env
nano .env
```
Then, by combining the `docker-compose` files:
```
docker-compose -f docker-compose.yml -f <your-dir>/docker-compose.yml up
```
The first `docker-compose` file's directory is used as a base and the other one
is loaded as is.
Use directories relative to the first `docker-compose` file in the `.env`.

If you don't require `docker` for your project, just launch this project and
connect to it by using `localhost:5432`.
The port is already forwarded to the host.