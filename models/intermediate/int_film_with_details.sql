SELECT
    f.film_id AS film_id,
    f.title AS title,
    f.release_year AS release_year,
    f.rental_duration AS rental_duration,
    f.rental_rate AS rental_rate,
    f.rating AS rating,
    f.length AS length,
    f.replacement_cost AS replacement_cost,
    array_agg(c.name) AS category_names,
    array_agg(a.first_name || ' ' || a.last_name) AS actors,
    l.name AS language_name,
    l2.name AS original_language_name,
FROM
    {{ ref('stg_film') }} AS f

LEFT JOIN
    {{ ref('stg_film_category') }} fc ON f.film_id = fc.film_id

LEFT JOIN
    {{ ref('stg_category') }} c ON fc.category_id = c.category_id

LEFT JOIN
    {{ ref('stg_language') }} l ON f.language_id = l.language_id

LEFT JOIN
    {{ ref('stg_language') }} l2 ON f.original_language_id = l2.language_id

LEFT JOIN
    {{ ref('stg_film_actor') }} fa ON f.film_id = fa.film_id

LEFT JOIN
    {{ ref('stg_actor') }} a ON fa.actor_id = a.actor_id

GROUP BY
    f.film_id