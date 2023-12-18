{{
    config(
      materialized = 'view'
    )
}}

WITH data AS (
  SELECT
    *
  FROM
    {{ ref ('infleeted_cars_volumes_future') }}

  UNION ALL

  SELECT
    *
  FROM
    {{ ref ('infleeted_cars_volumes_historical') }}
)
SELECT *
FROM data
WHERE day IS NOT NULL
