if [ -z "$(ls /dump)" ];
  echo "Rebuilding database from dump"
  pg_restore -U postgres -j ${POSTGRES_PARALLEL} /dump
  echo "Crashing container to avoid running other scripts"
  exit 1
else
  echo "No dump available, proceeding with manual rebuild"
fi

