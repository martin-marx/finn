{{
    config(
      materialized = 'table'
    )
}}

SELECT
  COUNT(id) AS cnt,
  DATE(deregistration_date) AS day
FROM
  {{ ref ('satelite_cars_last_updates') }}
WHERE
  DATE(deregistration_date) >= DATE('now')
GROUP BY
  DATE(deregistration_date)
