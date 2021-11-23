\set mimic_data_dir /datasets/mimiciv_ed_1_0/ed
\set mimic_script_dir /mimic_code/mimic-iv-ed/buildmimic/postgres

begin;
\i :mimic_script_dir/create.sql
\i :mimic_script_dir/load_gz.sql
\i :mimic_script_dir/constraint.sql
-- \i :mimic_script_dir/index.sql -- Invalid indexes
end;