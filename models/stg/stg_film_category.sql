SELECT
    film_id,
    category_id
FROM
    {{ source('raw_data', 'film_category') }}