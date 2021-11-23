pg_dump -F d -j $(grep -c ^processor /proc/cpuinfo) -f /var/lib/postgresql/data/dump -U mimic
pg_restore -U mimic -d mimic -j 32 /var/lib/postgresql/data/dump