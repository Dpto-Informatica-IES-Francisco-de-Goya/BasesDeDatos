use sakila;

-- Curiosidad:
select * from tienda_online.clientes;

select * from actor limit 5;

-- 1) Cinco actores con más películas
/*
1) Tabla/s necesaria/s (y tablas intermedias si no están relacionadas)
2) Columnas que relacionan.
3) Filtros, agrupaciones y agregaciones, having
4) Orden
*/
SELECT actor.first_name,actor.last_name,COUNT(film_id) as num_peliculas
FROM 
	actor
		JOIN
	film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id 
ORDER BY num_peliculas DESC;
-- CONCLUSIÓN: Puedes agrupar por columnas que no estén en el select, siempre y cuando
-- lo que pongas en el select dependa funcionalmente de lo que está en el group by.

-- ATAJOS: renombrar cada tabla.
SELECT a.first_name,a.last_name,COUNT(film_id) as num_peliculas
FROM 
	actor a
		JOIN
	film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id 
ORDER BY num_peliculas DESC;

-- ATAJO 2: 
SELECT a.first_name,a.last_name,COUNT(film_id) as num_peliculas
FROM 
	actor a
		JOIN
-- film_actor fa ON a.actor_id = fa.actor_id
	film_actor fa USING(actor_id) 
GROUP BY a.actor_id 
ORDER BY num_peliculas DESC;

-- 2) País con más clientes
SELECT country,count(customer_id) as num_customers
FROM 
	customer
		JOIN
	address USING(address_id)
		JOIN
	city USING(city_id)
		JOIN
	country USING(country_id)
GROUP BY country_id
ORDER BY num_customers DESC
LIMIT 1;

-- 2.2) Países con más de 40 clientes
SELECT country,count(customer_id) as num_customers
FROM 
	customer
		JOIN
	address USING(address_id)
		JOIN
	city USING(city_id)
		JOIN
	country USING(country_id)
GROUP BY country_id
-- filtrar
HAVING num_customers > 40
ORDER BY num_customers DESC;


-- 3) Tres películas con mayores ingresos por alquiler
-- payment,rental,inventory,film

SELECT film.title, sum(amount)
FROM 
	payment
		JOIN
	rental USING(rental_id)
		JOIN
	inventory USING(inventory_id)
		JOIN
	-- film USING(film_id)
    film ON film.film_id = inventory.film_id
GROUP BY film_id; -- Esta columna es ambigua.

SELECT film.title, sum(amount) as total
FROM 
	payment
		JOIN
	rental USING(rental_id)
		JOIN
	inventory USING(inventory_id)
		JOIN
	film USING(film_id)
    -- film ON film.film_id = inventory.film_id
GROUP BY film_id
ORDER BY total DESC; -- Esta columna ya no es ambigua.



-- -----------------------------------------------------------------------------
-- 4) Cliente que más ha gastado
-- -----------------------------------------------------------------------------
-- ESTO NO FUNCIONA
SELECT CONCAT(first_name,' ',last_name) AS full_name,SUM(p.amount) AS total_spent, customer_id
FROM 
	customer c
		JOIN
	payment p USING(customer_id)
    -- payment p ON c.customer_id = p.customer_id;
GROUP BY first_name,last_name;


-- ESTO SÍ FUNCIONA
SELECT CONCAT(first_name,' ',last_name) AS full_name,SUM(p.amount) AS total_spent
FROM 
	customer c
		JOIN
	payment p USING(customer_id)
    -- payment p ON c.customer_id = p.customer_id;
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 1;

/** CONCLUSIONES de lo de la dependencia funcional:
- 
- 
- 
*/

/** Otra forma: trailer del futuro:*/
SELECT customer_id
FROM payment
GROUP BY customer_id
HAVING sum(amount) >= (
						SELECT sum(amount) 
						FROM payment
						GROUP BY customer_id 
						ORDER BY sum(amount) DESC limit 1
					);

SELECT CONCAT(first_name,' ',last_name ) AS full_name
FROM customer 
WHERE customer_id = 526;

SELECT CONCAT(first_name,' ',last_name ) AS full_name
FROM customer 
WHERE customer_id = (
						SELECT customer_id
						FROM payment
						GROUP BY customer_id
						HAVING sum(amount) >= (
									SELECT sum(amount) 
									FROM payment
									GROUP BY customer_id 
									ORDER BY sum(amount) DESC limit 1
								)
					);



