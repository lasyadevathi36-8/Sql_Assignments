-- 1. STORE TABLE
CREATE TABLE store (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(50)
);

-- 2. CUSTOMER TABLE
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    store_id INT REFERENCES store(store_id),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    active INT
);

-- 3. FILM TABLE
CREATE TABLE film (
    film_id INT PRIMARY KEY,
    title VARCHAR(100),
    description TEXT,
    rental_rate NUMERIC(4,2),
    replacement_cost NUMERIC(5,2),
    rating VARCHAR(10),
    length INT,
    rental_duration INT
);

-- 4. ACTOR TABLE
CREATE TABLE actor (
    actor_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

-- 5. FILM_ACTOR TABLE
CREATE TABLE film_actor (
    actor_id INT REFERENCES actor(actor_id),
    film_id INT REFERENCES film(film_id),
    PRIMARY KEY (actor_id, film_id)
);

-- 6. INVENTORY TABLE
CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY,
    film_id INT REFERENCES film(film_id),
    store_id INT REFERENCES store(store_id)
);

-- 7. RENTAL TABLE
CREATE TABLE rental (
    rental_id INT PRIMARY KEY,
    rental_date TIMESTAMP,
    inventory_id INT REFERENCES inventory(inventory_id),
    customer_id INT REFERENCES customer(customer_id)
);

-- 8. PAYMENT TABLE
CREATE TABLE payment (
    payment_id INT PRIMARY KEY,
    customer_id INT REFERENCES customer(customer_id),
    rental_id INT REFERENCES rental(rental_id),
    amount NUMERIC(6,2),
    payment_date TIMESTAMP
);

-- STORE DATA
INSERT INTO store VALUES
(1, 'Store One'),
(2, 'Store Two');

-- CUSTOMER DATA
INSERT INTO customer VALUES
(1, 1, 'John', 'Smith', 'john@gmail.com', 1),
(2, 1, 'Jessica', 'Brown', 'jessica@org.org', 1),
(3, 1, 'David', 'Wilson', 'david@gmail.com', 0),
(4, 1, 'Maria', 'Jones', NULL, 1),
(5, 1, 'James', 'Smith', 'james@gmail.com', 1),
(6, 2, 'Julia', 'Davis', 'julia@org.org', 1),
(7, 2, 'Thomas', 'Miller', NULL, 0),
(8, 2, 'Anna', 'Taylor', 'anna@gmail.com', 1),
(9, 2, 'Joseph', 'White', 'joseph@gmail.com', 1),
(10, 2, 'Sophia', 'Smith', NULL, 1);

-- FILM DATA
INSERT INTO film VALUES
(1, 'Titanic', 'Romantic drama', 4.99, 20.00, 'PG-13', 195, 5),
(2, 'Terminator', 'Action movie', 4.50, 25.00, 'R', 120, 5),
(3, 'Toy Story', 'Animated family movie', 2.99, 15.00, 'G', 90, 6),
(4, 'The Action Hero', 'Action and adventure', 3.99, 22.00, 'PG', 110, 5),
(5, 'War Zone', 'A movie about WAR', 3.50, 18.00, 'R', 130, 6),
(6, 'Top Gun', 'Military action film', 4.99, 30.00, 'PG', 110, 5),
(7, 'Tornado', 'Disaster movie', 2.50, 12.00, 'PG', 110, 5),
(8, 'Tomorrow', 'Science fiction', 3.99, 21.00, 'G', 110, 5),
(9, 'Terror Night', 'Horror film', 4.50, 19.00, 'R', 110, 5),
(10, 'Treasure Island', 'Adventure movie', 2.99, 14.00, 'PG', 110, 5),
(11, 'Finding Nemo', 'Animated movie', 2.99, 16.00, 'G', 95, 6),
(12, 'The Matrix', 'Science fiction action', 5.99, 28.00, 'R', 136, 6),
(13, 'Frozen', 'Family animation', 3.99, 20.00, 'PG', 102, 6),
(14, 'Jungle Book', 'Adventure movie', 2.99, 15.00, 'G', 105, 5),
(15, 'War Stories', 'A film about war', 5.50, 27.00, 'R', 140, 6),
(16, 'Titan Force', 'Action adventure', 4.99, 23.00, 'PG', 125, 5),
(17, 'The Lion King', 'Family animation', 2.99, 17.00, 'G', 88, 6),
(18, 'Action Point', 'Comedy action', 3.99, NULL, 'PG', 115, 5),
(19, 'Ghost', 'Drama movie', 3.50, 19.00, 'PG-13', 110, 5),
(20, 'Green World', 'Documentary', 1.99, 10.00, 'G', 100, 4);

