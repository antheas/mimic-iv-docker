pg_dump -F d -j $(grep -c ^processor /proc/cpuinfo) -f /dump/initdata -U mimic
pg_restore -U mimic -d mimic -j 32 /dump/initdata