SELECT
    address_id,
    address,
    address2,
    district,
    city_id,
    postal_code,
    phone
FROM
    {{ source('raw_data', 'address') }}
