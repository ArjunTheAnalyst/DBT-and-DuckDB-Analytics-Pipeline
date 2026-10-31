-- Remove Scraper Errors and Select Core Columns

-- Override project default in order to keep 'job_postings' as a view to avoid storage costs
{{ config(materialized = 'view') }}

SELECT
	job_id,
	job_title,
	company_name,
	job_location,
	job_via,
	job_schedule_type,
	job_work_from_home,
	search_date,
	search_term
FROM
    {{ source('raw', 'job_postings') }}
WHERE
    error IS NULL;

-- Downstream Flow: `dbt run --select job_postings+` builds this table and all its downstream dependencies.
-- 
-- Verify with:
-- duckdb ../data/dev.duckdb
-- SHOW TABLES;