-- UNION,INTERSECT,EXCEPT
SELECT UNNEST([1,1,1,2]) -- table A
EXCEPT
SELECT UNNEST([1,1,3]); -- table B

-- FINAL EXAMPLE
CREATE TEMP TABLE jobs_2023_only AS
SELECT * EXCLUDE (job_id,job_posted_date)
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2023;

SELECT * FROM jobs_2023_only;

CREATE TEMP TABLE jobs_2024_only AS
SELECT * EXCLUDE (job_id,job_posted_date)
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2024;

SELECT * FROM jobs_2024_only;

-- 1. which unique job postings appeared in either 2023 or 2024 ?
SELECT
    'jobs_2023' AS table_name,
    COUNT(*) AS record_count
FROM jobs_2023_only
UNION
SELECT
    'jobs_2024' AS table_name,
    COUNT(*) 
FROM jobs_2024_only;
---
SELECT * FROM jobs_2023_only
UNION
SELECT * FROM jobs_2024_only;

-- 2. which  job postings appeared across both years, counting duplicates ?
SELECT * FROM jobs_2023_only
UNION ALL
SELECT * FROM jobs_2024_only;

-- 3. which  job postings appeared in 2023 but not in 2024 ?
SELECT * FROM jobs_2023_only
EXCEPT
SELECT * FROM jobs_2024_only;

-- 4. which  job postings from 2023 remian after subtracting 2024 postings, on for one?
SELECT * FROM jobs_2023_only
EXCEPT ALL
SELECT * FROM jobs_2024_only;

-- 5. which  job postings appeared in both years?
SELECT * FROM jobs_2023_only
INTERSECT
SELECT * FROM jobs_2024_only;

-- 6. which  job postings appeared in both years,preserve duplicate counts?
SELECT * FROM jobs_2023_only
INTERSECT ALL
SELECT * FROM jobs_2024_only;