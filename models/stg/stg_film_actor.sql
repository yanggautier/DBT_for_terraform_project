SELECT
    actor_id,
    film_id
FROM
    {{ source('raw_data', 'film_actor') }}