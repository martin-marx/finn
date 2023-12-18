{{
    config(unique_key='id')
}}

SELECT
  id,
  vin,
  brand,
  model,
  engine_type
FROM
  {{ source('auto_sources','cars') }}
{% if is_incremental() %}
  WHERE processing_date >= DATE('now','-1 day')
{% endif %}
