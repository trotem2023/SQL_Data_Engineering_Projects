SELECT count(*) from company_dim;

SELECT 
    jpf.job_id,
    cd.name,
    jpf.job_title_short
FROM
    job_postings_fact AS jpf
LEFT JOIN company_dim as cd
    on jpf.company_id = cd.company_id;
---
select * from skills_job_dim
limit 15;

SELECT jpf.job_id,
       jpf.job_title_short, 
       sjd.skill_id,
       sd.skills 
FROM  job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
LEFT join skills_dim AS sd
        ON sjd.skill_id = sd.skill_id;
--LIMIT 10;
