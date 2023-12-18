{{
    config(
      materialized = 'table'
    )
}}

SELECT
  COUNT(id) AS cnt,
  DATE(registration_date) AS day
FROM
  {{ ref ('satelite_cars_last_updates') }}
WHERE
  DATE(registration_date) >= DATE('now')
GROUP BY
  DATE(registration_date)
