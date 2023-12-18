{{
    config(
      materialized = 'incremental'
    )
}}

SELECT
  COUNT(s.id) AS deliveries_number,
  scbc.city AS city,
  DATE(s.start_date) AS delivery_date
FROM 
  {{ ref ('link_subscriptions') }} s INNER JOIN {{ ref ('satellite_customers_b2c_last_updates') }} scbc
  ON s.customer_id = scbc.id
{% if is_incremental() %}
  WHERE
    DATE(start_date) = DATE('now','-1 day') AND DATE(start_date) > (SELECT MAX(delivery_date) FROM {{ this }} )
{% else %}
  WHERE
    DATE(start_date) <= DATE('now','-1 day')
{% endif %}
GROUP BY
  scbc.city, DATE(s.start_date)
  
UNION ALL

SELECT
  COUNT(s.id) AS deliveries_number,
  scbb.city AS city,
  DATE(s.start_date) AS delivery_date
FROM 
  {{ ref ('link_subscriptions') }} s INNER JOIN {{ ref ('satellite_customers_b2b_last_updates') }} scbb
  ON s.customer_id = scbb.id
{% if is_incremental() %}
  WHERE
    DATE(start_date) = DATE('now','-1 day') AND DATE(start_date) > (SELECT MAX(delivery_date) FROM {{ this }} )
{% else %}
  WHERE
    DATE(start_date) <= DATE('now','-1 day')
{% endif %}
GROUP BY
  scbb.city, DATE(s.start_date)
