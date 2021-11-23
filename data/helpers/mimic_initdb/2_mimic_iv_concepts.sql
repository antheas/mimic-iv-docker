\set mimic_script_dir /mimic_code/mimic-iv/concepts/postgres

begin;
set search_path to mimic_derived, mimic_core, mimic_hosp, mimic_icu, mimic_ed;
\i :mimic_script_dir/postgres-functions.sql
\cd :mimic_script_dir
\i :mimic_script_dir/postgres-make-concepts.sql
end;