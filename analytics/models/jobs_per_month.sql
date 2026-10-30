-- Monthly Postings by Role

SELECT
    DATE_TRUNC('month', search_date) AS month,
    search_term AS role,
    COUNT(*) AS postings
FROM
    {{ ref('job_postings') }}
GROUP BY
    DATE_TRUNC('month', search_date),
    search_term
ORDER BY
    month,
    role;

-- Preview the model's output without building it: dbt show --select jobs_per_month --limit -1

-- dbt Jinja: ref() ensures this model only runs after 'job_postings' is built. 
-- If the table doesn't exist, the query will fail.
--
-- TO TEST THIS:
-- 1. Delete dev.duckdb
-- 2. Run: dbt run --select jobs_per_month
-- (It will throw a "Table does not exist" error)

-- Upstream Flow: `dbt run --select +jobs_per_month` builds this table and all its upstream dependencies (like job_postings).
-- 
-- Verify with:
-- duckdb ../data/dev.duckdb
-- SHOW TABLES;