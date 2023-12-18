{{
    config(unique_key='hash')
}}

SELECT
  id,
  license_plate,
  registration_date,
  deregistration_date,
  MD5(
    UPPER(COALESCE(id, '')
    || '^' || COALESCE(license_plate, '')
    || '^' || COALESCE(registration_date, '')
    || '^' || COALESCE(deregistration_date, '')
  )) AS hash,
  DATETIME('now') AS updated_at
FROM
  {{ source('auto_sources','cars') }}
{% if is_incremental() %}
  WHERE processing_date >= DATE('now','-1 day')
{% endif %}
