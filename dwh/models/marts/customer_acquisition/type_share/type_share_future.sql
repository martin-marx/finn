{{
    config(
      materialized = 'table'
    )
}}

WITH RECURSIVE dates(month) AS (
  SELECT DATE('now', 'start of month')
  UNION ALL
  SELECT DATE(month, '+1 month')
  FROM dates
  WHERE month <= (SELECT DATE(MAX(start_date), IIF(term_month = 'six', '+6 months', '12 months'), 'start of month') FROM {{ ref('link_subscriptions') }})
),
customers_types AS (
  SELECT
    id,
    'B2C' AS tp
  FROM
    {{ ref('satellite_customers_b2c_last_updates') }}

  UNION ALL

  SELECT
    id,
    'B2B' AS tp
  FROM
    {{ ref('satellite_customers_b2b_last_updates') }}
),
prepared_subscriptions AS (
  SELECT
    DATE(ls.start_date) AS start_date,
    IIF(ls.term_month = 'six', DATE(ls.start_date, '+6 months'), DATE(ls.start_date, '12 months')) AS end_date,
    ct.tp         AS tp,
    hc.brand      AS brand
  FROM
    {{ ref('link_subscriptions') }} ls
    INNER JOIN customers_types ct ON ls.customer_id = ct.id
    INNER JOIN hub_cars hc ON ls.car_id = hc.id
)
SELECT
  m.month AS month,
  ps.brand AS brand,
  SUM(IIF(ps.tp = 'B2B', 1, 0) * 1.0) / COUNT(*) AS b2b_share,
  SUM(IIF(ps.tp = 'B2C', 1, 0) * 1.0) / COUNT(*) AS b2c_share
FROM
  dates m JOIN prepared_subscriptions ps ON m.month BETWEEN ps.start_date AND ps.end_date
GROUP BY
  m.month, ps.brand
