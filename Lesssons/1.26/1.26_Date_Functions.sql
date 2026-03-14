SELECT 
    job_posted_date,
    job_posted_date::DATE AS date,
    job_posted_date::TIME AS time,
    job_posted_date::TIMESTAMP AS timestamp,
    job_posted_date::TIMESTAMPTZ AS timestampz,
FROM job_postings_fact 
LIMIT 10;

---EXTRACT
SELECT 
    DATE_TRUNC('month',job_posted_date) AS job_posted_month,
    COUNT(job_id) AS job_count
FROM job_postings_fact 
WHERE 
    job_title_short = 'Data Engineer' AND
    EXTRACT(YEAR FROM job_posted_date) = 2024
GROUP BY
    DATE_TRUNC('month',job_posted_date)
ORDER BY job_posted_month;

-- DATE_TRUNC

SELECT 
    job_posted_date,
        DATE_TRUNC('year',job_posted_date) AS truncated_year,
        DATE_TRUNC('quarter',job_posted_date) AS truncated_quarter,
        DATE_TRUNC('month',job_posted_date) AS truncated_month,
        DATE_TRUNC('week',job_posted_date) AS truncated_week,
        DATE_TRUNC('day',job_posted_date) AS truncated_day,
        DATE_TRUNC('hour',job_posted_date) AS truncated_hour
FROM job_postings_fact 
ORDER BY RANDOM()
LIMIT 10;

-- AT TIME ZONE
SELECT 
    job_posted_date,
    job_posted_date AT TIME ZONE 'UTC'
FROM job_postings_fact
LIMIT 10;