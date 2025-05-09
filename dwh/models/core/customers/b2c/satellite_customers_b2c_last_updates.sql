{{
    config(
      materialized = 'table'
    )
}}

WITH ranked AS (
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY id
      ORDER BY updated_at DESC
    ) AS rw_number
  FROM
    {{ ref('satellite_customers_b2c')}}
)
SELECT
  id,
  first_name,
  second_name,
  city AS city,
  zip AS zip,
  street AS street,
  street_house AS street_house
FROM
  ranked
WHERE
  rw_number = 1
