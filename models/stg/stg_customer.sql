SELECT
    customer_id,
    store_id,
    active,
    create_date
FROM
    {{ source('raw_data', 'customer') }}