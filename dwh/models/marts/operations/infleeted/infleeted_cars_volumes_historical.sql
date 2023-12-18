{{
    config(
      materialized = 'incremental'
    )
}}

SELECT
  COUNT(id) AS cnt,
  DATE(registration_date) AS day
FROM
  {{ ref ('satelite_cars_last_updates') }}
{% if is_incremental() %}
  WHERE DATE(registration_date) = DATE('now','-1 day') AND (DATE(registration_date) > (SELECT MAX(day) FROM {{ this }} ))
{% else %}
  WHERE
    DATE(registration_date) <= DATE('now','-1 day')
  GROUP BY
    DATE(registration_date)
{% endif %}
