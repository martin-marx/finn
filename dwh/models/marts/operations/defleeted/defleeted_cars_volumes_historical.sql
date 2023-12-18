{{
    config(
      materialized = 'incremental'
    )
}}

SELECT
  COUNT(id) AS cnt,
  DATE(deregistration_date) AS day
FROM
  {{ ref ('satelite_cars_last_updates') }}
{% if is_incremental() %}
  WHERE DATE(deregistration_date) = DATE('now','-1 day') AND (DATE(registration_date) > (SELECT MAX(day) FROM {{ this }} ))
{% else %}
  WHERE
    DATE(deregistration_date) <= DATE('now','-1 day')
  GROUP BY
    DATE(deregistration_date)
{% endif %}
