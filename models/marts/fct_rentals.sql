SELECT
    rental_id,
    rental_date,
    return_date,
    rental_duration,
    rental_rate,
    payment_amount,
    customer_id,
    staff_id,
    film_id,
    store_id,
FROM 
    {{ ref('int_rental_with_details') }}