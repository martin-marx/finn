{{
    config(unique_key='id')
}}

SELECT
  id
FROM
  {{ source('auto_sources','customers') }}
{% if is_incremental() %}
  WHERE processing_date >= DATE('now','-1 day')
{% endif %}
