/*

How to create table containing columns :
  year, ECT cases, ECT patients
from the omop CDM server of your own hospital

*/

with t1 as ( 
    select extract(year from procedure_datetime)
        , person_id, count(*) 
        from procedure_occurrence 
    where procedure_concept_id = 4030840 
    group by extract(year from procedure_datetime)
        , person_id ),
    t2 as ( select 
        extract(year from procedure_datetime)
        , count(*)
        from procedure_occurrence 
        where procedure_concept_id = 4030840
        group by 
            extract(year from procedure_datetime) ),
    t3 as ( select date_part
        , count(*)
        from t1
        group by date_part order by date_part)
select t2.date_part as year, t2.count no_of_ECT
    , t3.count no_of_ECT_patients
from t2 join t3 on t2.date_part = t3.date_part
order by t2.date_part;

