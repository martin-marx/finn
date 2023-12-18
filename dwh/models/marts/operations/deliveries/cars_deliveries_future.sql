{{
    config(
      materialized = 'table'
    )
}}

SELECT
  COUNT(s.id) AS deliveries_number,
  scbc.city AS city,
  DATE(s.start_date) AS delivery_date
FROM
  {{ ref ('link_subscriptions') }} s INNER JOIN {{ ref ('satellite_customers_b2c_last_updates') }} scbc
  ON s.customer_id = scbc.id
WHERE
  DATE(start_date) >= DATE('now')
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
WHERE
  DATE(start_date) >= DATE('now')
GROUP BY
  scbb.city, DATE(s.start_date)
