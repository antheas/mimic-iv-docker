alter database mimic set search_path to mimic_core, mimic_hosp, mimic_icu, mimic_ed;

select *
from mimic_core.admissions
natural join mimic_core.patients
natural join mimic_core.transfers
limit 1000
;

select *
from mimic_hosp.d_hcpcs
limit 100;

select *
from mimic_hosp.d_icd_diagnoses
limit 100;

select *
from mimic_hosp.d_icd_procedures
limit 100;

select count(*) from mimic_hosp.d_hcpcs;
select count(*) from mimic_hosp.d_icd_diagnoses;
select count(*) from mimic_hosp.d_icd_procedures;
select count(*) from mimic_hosp.d_labitems;

select count(*) as patient_n from mimic_core.patients;

with icd_num as (
    select icd_code, count(*)
    from mimic_hosp.diagnoses_icd
    group by icd_code
    having count(*) > 100
  )
select count(*) as significant_disease_n from icd_num;

select * from drgcodes where drg_severity is not null limit 50;

with drg_severe_n as (
  select count(*) from drgcodes where drg_severity is not null
), drg_n as (
  select count(*) from drgcodes
)
select drg_severe_n, drg_n from drg_severe_n, drg_n;

select subject_id, label, value, valueuom
from datetimeevents natural join d_items
limit 50;

select subject_id, charttime, label, value, valueuom 
from chartevents natural join d_items
where valueuom is not null and subject_id = 10004235
order by charttime
;-- limit 2000;

select count(*) from chartevents
group by (subject_id, itemid) limit 100;

select count(*)
from
(select stay_id
from chartevents
group by (stay_id, subject_id, hadm_id)) as a;

with a as (select subject_id
from chartevents
group by subject_id)
select count(*) from a;


with 
  dead as (select count(*) as dead from admissions where deathtime is not NULL),
  num as (select count(*) as num from admissions)
select dead, (num - dead) as alive, num, (100 * dead/cast(num as float)) as death_rate from dead, num;

with 
  dead as (select count(*) as dead from admissions where deathtime is not NULL),
  num as (select count(*) as num from (select subject_id from admissions group by subject_id) as a)
select dead, (num - dead) as alive, num, (100 * dead/cast(num as float)) as death_rate from dead, num;

with
  stays as (
    select bool_or(deathtime is not null) as died from admissions as a natural join icustays as i 
    group by subject_id),
  stats as (
    select count(*) as total_icu, sum(case when died then 1 else 0 end) as total_died
    from stays
  )
select total_icu, total_died, 100 * total_died / cast(total_icu as float) as death_rate
from stats;

with
  stays as (
    select bool_or(deathtime is not null) as died from admissions as a natural join icustays as i 
    group by (subject_id, stay_id)),
  stats as (
    select count(*) as total_icu, sum(case when died then 1 else 0 end) as total_died
    from stays
  )
select total_icu, total_died, 100 * total_died / cast(total_icu as float) as death_rate
from stats