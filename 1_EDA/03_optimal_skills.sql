/*
Question: What are the most optimal skills for data engineers—balancing both demand and salary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on remote Data Engineer positions with specified annual salaries.
- Why?
    - This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately instead of letting rare, outlier skills distort the results.
    - The natural log transformation ensures that both high-salary and widely in-demand skills surface as the most practical and valuable to learn for data engineering careers.
*/

SELECT
    sd.skills,
    ROUND(MEDIAN(salary_year_avg),0) AS median_salary,
    --COUNT(jpf.*) AS demand_count,
    ROUND(LN(COUNT(jpf.*)),1) AS ln_demand_count,
    COUNT(jpf.*) AS demand_count,
    ROUND((MEDIAN(salary_year_avg) * LN(COUNT(jpf.*)))/1_000_000,2) AS optimal_score
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd
    ON sjd.skill_id = sd.skill_id
WHERE 
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = TRUE
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING COUNT(jpf.*) > 100
ORDER BY optimal_score DESC
LIMIT 25;

/*
Here's a breakdown of the most optimal skills for Data Engineers, based on both high demand and high salaries:

Top Skills by Optimal Score:
- Terraform leads the list with a $184K median salary and 193 postings, resulting in the highest overall "optimal score".
- Python and SQL dominate demand (over 1100 postings each), with strong median salaries of $135K and $130K, respectively.
- AWS (783 postings, $137K median), Spark (503 postings, $140K median), and Airflow (386 postings, $150K median) are all highly sought-after cloud and big data technologies.
- Kafka offers high compensation ($145K median) and solid demand (292 postings).
- Tools like Snowflake, Azure, and Databricks each have 250–475 postings and median salaries between $128–$137K.

DevOps & Engineering Tools:
- Airflow ($150K), Kubernetes ($150.5K), and Docker ($135K) stand out for their mix of demand and top median salaries.
- Git ($140K/208 postings) and Github ($135K/127 postings) have broad utility and competitive compensation.

Noteworthy Languages:
- Java (303 postings, $135K median) and Scala (247 postings, $137K median) remain strong choices for well-paid data engineering roles.
- Go ($140K/113 postings) is another programming language with excellent compensation.

Databases & Cloud:
- Redshift ($130K/274 postings), GCP ($136K/196 postings), Hadoop ($135K/198 postings), NoSQL ($134.4K/193 postings), and MongoDB ($135.8K/136 postings) add to a well-rounded data engineering skill set.
- R, Pyspark, and BigQuery each deliver competitive salaries and meet the threshold for demand.

Summary:
Skills that consistently appear near the top balance a strong combination of market demand (job security) and financial benefit. Python, SQL, AWS, Spark, Airflow, and Terraform are particularly strategic for both immediate opportunities and longer-term career growth in data engineering.

┌────────────┬───────────────┬─────────────────┬──────────────┬───────────────┐
│   skills   │ median_salary │ ln_demand_count │ demand_count │ optimal_score │
│  varchar   │    double     │     double      │    int64     │    double     │
├────────────┼───────────────┼─────────────────┼──────────────┼───────────────┤
│ terraform  │      184000.0 │             5.3 │          193 │          0.97 │
│ python     │      135000.0 │             7.0 │         1133 │          0.95 │
│ sql        │      130000.0 │             7.0 │         1128 │          0.91 │
│ aws        │      137320.0 │             6.7 │          783 │          0.91 │
│ airflow    │      150000.0 │             6.0 │          386 │          0.89 │
│ spark      │      140000.0 │             6.2 │          503 │          0.87 │
│ snowflake  │      135500.0 │             6.1 │          438 │          0.82 │
│ kafka      │      145000.0 │             5.7 │          292 │          0.82 │
│ azure      │      128000.0 │             6.2 │          475 │          0.79 │
│ java       │      135000.0 │             5.7 │          303 │          0.77 │
│ scala      │      137290.0 │             5.5 │          247 │          0.76 │
│ kubernetes │      150500.0 │             5.0 │          147 │          0.75 │
│ git        │      140000.0 │             5.3 │          208 │          0.75 │
│ databricks │      132750.0 │             5.6 │          266 │          0.74 │
│ redshift   │      130000.0 │             5.6 │          274 │          0.73 │
│ gcp        │      136000.0 │             5.3 │          196 │          0.72 │
│ hadoop     │      135000.0 │             5.3 │          198 │          0.71 │
│ nosql      │      134415.0 │             5.3 │          193 │          0.71 │
│ pyspark    │      140000.0 │             5.0 │          152 │           0.7 │
│ docker     │      135000.0 │             5.0 │          144 │          0.67 │
│ mongodb    │      135750.0 │             4.9 │          136 │          0.67 │
│ go         │      140000.0 │             4.7 │          113 │          0.66 │
│ r          │      134775.0 │             4.9 │          133 │          0.66 │
│ github     │      135000.0 │             4.8 │          127 │          0.65 │
│ bigquery   │      135000.0 │             4.8 │          123 │          0.65 │
├────────────┴───────────────┴─────────────────┴──────────────┴───────────────┤
│ 25 rows                                                           5 columns │
└─────────────────────────────────────────────────────────────────────────────┘
*/