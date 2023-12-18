{{
    config(
      materialized = 'incremental'
    )
}}

{% if is_incremental() %}
WITH dates AS (
  SELECT DATE('now', 'start of month', '-1 months') AS month
),
{% else %}
WITH RECURSIVE dates(month) AS (
  SELECT DATE(MIN(start_date), 'start of month') FROM {{ ref('link_subscriptions') }}
  UNION ALL
  SELECT DATE(month, '+1 month')
  FROM dates
  WHERE month < DATE('now', 'start of month', '-1 month')
),
{% endif %}
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
{% if is_incremental() %}
  WHERE
    (IIF(ls.term_month = 'six', DATE(ls.start_date, '+6 months'), DATE(ls.start_date, '12 months')) > (SELECT MAX(DATE(month, 'end of month')) FROM {{ this }} ))
    AND (DATE(ls.start_date) < DATE('now', 'start of month'))
{% endif %}
)
SELECT
  m.month AS month,
  ps.brand AS brand,
  SUM(IIF(ps.tp = 'B2B', 1, 0) * 1.0) / COUNT(*) AS B2B_share,
  SUM(IIF(ps.tp = 'B2C', 1, 0) * 1.0) / COUNT(*) AS B2C_share
FROM
  dates m JOIN prepared_subscriptions ps ON m.month BETWEEN ps.start_date AND ps.end_date
GROUP BY
  m.month, ps.brand
