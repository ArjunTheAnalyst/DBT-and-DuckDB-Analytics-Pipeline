
WITH totals AS
(SELECT
    month,
    SUM(postings) AS total_postings
FROM
    {{ ref('jobs_per_month') }}
GROUP BY
    month),

remote AS
(SELECT
    DATE_TRUNC('month', search_date) AS month,
    COUNT(*) AS remote_postings
FROM
    {{ ref('job_postings') }}
WHERE
    job_work_from_home = true
GROUP BY
    DATE_TRUNC('month', search_date))

SELECT
    totals.month,
    total_postings,
    remote_postings,
    ROUND(
    (100 * remote_postings) / total_postings, 1) AS remote_percentage
FROM
    totals
INNER JOIN
    remote
ON
    totals.month = remote.month
ORDER BY
    totals.month;

-- Preview the model's output without building it: dbt show --select monthly_summary --limit -1

-- dbt Jinja: ref() ensures this entire model runs only after both 'jobs_per_month' and 'job_postings' are built.

-- TO TEST THIS:
-- 1. Delete dev.duckdb
-- 2. Run: dbt run --select monthly_summary
-- (It will throw a "Table does not exist" error)

-- Upstream Flow: `dbt run --select +monthly_summary` builds this table and all its upstream dependencies (like jobs_per_month and job_postings).

-- Verify with:
-- duckdb ../data/dev.duckdb
-- SHOW TABLES;
