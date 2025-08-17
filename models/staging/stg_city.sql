SELECT
    city_id,
    city,
    country_id
FROM
    {{ source('raw_data', 'city') }}