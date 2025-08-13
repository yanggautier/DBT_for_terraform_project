WITH p AS (
    SELECT * 
    FROM {{ ref('stg_payment') }}
),
c AS (
    SELECT
        *
    FROM
        {{ ref('stg_customer') }}
)
SELECT
    p.payment_id AS payment_id,
    p.amount AS amount,
    p.payment_date AS payment_date,
    p.customer_id AS customer_id,
    c.first_name || ' ' || c.last_name AS customer_full_name,
    c.address_id AS address_id,
    c.create_date AS customer_create_date,
FROM
    p
JOIN
    c ON p.customer_id = c.customer_id 