SELECT
    customer_id,
    store_id,
    first_name,
    last_name,
    address_id,
    create_date
FROM
    {{ source('raw_data', 'customer') }}
WHERE
    active = 1