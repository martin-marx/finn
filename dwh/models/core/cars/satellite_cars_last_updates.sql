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
    {{ ref('satellite_cars') }}
)
SELECT
  id,
  license_plate,
  registration_date,
  deregistration_date
FROM
  ranked
WHERE
  rw_number = 1