-- No funciona porque el customer_id del group by son, en realidad, 2 columnas.
SELECT CONCAT(first_name,' ',last_name) AS full_name,SUM(p.amount) AS total_spent
FROM 
	customer c
		JOIN
	-- payment p USING(customer_id)
    payment p ON c.customer_id = p.customer_id
GROUP BY customer_id;

-- -----------------------------------------------------------------------------
-- 5) Ingreso promedio por alquiler en cada tienda
-- -----------------------------------------------------------------------------
-- STORE -> STAFF (using store_id) -> PAYMENT
SELECT 
    store.store_id AS tienda,
    AVG(payment.amount) AS ingreso_promedio_por_alquiler,
    count(payment.amount) AS num_pagos
FROM
    store
        JOIN
    staff USING(store_id)
        JOIN
    payment USING(staff_id)
GROUP BY store.store_id;

-- STORE -> STAFF ON manager_staff_id = staff_id -> PAYMENT
-- STORE -> ADDRESS -> STAFF -> PAYMENT
-- STORE -> INVENTORY -> RENTAL -> PAYMENT
SELECT 
    s.store_id,
    AVG(p.amount) AS avg_revenue_per_rental,
    COUNT(p.amount) AS num_pagos
FROM
    payment p
        JOIN
    rental r ON p.rental_id = r.rental_id
        JOIN
    inventory i ON r.inventory_id = i.inventory_id
        JOIN
    store s ON i.store_id = s.store_id
GROUP BY s.store_id;

-- STORE -> CUSTOMER -> PAYMENT
SELECT 
    store.store_id AS tienda,
    AVG(payment.amount) AS ingreso_promedio_por_alquiler,
    count(payment.amount) AS num_pagos
FROM
    store
        JOIN
    customer ON store.store_id = customer.store_id
        JOIN
    payment ON customer.customer_id = payment.customer_id
GROUP BY store.store_id;
-- STORE -> CUSTOMER -> RENTAL -> PAYMENT
SELECT 
    store.store_id AS tienda,
    AVG(payment.amount) AS ingreso_promedio_por_alquiler,
    count(payment.amount) AS num_pagos
FROM
    store
        JOIN
    customer ON store.store_id = customer.store_id
        JOIN
    rental ON customer.customer_id = rental.customer_id
        JOIN
    payment ON rental.rental_id = payment.rental_id
GROUP BY store.store_id;


-- STORE -> CUSTOMER -> (RENTAL ->) PAYMENT. 1 -> 4.22
-- STORE -> INVENTORY -> RENTAL -> PAYMENT. 1 -> 4.25
-- STORE -> STAFF (using store_id) -> PAYMENT 1 -> 4.15


/** CONCLUSIONES:
- SAKILA es sencillita y simplona.
- 
- */

-- -----------------------------------------------------------------------------
-- 6) Ventas totales por categoría ordenadas
-- -----------------------------------------------------------------------------
-- CATEGORY -> FILM_CATEGORY -> FILM -> INVENTORY -> RENTAL -> PAYMENT
SELECT 
    category.name AS categoria,
    SUM(payment.amount) AS total_pagado,
    COUNT(payment.amount) AS num_pagos
FROM
    payment
        JOIN
    rental USING (rental_id)
        JOIN
    inventory USING (inventory_id)
        JOIN
    film USING (film_id)
        JOIN
    film_category USING (film_id)
        JOIN
    category USING (category_id)
GROUP BY category.category_id
ORDER BY SUM(payment.amount) DESC;

-- PARA EL MIÉRCOLES:
-- -----------------------------------------------------------------------------
-- 7) Actores con al menos diez películas de categorías distintas
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- 10) Diez películas con mayor diferencia entre coste de reposición y tarifa de alquiler
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
-- 8) Tiendas con más stock disponible
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
-- 9) Películas que nunca han sido alquiladas
-- -----------------------------------------------------------------------------



-- -----------------------------------------------------------------------------
-- 11) Películas con más de tres actores y duración menor a 90 minutos
-- -----------------------------------------------------------------------------
