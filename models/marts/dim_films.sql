WITH film_performance AS (
    SELECT
        film_id,
        AVG(rental_duration) AS avg_rental_duration,
        COUNT(rental_id) AS total_rentals,
        SUM(amount) AS total_revenue
    FROM
        {{ ref('int_rentals_with_details') }} AS r
    GROUP BY
        film_id
),
finaL_film_data AS (
    SELECT
        f.*,
        fp.avg_rental_duration AS avg_rental_duration,
        fp.total_rentals AS total_rentals,
        fp.total_revenue AS total_revenue,
        RANK() OVER (ORDER BY fp.total_revenue DESC) AS revenue_rank,
        RANK() OVER (ORDER BY fp.total_rentals DESC) AS rental_rank     
    FROM
        {{ ref('int_film_with_details') }} AS f
    LEFT JOIN
        film_performance AS fp ON f.film_id = fp.film_id
)
SELECT * FROM finaL_film_data