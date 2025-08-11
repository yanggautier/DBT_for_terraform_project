SELECT
    inventory_id,
    film_id,
    store_id
FROM
    {{ source('raw_data', 'inventory') }}