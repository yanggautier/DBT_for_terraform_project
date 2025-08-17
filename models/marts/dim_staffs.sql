SELECT 
    s.*,
    COUNT(r.rental_id) AS staff_total_rentals,
    SUM(p.amount) AS staff_total_payments

FROM 
    {{ ref('int_staff_with_stores') }} AS s

LEFT JOIN 
    {{ ref('int_rentals_with_details') }} AS r ON s.staff_id

LEFT JOIN 
    {{ ref('int_payments') }} AS p ON r.rental_id = p.rental_id

GROUP BY s.staff_id