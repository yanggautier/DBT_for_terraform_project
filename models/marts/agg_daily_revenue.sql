SELECT 
    rental_id,
    rental_date,
    return_date,
    customer_id,
    staff_id,
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
    {{ ref('fct_rentals') }}  
