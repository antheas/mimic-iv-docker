set search_path to mimic_derived, mimic_core, mimic_hosp, mimic_icu, mimic_ed;
\i mimic_iv_concepts/postgres-functions.sql -- only needs to be run once
\i mimic_iv_concepts/postgres-make-concepts.sql