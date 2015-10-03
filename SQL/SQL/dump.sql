/* 
	Postgres Tutorial 
	http://www.postgresqltutorial.com
*/

-- use dvdrental sample DB

-- normal select
SELECT * FROM customer;

---------------------
-- ORDER BY
---------------------

SELECT  first_name, last_name
	FROM customer
	WHERE first_name like '%Ke%'
	ORDER BY 
		first_name ASC, 
		last_name DESC

---------------------------------------------------------
-- DISTINCT (remove duplicates rows from a result set)
---------------------------------------------------------

CREATE TABLE t1 (
	id serial NOT NULL PRIMARY KEY,
	bcolor VARCHAR (25),
	fcolor VARCHAR (25)
);

INSERT INTO t1 (bcolor, fcolor)
VALUES
	('red', 'red'),
	('red', 'red'),
	('red', NULL),
	(NULL, 'red'),
	('red', 'green'),
	('red', 'blue'),
	('green', 'red'),
	('green', 'blue'),
	('green', 'green'),
	('blue', 'red'),
	('blue', 'green'),
	('blue', 'blue');

SELECT * FROM t1;

SELECT  DISTINCT bcolor 
	FROM t1 
	ORDER BY bcolor

SELECT  DISTINCT bcolor, fcolor 
FROM t1 
ORDER BY bcolor, fcolor

/*
Because we  specified both bcolor and fcolor columns in the SELECT DISTINCT clause, 
the values in both bcolor and fcolor columns are combined to evaluate the uniqueness of rows.
The query returns the unique combination of bcolor and fcolor in the t1 table. 
Notice that the row that has red value in the bcolor and fcolor columns is removed 
from the result set.
*/


SELECT DISTINCT
	ON (bcolor) bcolor,
	fcolor
FROM
	t1
ORDER BY
	bcolor,
	fcolor;


---------------------
-- WHERE 
---------------------

SELECT last_name, first_name
FROM customer
WHERE first_name = 'Jamie' AND
 last_name = 'Rice'	

SELECT customer_id,
 amount,
 payment_date
FROM payment
WHERE amount <= 1 OR amount >= 8;

-- Example of sum 
SELECT customer_id,
	sum(amount) as somatorio,
	sum(amount)/10 as SUMANDDIVIDE
FROM payment
GROUP   BY 
	customer_id
ORDER BY 
	customer_id

---------------------
-- IN Operator
---------------------
/*
You use the IN operator in the WHERE
clause to check if a value matches any value in a list of values
*/

SELECT customer_id,
	rental_id,
	return_date
FROM
	rental
WHERE
	customer_id IN (1, 2)
ORDER BY
	return_date DESC

---------------------	
-- NOT IN
---------------------

SELECT customer_id,
	rental_id,
	return_date
FROM
	rental
WHERE
	customer_id NOT IN (1, 2)
ORDER BY
	return_date DESC


-- using IN a subquery

SELECT 
	first_name,
	last_name
	FROM 
	customer
	WHERE 
	customer_id in (
		-- The following query returns a list of customer id of customers that has rental’s return date on 2005-05-27
		SELECT
			customer_id
		FROM
			rental
		WHERE
			CAST (return_date AS DATE) = '2005-05-27'
	)


---------------------
-- BETWEEN
---------------------
SELECT 
	customer_id,
	payment_id,
	amount 
FROM 
	payment
WHERE 
	amount BETWEEN 8 AND 9

SELECT 
	customer_id,
	payment_id,
	amount 
FROM 
	payment
WHERE 
	amount NOT BETWEEN 8 AND 9
	
SELECT
	customer_id,
	payment_id,
	amount,
        payment_date
FROM
	payment
WHERE
	payment_date BETWEEN '2007-02-07' AND '2007-02-15';	

---------------------
-- LIKE
---------------------
/*
Percent ( %)  for matching any sequence of characters.
Underscore ( _)  for matching any single character.
*/
SELECT
	first_name,
        last_name
FROM
	customer
WHERE
	first_name LIKE '_Jen%';


---------------------
-- UNION
---------------------

/*
The UNION operator combines result
sets of two or more SELECT statements into a single result set. 
-Both queries must return the same number of columns.
-The corresponding columns in the queries must have compatible data types
*/

--http://www.postgresqltutorial.com/postgresql-union/

---------------------
-- INNER JOIN
--The INNER JOIN clause returns rows in A table that have the corresponding rows in the B table.
---------------------


SELECT * FROM customer WHERE first_name = 'Peter'
SELECT * FROM payment WHERE customer_id = 341

SELECT  customer.customer_id,
	first_name,
	last_name,
	email,
	amount,
	payment_date
