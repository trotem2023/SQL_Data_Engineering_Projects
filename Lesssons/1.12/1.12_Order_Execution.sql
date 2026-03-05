/* find the top 10 companies
for posting jobs
they must have >3000 postings
and only in USA
*/

select * from company_dim
limit 10;
EXPLAIN ANALYZE
SELECT 
       cd.name AS company_name,
       jpf.job_country as country,
      --sum(job_id) as no_of_postings
      COUNT(jpf.*) AS posting_count   
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name,jpf.job_country
HAVING posting_count > 3000
ORDER BY  COUNT(jpf.*) DESC
LIMIT 10;