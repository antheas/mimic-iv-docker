\set mimic_data_dir /datasets/mimiciv_1_0
\set mimic_script_dir /mimic_code/mimic-iv/buildmimic/postgres

begin;
\i :mimic_script_dir/create.sql
-- \i :mimic_script_dir/constraint.sql -- some data doesn't fit constraints
\i :mimic_script_dir/load_gz.sql
\i :mimic_script_dir/index.sql
end;