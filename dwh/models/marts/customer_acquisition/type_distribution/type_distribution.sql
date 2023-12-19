{{
    config(
      materialized = 'table'
    )
}}


WITH customers_types AS (
  SELECT
    id,
    'B2C' AS tp
  FROM
    {{ ref('satellite_customers_b2c_last_updates')}}

  UNION ALL

  SELECT
    id,
    'B2B' AS tp
  FROM
    {{ ref('satellite_customers_b2b_last_updates')}}
)
SELECT
  SUM(IIF(ct.tp = 'B2B', 1, 0)) AS b2b_distribution,
  SUM(IIF(ct.tp = 'B2C', 1, 0)) AS b2c_distribution,
  ls.term_month         AS term
FROM
  {{ ref('link_subscriptions')}} ls INNER JOIN customers_types ct
  ON ls.customer_id = ct.id
GROUP BY
  ls.term_month