FROM 
	customer
INNER JOIN payment ON payment.customer_id = customer.customer_id
WHERE 
	customer.customer_id = 341
	
---

SELECT 
	customer.customer_id,
	customer.first_name customer_first_name,
	customer.last_name customer_last_name,
	customer.email,
	staff.first_name staff_first_name,
	staff.last_name staff_last_name,
	amount,
	payment_date
FROM 
	customer
INNER JOIN payment ON payment.customer_id = customer.customer_id
INNER JOIN staff ON payment.staff_id = staff.staff_id


---------------------
-- LEFT JOIN
---------------------

/*
If you want to select rows from the A table that have corresponding rows in the B table,
 you use the INNER JOIN clause.

If you want to select rows from the A table which may or may not have corresponding 
rows in the B table, you use the LEFT JOIN clause. In case there is no matching row 
in the B table, the values of the columns in the B table are substituted by the NULL values.

 NOTE:: The LEFT JOIN clause returns all rows in the left table ( A) that are combined 
 with rows in the right table ( B) even though there is no corresponding rows in the 
 right table ( B).


*/

SELECT * from film WHERE film_id = 801;
SELECT * from inventory WHERE film_id = 801;
SELECT * from inventory WHERE film_id = 1

SELECT 
	film.film_id,
	film.title,
	inventory_id
 FROM
	film
LEFT JOIN 
	inventory ON inventory.film_id = film.film_id


SELECT 
	film.film_id,
	film.title,
	inventory_id
 FROM
	film
LEFT JOIN 
	inventory ON inventory.film_id = film.film_id
WHERE
	inventory.film_id IS NULL

---------------------
-- GROUP BY
---------------------
/*
The GROUP BY clause divides the rows returned
from the SELECT statement into groups. For each group, you
can apply an aggregate function e.g., to calculate the sum 
of items or count the number of items in the groups.
*/

SELECT
	count(customer_id) as nr_registo,
	sum (amount)
FROM
	payment
WHERE customer_id = 251	
GROUP BY
	customer_id;

--

SELECT
	customer_id as id,
	count(customer_id) as nr_registo,
	sum (amount)
FROM
	payment
GROUP BY
	customer_id
ORDER BY 
	SUM(amount) DESC,
	customer_id
	;	

--
/*
To count the number of transactions each staff has been processing, you
 group the payments table based on staff id and use the COUNT function to
  get the number of transactions 
*/
SELECT
	staff_id,
	COUNT (payment_id)
FROM
	payment
GROUP BY
	staff_id;



---------------------	
-- HAVING
---------------------
/*
Eliminate groups of rows that do not satisfy a specified condition

SELECT
	column_1,
	aggregate_function (column_2)
FROM
	tbl_name
GROUP BY
	column_1
HAVING
	condition;
	
The HAVING clause sets the condition for group rows created by the GROUP BY 
clause after the GROUP BY clause applies, while the WHERE clause sets the
condition for individual rows before GROUP BY clause applies. This is the 
main difference between the HAVING and WHERE clauses.
*/
SELECT
	customer_id,
	SUM (amount)
FROM
	payment
GROUP BY
	customer_id
HAVING
	SUM (amount) > 200
;

-- number of clients for eache store
SELECT
	store_id,
	COUNT (customer_id)
FROM
	customer
GROUP BY
	store_id

-- store with more than 300
SELECT
	store_id,
	COUNT (customer_id)
FROM
	customer
GROUP BY
	store_id
HAVING
	COUNT (customer_id) > 300;	



---------------------
-- SUBQUERY
---------------------

SELECT
	AVG (rental_rate)
FROM
	film;
	
-- select movies above average
	
SELECT
	film_id,
	title,
	rental_rate
FROM
	film
WHERE
	rental_rate > 2.98;

-- using subquery	

SELECT
	film_id,
	title,
	rental_rate
FROM
	film
WHERE
	rental_rate > (
		SELECT
			AVG (rental_rate)
		FROM
			film
	);


--get films that have return date between 2005-05-29 and 2005-05-30

SELECT
	inventory.film_id
FROM
	rental
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
WHERE
	return_date BETWEEN '2005-05-29'
AND '2005-05-30'	

-- name of films

SELECT 
	film_id,
	title
FROM
	film
WHERE
	film_id IN (
		SELECT
			inventory.film_id
		FROM
			rental
		INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
		WHERE
			return_date BETWEEN '2005-05-29'
		AND '2005-05-30'
	)

--EXISTS

SELECT
	first_name,
	last_name
FROM
	customer
WHERE
	EXISTS (
		SELECT
			1
		FROM
			payment
		WHERE
			payment.customer_id = customer.customer_id
	);
