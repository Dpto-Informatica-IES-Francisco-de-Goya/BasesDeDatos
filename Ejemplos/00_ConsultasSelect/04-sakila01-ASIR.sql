-- Curiosidad:
select * from tienda_online.clientes;
use sakila;
select * from actor limit 5;

-- 1) Cinco actores con más películas
-- CONSULTAS QUE FALLAN:

SELECT actor.first_name, actor.last_name,COUNT(film_actor.film_id) AS num_peliculas
FROM 
	actor 
		JOIN
	-- film_actor USING(actor_id)
    film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY actor_id
-- GROUP BY actor.first_name
ORDER BY num_peliculas DESC 
LIMIT 5;



-- solución:

-- SELECT actor.*, COUNT(film_actor.film_id) AS num_peliculas
SELECT actor.first_name,last_name ,COUNT(film_actor.film_id) AS num_peliculas
FROM 
	actor 
		JOIN
	film_actor USING(actor_id)
    -- film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY actor_id
-- GROUP BY actor.first_name
ORDER BY num_peliculas DESC 
LIMIT 5;

/** CONCLUSIONES:
- Lo de la dependencia funcional...
- 
*/

-- 2) País con más clientes
SELECT 
	country.country AS nombre_pais,
    count(customer_id) AS num_clientes
FROM 
	customer
		JOIN
	address USING (address_id)
		JOIN
	city USING(city_id)
		JOIN
    country USING(country_id)
GROUP BY nombre_pais
ORDER BY num_clientes DESC
LIMIT 1;
-- 3) Tres películas con mayores ingresos por alquiler
-- 4) Cliente que más ha gastado
-- 5) Ingreso promedio por alquiler en cada tienda

/** CAMINOS:*/
-- STORE -> (address_id) 		-> STAFF  -> PAYMENT
-- ---- NO ES VALIDO porque address_id no relaciona estas tablas. Tendría que pasar por la tabla ADDRESS
-- STORE -> (manager_staff_id) 		-> STAFF  -> PAYMENT
-- ---- NO ES VALIDO porque solo me daría información de los pagos gestionados por el jefe de cada tienda.



-- STORE -> (address_id) -> ADDRESS 	-> STAFF -> PAYMENT
-- STORE -> (store_id) 				-> STAFF  -> PAYMENT (4.16 - 4.25)
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

-- STORE -> CUSTOMER -> PAYMENT (4.23 - 4.17)
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

-- STORE -> INVENTORY -> RENTAL -> PAYMENT (4.25 - 4.15)

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

-- STORE -> INVENTORY -> RENTAL -> PAYMENT (4.25 - 4.15)
-- STORE -> CUSTOMER -> PAYMENT (4.23 - 4.17)
-- STORE -> (store_id) 				-> STAFF  -> PAYMENT (4.16 - 4.25)

/**
 CONCLUSIONES:
 - 
 - 
 - 
*/

-- 6) Ventas totales por categoría ordenadas
-- 7) Actores con al menos diez películas de categorías distintas

-- ACTOR -> FILM_ACTOR -> FILM -> FILM_CATEGORY
 SELECT actor.first_name, actor.last_name, count(distinct film_category.category_id) AS num_categories
 FROM 
	actor 
		JOIN
	film_actor USING(actor_id)
		JOIN
	film USING (film_id)
		JOIN 
	film_category USING(film_id)
GROUP BY actor_id
HAVING num_categories >= 10
ORDER BY num_categories DESC;

-- Distribución -...
SELECT subconsulta.num_categories, count(subconsulta.first_name) as num_actores
 FROM 
	 (SELECT actor.first_name, actor.last_name, count(distinct film_category.category_id) AS num_categories
	 FROM 
		actor 
			JOIN
		film_actor USING(actor_id)
			JOIN
		film USING (film_id)
			JOIN 
		film_category USING(film_id)
	GROUP BY actor_id
	HAVING num_categories >= 10
	ORDER BY num_categories DESC 
    ) AS subconsulta
GROUP BY num_categories;

WITH subconsulta AS (SELECT actor.first_name, actor.last_name, count(distinct film_category.category_id) AS num_categories
	 FROM 
		actor 
			JOIN
		film_actor USING(actor_id)
			JOIN
		film USING (film_id)
			JOIN 
		film_category USING(film_id)
	GROUP BY actor_id
	HAVING num_categories >= 10
	ORDER BY num_categories DESC 
    )
SELECT subconsulta.num_categories, count(subconsulta.first_name) as num_actores
FROM subconsulta
GROUP BY num_categories;
    

-- 8) Tiendas con más stock disponible
-- 9) Películas que nunca han sido alquiladas
-- 10) Diez películas con mayor diferencia entre coste de reposición y tarifa de alquiler
-- 11) Películas con más de tres actores y duración menor a 90 minutos