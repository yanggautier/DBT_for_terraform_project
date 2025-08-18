SELECT
    store_id,
    manager_staff_id,
    address_id
FROM
    {{ source('raw_data', 'store') }}