SELECT
    staff_id,
    store_id,
    active,
    username
FROM
    {{ source('raw_data', 'staff') }}