-- 1. Display all customer details who have made more than 5 payments
-- First, group payments by customer and count their payments
SELECT * FROM customer WHERE customer_id IN (
SELECT customer_id FROM payment
GROUP BY customer_id
HAVING COUNT(payment_id) > 5
);


-- 2. Find the names of actors who have acted in more than 10 films
-- Join actor and film_actor to count the films for each actor

SELECT a.actor_id,a.first_name,a.last_name,
COUNT(fa.film_id) AS total_films FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id,a.first_name,a.last_name
HAVING COUNT(fa.film_id) > 10
ORDER BY total_films DESC;


-- 3. Find the names of customers who never made a payment
-- I have Used NOT EXISTS to find customers without payment records

SELECT c.customer_id,c.first_name,c.last_name FROM customer c
WHERE NOT EXISTS (SELECT 1 FROM payment p
WHERE p.customer_id = c.customer_id);


-- 4. List all films whose rental rate is higher than
-- the average rental rate of all films

SELECT film_id,title,rental_rate FROM film
WHERE rental_rate > (SELECT AVG(rental_rate)FROM film)
ORDER BY rental_rate DESC;


-- 5. List the titles of films that were never rented
-- Checking the rental table through inventory
SELECT f.film_id,f.title FROM film f
WHERE NOT EXISTS (SELECT 1 FROM inventory i
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE i.film_id = f.film_id);


-- 6. Display customers who rented films in the same month
-- as the customer with ID 5
SELECT DISTINCT c.customer_id,c.first_name,c.last_name FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
WHERE EXTRACT(MONTH FROM r.rental_date) IN (
SELECT DISTINCT EXTRACT(MONTH FROM rental_date)FROM rental WHERE customer_id = 5
)AND c.customer_id <> 5;


-- 7. Find staff members who handled a payment greater
-- than the average payment amount

SELECT DISTINCT s.staff_id,s.first_name,s.last_name
FROM staff s
JOIN payment p ON s.staff_id = p.staff_id
WHERE p.amount > (SELECT AVG(amount)FROM payment);


-- 8. Show film title and rental duration for films
-- whose rental duration is greater than the average
SELECT title,rental_duration FROM film
WHERE rental_duration > (SELECT AVG(rental_duration)FROM film)
ORDER BY rental_duration DESC;

-- 9. Find customers who have the same address
-- as customer with ID 1
SELECT c.customer_id,c.first_name,c.last_name,c.address_id FROM customer c
WHERE c.address_id = (SELECT address_id FROM customer WHERE customer_id = 1)
AND c.customer_id <> 1;

-- 10. List all payments that are greater than
-- the average of all payments
SELECT payment_id,customer_id,staff_id,amount,payment_date FROM payment
WHERE amount > (SELECT AVG(amount)FROM payment)
ORDER BY amount DESC;