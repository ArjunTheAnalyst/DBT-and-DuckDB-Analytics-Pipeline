-- Top Hiring Locations

SELECT
    job_location,
    COUNT(*) AS postings
FROM
    {{ ref('job_postings') }}
GROUP BY
    job_location
ORDER BY
    postings DESC
LIMIT 10;

-- Preview the model's output without building it: dbt show --select top_locations --limit -1

-- dbt Jinja: ref() ensures this model only runs after 'job_postings' is built. 
-- If the table doesn't exist, the query will fail.
--
-- TO TEST THIS:
-- 1. Delete dev.duckdb
-- 2. Run: dbt run --select top_locations
-- (It will throw a "Table does not exist" error)

-- Upstream Flow: `dbt run --select +top_locations` builds this table and all its upstream dependencies (like job_postings).
-- 
-- Verify with:
-- duckdb ../data/dev.duckdb
-- SHOW TABLES;