{{
    config(
      materialized = 'view'
    )
}}

WITH data AS (
  SELECT
    *
  FROM
    {{ ref ('cars_deliveries_future') }}

  UNION ALL

  SELECT
    *
  FROM
    {{ ref ('cars_deliveries_historical') }}
)
SELECT *
FROM data
