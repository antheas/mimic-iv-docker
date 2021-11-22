\set mimic_script_dir /mimic_code/mimic-iv/concepts/postgres

-- set search_path to mimic_derived, mimic_core, mimic_hosp, mimic_icu, mimic_ed;
begin;
\i :mimic_script_dir/postgres-functions.sql -- only needs to be run once
-- \i :mimic_script_dir/postgres-make-concepts.sql
end;