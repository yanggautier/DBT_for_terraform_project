SELECT 
    c.customer_id AS customer_id,
    c.first_name || ' ' || c.last_name AS customer_full_name,
    c.create_date AS customer_create_date,
    a.district AS customer_district,
    a.postal_code AS customer_postal_code,
    ci.city AS customer_city,
    co.country AS customer_country,
    SUM(r.amount) AS total_spent,
    COUNT(r.rental_id) AS total_rentals,
    AVG(r.amount) AS average_rental_value,
    AVG(EXTRACT(EPOCH FROM(r.return_date - r.rental_date) / 3600 / 24)) AS avg_rental_duration,
    MIN(r.rental_date) AS first_rental_date,
    MAX(r.rental_date) AS last_rental_date
FROM
    {{ ref('stg_customer') }} AS c

JOIN 
    {{ ref('stg_rental') }} r ON c.customer_id = r.customer_id

LEFT JOIN 
    {{ ref('stg_address') }} AS a ON c.address_id = a.address_id

LEFT JOIN 
    {{ ref('stg_city') }} AS ci ON a.city_id = ci.city_id

LEFT JOIN 
    {{ ref('stg_country') }} AS co ON ci.country_id = co.country_id

WHERE 
    c.active = 1

GROUP BY 
    c.customer_id

