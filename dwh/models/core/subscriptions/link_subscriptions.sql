{{
    config(unique_key='hash')
}}

SELECT
  id,
  customer_id,
  car_id,
  created_at,
  start_date,
  term_month,
  monthly_rate,
  MD5(
    UPPER(COALESCE(id, '')
    || '^' || COALESCE(customer_id, '')
    || '^' || COALESCE(car_id, '')
    || '^' || COALESCE(created_at, '')
    || '^' || COALESCE(start_date, '')
    || '^' || COALESCE(term_month, '')
    || '^' || COALESCE(monthly_rate, '')
  )) AS hash
FROM
  {{ source('auto_sources','subscriptions') }}
{% if is_incremental() %}
  WHERE processing_date >= DATE('now','-1 day')
{% endif %}
