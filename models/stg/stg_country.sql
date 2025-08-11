SELECT
    country_id,
    country
FROM
    {{ source('raw_data', 'country') }}