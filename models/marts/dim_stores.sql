SELECT
    s.store_id AS store_id,
    a.address AS store_address,
    a.postal_code AS store_postal_code,
    st.first_name || " " || st.last_name AS store_manager,
    c.city AS store_city,
    co.country AS store_country,
FROM 
    {{ ref('stg_store') }} AS s
LEFT JOIN
    {{ ref('stg_address') }} AS a ON s.address_id = a.address_id
LEFT JOIN
    {{ ref('stg_staff') }} AS st ON s.store_id = st.store_id
LEFT JOIN
    {{ ref('stg_city') }} AS c ON a.city_id = c.city_id
LEFT JOIN
    {{ ref('stg_country') }} AS co ON c.country_id = co.country_id