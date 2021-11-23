pg_dump -F d -j ${POSTGRES_PARALLEL} -f /dump/complete-mimic -U ${POSTGRES_USER}
pg_restore -U mimic -d mimic -j 32 /var/lib/postgresql/data/dump