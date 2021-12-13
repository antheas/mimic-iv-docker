# MIMIC IV PostgreSQL scripts for Docker
This repository contains scripts that can be used to load MIMIC-IV in a PostgreSQL container,
PG-ADMIN will also be launched.
It uses the scripts provided from the (MIT MIMIC code)[https://github.com/MIT-LCP/mimic-code] repository.

## How to use
Start by cloning this repository:
``` bash
git clone https://github.com/antheas/mimic-iv-docker
```
Then, initialize the submodules (MIT code) with the following:
``` bash
git init submodules
```
Copy the file `.env.example` to `.env` and edit it as required:
``` bash
cp .env.example .env
nano .env
```
Then, after installing `docker` and `docker-compose` run:
``` bash
docker-compose up
```
Monitor the output for errors.
The dataset will load in 1-10 hours, depending on your setup.
Using a 16 core EPYC and loading into a RAM disc, with the optimizations provided
the process takes 1 and a half hours.

### Using dumps
The PostgreSQL docker container runs the scripts in `/docker-entrypoint-initdb.d`
when initializing.
In the default `.env`, this is the `init.d` directory.
Comment `MIMIC_DIR_INIT` in `.env` or make it blank to make docker run
`init.d.dump.sh` first, which is a wrapper script.

This script will first load MIMIC-IV normally and then dump it
to `data/dump` (by default) in PostgreSQL format that takes around
10GB.
Loading that dump takes 10-20 minutes as opposed to 1-10 hours for
loading the `.csv.gz` files.

By default, that script will also attempt to load the dump instead on startup.
As such, instead of copying the original mimic data to a server and re-loading
the dataset, you can just transfer the dump.