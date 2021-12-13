if [ -d '/dump/complete-mimic' ]; then
  echo "Restoring from database dump..."
  pg_restore -U ${POSTGRES_USER} -d ${POSTGRES_DB} -j ${POSTGRES_PARALLEL} /dump/complete-mimic
else
  echo "Creating database from compressed source..."
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    \i /docker-entrypoint-initdb.d/init.d/0_mimic_iv.sql
    \i /docker-entrypoint-initdb.d/init.d/1_mimic_iv_concepts.sql
    \i /docker-entrypoint-initdb.d/init.d/2_mimic_iv_ed.sql
    \i /docker-entrypoint-initdb.d/init.d/3_mimic_search_path.sql
EOSQL
  echo "Creating database dump..."
  pg_dump -F d -U ${POSTGRES_USER} -d ${POSTGRES_DB} -j ${POSTGRES_PARALLEL} -f /dump/complete-mimic
fi  