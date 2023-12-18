{{
    config(
      materialized = 'view'
    )
}}

WITH data AS (
  SELECT
    *
  FROM
    {{ ref ('type_share_future') }}

  UNION ALL

  SELECT
    *
  FROM
    {{ ref ('type_share_historical') }}
)
SELECT *
FROM data
