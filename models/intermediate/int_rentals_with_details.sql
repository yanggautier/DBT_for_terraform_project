SELECT
    r.rental_id AS rental_id,
    r.rental_date AS rental_date,
    r.return_date AS return_date,
    r.customer_id AS customer_id,
    r.staff_id AS staff_id,
    f.film_id AS film_id,
    f.title AS title,
    f.release_year AS release_year,
    f.language_id AS language_id,
    f.original_language_id AS original_language_id,
    f.rental_duration AS rental_duration,
    f.rental_rate AS rental_rate,
    f.replacement_cost AS replacement_cost,
    EXTRACT(EPOCH FROM(f.return_date - f.rental_date) / 3600 / 24) AS rental_duration,
    f.rating AS rating,
    p.amount AS payment_amount,
    f.length AS length,
    sto.store_id AS store_id,
FROM
    {{ ref('stg_rental') }} AS r

LEFT JOIN
    {{ ref('stg_film') }} f ON r.film_id = f.film_id

LEFT JOIN
    {{ ref('stg_customer') }} c ON r.customer_id = c.customer_id

LEFT JOIN
    {{ ref('stg_payment') }} s ON r.rental_id = s.rental_id

LEFT JOIN
    {{ ref('stg_staff') }} st ON r.staff_id = st.staff_id

LEFT JOIN
    {{ ref('stg_store') }} st2 ON sto.store_id = sto.store