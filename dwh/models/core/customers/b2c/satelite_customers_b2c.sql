{{
    config(unique_key='hash')
}}

SELECT
  id,
  first_name,
  second_name,
  address_city AS city,
  address_zip AS zip,
  address_street AS street,
  address_street_house AS street_house,
  MD5(
    UPPER(COALESCE(id, '')
    || '^' || COALESCE(first_name, '')
    || '^' || COALESCE(second_name, '')
    || '^' || COALESCE(address_city, '')
    || '^' || COALESCE(address_zip, '')
    || '^' || COALESCE(address_street, '')
    || '^' || COALESCE(address_street_house, '')
  )) AS hash,
  DATETIME('now') AS updated_at
FROM
  {{ source('auto_sources','customers') }}
{% if is_incremental() %}
  WHERE processing_date >= DATE('now','-1 day') AND UPPER(type) = 'B2C'
{% else %}
  WHERE UPPER(type) = 'B2C'
{% endif %}