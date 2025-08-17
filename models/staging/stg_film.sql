SELECT
    film_id,
    title,
    release_year,
    language_id,
    original_language_id,
    rental_duration,
    rental_rate,
    replacement_cost,
    rating,
    length
FROM
    {{ source('raw_data', 'film') }}