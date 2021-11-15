This folder contains scripts that link to `mimic-code` postgres scripts for creating
the database.
It is meant to be mounted at `/docker-entrypoint-initdb.d` in the postgres container
and for the `mimic-code` repository to be mounted at `/mimic_code`.