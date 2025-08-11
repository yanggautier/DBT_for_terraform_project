SELECT
    category_id,
    name
FROM
    {{ source('raw_data', 'category') }}