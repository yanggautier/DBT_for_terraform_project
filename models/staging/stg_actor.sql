SELECT
    actor_id,
    first_name,
    last_name
FROM
    {{ source('raw_data', 'actor') }}