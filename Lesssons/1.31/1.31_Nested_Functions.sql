-- Array Intro.
SELECT [1,2,3];

WITH skills AS (
    SELECT 'Python' AS skill
    UNION ALL
    SELECT 'sql'
    UNION ALL
    SELECT 'r' 
),skills_array AS (
    SELECT ARRAY_AGG(skill ORDER BY skill) AS skills
    FROM skills
)
SELECT 
    skills[1] AS first_skill,
    skills[2] AS second_skill,
    skills[3] AS third_skill
FROM skills_array
;
--- STRUCT
SELECT {skil: 'python', type: 'programing'} AS skill_struct;

WITH skill_struct AS (
SELECT
    STRUCT_PACK(
        skil:= 'python',
        type:= 'programing'
    ) AS s
)
SELECT
    s.skil,
    s.type
FROM skill_struct;

-- cinvert table into a struct
-- table
WITH skill_table AS (
SELECT 'Python' AS skills, 'programing' AS types
UNION ALL
SELECT 'sql', 'query language'
UNION ALL
SELECT 'r', 'programing'
)
SELECT 
    STRUCT_PACK (
        skill:= skills,
        type:= types
    )
FROM skill_table;

-- Array of Structs
SELECT [
    {skill: 'python', type: 'programming'},
    {skill: 'sql', type: 'query_language'}
] AS skills_array_of_structs;


--- convert array to array of structs

WITH skill_table AS (
    SELECT 'Python' AS skills, 'programing' AS types
    UNION ALL
    SELECT 'sql', 'query language'
    UNION ALL
    SELECT 'r', 'programing'
),skills_array_struct AS (
    SELECT 
        ARRAY_AGG(
            STRUCT_PACK (
                skill:= skills,
                type:= types
            )
        ) array_struct
    FROM skill_table
)
SELECT
    array_struct[1].skill,
    array_struct[2].type,
    array_struct[3]
FROM skills_array_struct;

---MAP
WITH skill_map AS (
SELECT MAP {'skill' : 'python', 'type': 'programming'} AS skill_type
)
SELECT
    skill_type['type']
FROM skill_map;

--json
--- mostly when will receive data in json form and will convert it array list to be used in sql.
WITH raw_skill_json AS (
SELECT 
    '{"skill":"python", "type":"programming"}':: JSON skill_json
)   
SELECT
    STRUCT_PACK(
        skill := json_extract_string(skill_json,'$.skill'),
        type := json_extract_string(skill_json,'$.type')
    )
FROM raw_skill_json;

--Arrays FINAL_EXAMPLE
--build flat skill table for a co-workes to access job titles, salary info, and skill in one table.
CREATE OR REPLACE TEMP TABLE job_skills_array AS
SELECT
   jpf.job_id,
   jpf.job_title_short,
   jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills_array
FROM
    job_postings_fact AS jpf    
LEFT JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd 
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;

--- From a prepective of data analyst, analyze the median salary per skill, by unnest.

WITH flat_skills AS (
SELECT
   job_id,
   job_title_short,
   salary_year_avg,
   UNNEST(skills_array) AS skill
FROM job_skills_array
)
SELECT
    skill,
    MEDIAN(salary_year_avg) as median_salary
FROM flat_skills
--WHERE salary_year_avg IS NOT NULL
GROUP BY skill
ORDER BY median_salary DESC;

--Arrays of Structs - FINAL_EXAMPLE
--build flat skill & type table for a co-workes to access job titles, salary info, and skill in one table.
CREATE OR REPLACE TEMP TABLE job_skills_array_struct AS
SELECT
   jpf.job_id,
   jpf.job_title_short,
   jpf.salary_year_avg,
    ARRAY_AGG(
        STRUCT_PACK(
            skill_type := sd.type,
            skill_name := sd.skills

        )
    ) AS skills_type
FROM
    job_postings_fact AS jpf    
LEFT JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd 
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;
-- From a prepective of data analyst, analyze the median salary per skill, by unnest.
WITH flat_skills AS (
SELECT
   job_id,
   job_title_short,
   salary_year_avg,
   UNNEST(skills_type).skill_type AS skill_type,
    UNNEST(skills_type).skill_name AS skill_name
FROM job_skills_array_struct
)
SELECT
    skill_type,
    MEDIAN(salary_year_avg) as median_salary
FROM flat_skills
--WHERE salary_year_avg IS NOT NULL
GROUP BY skill_type
ORDER BY median_salary DESC;
