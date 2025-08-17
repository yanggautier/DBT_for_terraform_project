SELECT
    language_id,
    name
FROM
    {{ source('raw_data', 'language') }}