-- ACTOR DATA
INSERT INTO actor
SELECT
    n,
    'Actor' || n,
    'Lastname' || n
FROM generate_series(1, 12) AS n;

-- FILM_ACTOR DATA
INSERT INTO film_actor (actor_id, film_id)
SELECT a.actor_id, f.film_id
FROM actor a
CROSS JOIN film f;

-- INVENTORY DATA
-- Only films 1 through 15 are added.
INSERT INTO inventory
SELECT
    n,
    ((n - 1) % 15) + 1,
    ((n - 1) % 2) + 1
FROM generate_series(1, 30) AS n;

-- RENTAL DATA
INSERT INTO rental
SELECT
    n,
    TIMESTAMP '2026-10-01 10:00:00'
        + (n * INTERVAL '1 minute'),
    ((n - 1) % 30) + 1,
    ((n - 1) % 10) + 1
FROM generate_series(1, 120) AS n;

-- PAYMENT DATA
INSERT INTO payment
SELECT
    n,
    ((n - 1) % 10) + 1,
    n,
    (2.00 + (n % 5)),
    TIMESTAMP '2026-10-01 12:00:00'
FROM generate_series(1, 120) AS n;

--Get all customers whose first name starts with 'J' and who are active.
SELECT * FROM customer WHERE first_name LIKE 'J%' AND active = 1;

--Find all films where the title contains 'ACTION' or description contains 'WAR'.
SELECT * FROM film WHERE title ILIKE '%ACTION%' OR description ILIKE '%WAR%';

--List customers whose last name is not 'SMITH' and first name ends with 'a'.
SELECT * FROM customer WHERE last_name != 'SMITH' AND first_name LIKE '%a';

--Get all films where the rental rate is greater than 3.0 and the replacement cost is not null.
SELECT * FROM film WHERE rental_rate > 3.0 AND replacement_cost IS NOT NULL;

--Count how many customers exist in each store who have active status = 1.
SELECT store_id,
COUNT(*) AS total_customers
FROM customer WHERE active = 1 GROUP BY store_id;

--Show distinct film ratings available in the film table.
SELECT DISTINCT rating FROM film;

--Find the number of films for each rental duration where the average length is more than 100 minutes.
SELECT rental_duration,
COUNT(*) AS total_films,
AVG(length) AS average_length FROM film
GROUP BY rental_duration
HAVING AVG(length) > 100;

--List payment dates and total amount paid per date, but only include days where more than 100 payments were made.
SELECT DATE(payment_date) AS payment_day,
SUM(amount) AS total_amount,
   COUNT(*) AS total_payments
FROM payment
GROUP BY DATE(payment_date)
HAVING COUNT(*) > 100;

-- Find customers whose email is missing or ends with .org
SELECT * FROM customer WHERE email IS NULL OR email LIKE '%.org';


-- Get PG and G rated films
-- We are Sorting by rental rate from highest to lowest
SELECT * FROM film WHERE rating IN ('PG', 'G')
ORDER BY rental_rate DESC;


-- Count films for each length where title starts with T
-- Only showing lengths with more than 5 films
SELECT length, COUNT(*) AS total_films FROM film
WHERE title LIKE 'T%'
GROUP BY length
HAVING COUNT(*) > 5;


-- Find actors who appeared in more than 10 films
SELECT a.actor_id,a.first_name,a.last_name,
COUNT(fa.film_id) AS total_films
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id,a.first_name,a.last_name
HAVING COUNT(fa.film_id) > 10
ORDER BY total_films DESC;


-- Find the top 5 films based on rental rate and length
--Here we are Sorting rental rate first, then film length
SELECT title,rental_rate,length FROM film
ORDER BY rental_rate DESC,length DESC LIMIT 5;

-- Display all customers with their total number of rentals
-- Include customers who have never rented anything
SELECT c.customer_id,c.first_name,c.last_name,
COUNT(r.rental_id) AS total_rentals
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id,c.first_name,c.last_name
ORDER BY total_rentals DESC;


-- Find films that have never been rented
SELECT f.film_id,f.title FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;


