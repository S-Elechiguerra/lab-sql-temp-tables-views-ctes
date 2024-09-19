USE sakila;

-- Create a view Rental Summary

CREATE VIEW rental_summary AS
SELECT
    customer.customer_id,
    CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name,
    customer.email,
    COUNT(rental.rental_id) AS rental_count
FROM
    customer
JOIN
    rental ON customer.customer_id = rental.customer_id
GROUP BY
    customer.customer_id, customer_name, customer.email;

-- Temporary Table for payments

CREATE TEMPORARY TABLE customer_payments AS
SELECT
    rs.customer_id,
    rs.customer_name,
    rs.email,
    SUM(payment.amount) AS total_paid
FROM
    rental_summary rs
JOIN
    payment ON rs.customer_id = payment.customer_id
GROUP BY
    rs.customer_id, rs.customer_name, rs.email;
    
-- Customer summary report

WITH customer_summary AS (
    SELECT
        cp.customer_id,
        cp.customer_name,
        cp.email,
        cp.total_paid,
        rs.rental_count,
        cp.total_paid / rs.rental_count AS average_payment_per_rental
    FROM
        customer_payments cp
    JOIN
        rental_summary rs ON cp.customer_id = rs.customer_id
)
SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    average_payment_per_rental
FROM
    customer_summary;
