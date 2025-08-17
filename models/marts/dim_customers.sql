SELECT 
    customer_id,
    customer_full_name,
    customer_create_date
    customer_district,
    custonmer_postal_code,
    customer_city,
    customer_country,
    total_spent,
    total_rentals,
    average_rental_value,
    avg_rental_duration,
    first_rental_date,
    last_rental_date
FROM 
    {{ ref('int_customer_with_details') }}