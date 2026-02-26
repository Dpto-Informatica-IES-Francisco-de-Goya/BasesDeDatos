use sakila;
SELECT 
    c.customer_id AS id_cliente,
    CONCAT(c.first_name, ' ', c.last_name) AS nombre_completo,
    COUNT(r.rental_id) AS cantidad_alquileres
FROM customer AS c
INNER JOIN rental AS r 
    ON c.customer_id = r.customer_id
WHERE c.store_id = 1
GROUP BY c.customer_id
ORDER BY cantidad_alquileres DESC
LIMIT 10;


SELECT 
    c.customer_id AS id_cliente,
    CONCAT(c.first_name, ' ', c.last_name) AS nombre_completo,
    COUNT(r.rental_id) AS cantidad_alquileres
FROM customer AS c
LEFT JOIN rental AS r 
    ON c.customer_id = r.customer_id
WHERE c.store_id = 1
GROUP BY c.customer_id
ORDER BY c.customer_id
LIMIT 10;


SELECT 
    a.actor_id,
    CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor,
    f.title AS titulo_pelicula
FROM film AS f
RIGHT JOIN film_actor AS fa 
    ON f.film_id = fa.film_id
RIGHT JOIN actor AS a 
    ON fa.actor_id = a.actor_id
WHERE a.actor_id <= 10;

SELECT 
    c.category_id,
    c.name AS categoria,
    f.title AS pelicula
FROM category AS c
LEFT JOIN film_category AS fc 
    ON c.category_id = fc.category_id
LEFT JOIN film AS f 
    ON fc.film_id = f.film_id

UNION

SELECT 
    c.category_id,
    c.name AS categoria,
    f.title AS pelicula
FROM category AS c
RIGHT JOIN film_category AS fc 
    ON c.category_id = fc.category_id
RIGHT JOIN film AS f 
    ON fc.film_id = f.film_id
LIMIT 10;


SELECT 
    f.film_id,
    f.title,
    a.actor_id,
    CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor
FROM film AS f
LEFT JOIN film_actor AS fa 
    ON f.film_id = fa.film_id
LEFT JOIN actor AS a 
    ON fa.actor_id = a.actor_id
LIMIT 10;
