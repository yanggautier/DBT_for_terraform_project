SELECT
    rental_id,
    rental_date,
    inventory_id,
    customer_id,
    return_date,
    staff_id
FROM
    {{ source('raw_data', 'rental') }}
