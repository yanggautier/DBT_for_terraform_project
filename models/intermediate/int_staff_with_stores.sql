SELECT
    s.staff_id AS staff_id,
    s.first_name || ' ' || s.last_name AS staff_full_name,
    st.store_id AS store_id,
    st.address_id AS store_address_id,
FROM 
    {{ ref('stg_staff') }} AS s
LEFT JOIN 
    {{ ref('stg_store') }} AS st ON s.store_id = st.store_id
WHERE 
    s.active = 1