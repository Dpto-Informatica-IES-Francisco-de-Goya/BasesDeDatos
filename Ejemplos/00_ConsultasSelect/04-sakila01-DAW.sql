use sakila;

-- Curiosidad:
select * from tienda_online.clientes;

select * from actor limit 5;
-------------------------------------------------------------------------------
-- 1) Cinco actores con más películas
-------------------------------------------------------------------------------

SELECT 
    actor.first_name AS nombre,
    actor.last_name AS apellido,
    COUNT(film_id) AS num_peliculas
FROM
    actor
        JOIN
    film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY film_actor.actor_id
ORDER BY COUNT(film_id) DESC
LIMIT 5;

SELECT 
    ac.first_name AS nombre,
    ac.last_name AS apellido,
    COUNT(film_id) AS num_peliculas
FROM
    actor ac
        JOIN
    film_actor fa ON ac.actor_id = fa.actor_id
GROUP BY fa.actor_id
ORDER BY COUNT(fa.film_id) DESC
LIMIT 5;

-- OJO: first_name y last_name no están ni agregadas ni agrupadas. ¿Por qué funciona? 
-- Víctor escribió cosas en la pizarra... Qué bien que me enteré perfectamente a la primera.


-------------------------------------------------------------------------------
-- 2) Películas que nunca han sido alquiladas
-------------------------------------------------------------------------------
-- CONSULTAS PREVIAS PARA SACAR INFORMACIÓN
SELECT * FROM rental limit 5;
SELECT * FROM inventory limit 5;

SELECT * FROM
	rental r
		JOIN
	inventory i ON r.inventory_id = i.inventory_id
WHERE r.rental_date is null;

SELECT * FROM
	rental r
		JOIN
	inventory i ON r.inventory_id = i.inventory_id;
    
/* OPCIONES:
1) rental_date null? No me lo soluciona
2) ¿Existe una tabla con la cantidad de veces que se ha alquilado una película? No existe
3) Comparar ids de rental y de inventario. Para ver si hay alguna en inventario que no esté alquilada.
*/

-- Cuántos inventory_id diferentes hay en cada tabla
SELECT COUNT(distinct inventory_id) FROM rental;
SELECT COUNT(distinct inventory_id) FROM inventory;

SELECT distinct inventory_id FROM rental ORDER BY inventory_id ASC;
SELECT distinct inventory_id FROM inventory ORDER BY inventory_id ASC;


-- SOLUCIÓN

-- Para más adelante, cuando hayas interiorizado los tipos de JOINs con la guía que te publicaré.

-- CONCLUSION: Existen tipos de JOINS según quiera rellenar con NULL o ignorar las filas no relacionadas.


-------------------------------------------------------------------------------
-- 3) País con más clientes
-------------------------------------------------------------------------------
SELECT country AS Pais, count(customer_id) AS num_paises
FROM 
	customer c
		JOIN 
	address a ON c.address_id = a.address_id
		JOIN
	city ON a.city_id = city.city_id
		JOIN
	country ON country.country_id = city.country_id
GROUP BY country.country_id
ORDER BY num_paises DESC;


-- Esto solo funciona cuando el nombre de la columna compartida es EXACTAMENTE igual.
SELECT 
    country AS Pais, COUNT(customer_id) AS num_paises
FROM
    customer
        JOIN
    address USING (address_id)
        JOIN
    city USING (city_id)
        JOIN
    country USING (country_id)
GROUP BY country.country_id
ORDER BY num_paises DESC;

-------------------------------------------------------------------------------
-- 4) Tres películas con mayores ingresos por alquiler. 
-------------------------------------------------------------------------------
/* Pistas:
- Los ingresos están en payment.amount
- Saca id,nombre de cada película con los ingresos.
*/


-- 5) Ingreso promedio por alquiler en cada tienda

-- Cotilleando posibles caminos, vemos que store y staff tienen 2 relaciones. Manager y store_id.
-- ¡Qué interesante! Vamos a comparar a ver qué sale.

SELECT *
	-- store.store_id AS tienda,
	-- AVG(payment.amount) AS ingresio_promedio_por_alquiler
FROM 
	store
		JOIN
	staff USING(store_id);

SELECT 
	*
FROM 
	store
		JOIN
	staff ON store.manager_staff_id = staff.staff_id;

-- Uy, ha salido lo mismo de los 2 joins ¿Por qué? Vamos a ver staff qué tiene
select * from staff;
-- Aaaanda... es que staff solo tiene 2 trabajadores. Vaya base de datos de pacotilla... 
-- Aún saliendo el mismo resultado, hay una conexión que tiene más sentido para esta consulta 5:
-- store_id porque ...
-- Por otro lado, hacer el join utilizando manager_staff_id permitiría resolver consultas como
-- "Obtén la cantidad de ingresos de alquileres de cada jefe de tienda". Ahí sí hay que utilizar manager.
-- Ojo ojito: que no solo será necesario encontrar las tablas necesarias para el join, sino también
-- saber qué columnas son las que hay que utilizar.



-------------------------------------------------------------------------------
/* -- 5) Ingreso promedio por alquiler en cada tienda
-------------------------------------------------------------------------------


OPCIONES:
NO 1) STORE -> CUSTOMER -> PAYMENT (Solución de Michael)
NO 2) STORE -> CUSTOMER -> RENTAL -> PAYMENT (Solución de Nicole)
NO 3) STORE -> STAFF USING(STORE_ID) -> PAYMENT (Solución de Leandro)
4) PAYMENT -> RENTAL -> INVENTORY -> STORE (Solución de Víctor)*/
    
-- STORE -> CUSTOMER -> PAYMENT (Solución de Michael)
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

-- STORE -> CUSTOMER -> RENTAL -> PAYMENT (Solución de Nicole)
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

-- STORE -> STAFF USING(STORE_ID) -> PAYMENT
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

-- PAYMENT -> RENTAL -> INVENTORY -> STORE

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

/*
CONCLUSIONES:
- 
-
- Sakila que parece muy compleja, en realidad, es normalita. 
*/

-------------------------------------------------------------------------------
-- 6) Ventas totales por categoría ordenadas
-------------------------------------------------------------------------------

-- PAYMENT -> RENTAL -> INVENTORY -> FILM -> FILM_CATEGORY -> CATEGORY
SELECT category.name,sum(payment.amount)
FROM payment
		JOIN
	rental using(rental_id)
		JOIN
	inventory using(inventory_id)
		JOIN
	film USING(film_id)
		JOIN
	film_category USING(film_id)
		JOIN
	category USING(category_id)
GROUP BY category.category_id;
 -- GROUP BY category.name;

-------------------------------------------------------------------------------
-- 7) Actores con al menos diez películas de categorías distintas
-------------------------------------------------------------------------------

-- ACTOR -> FILM_ACTOR -> FILM -> FILM_CATEGORY ¿-> CATEGORY?
SELECT 
    a.actor_id,
    CONCAT(a.first_name, ' ', a.last_name) AS nombre_completo,
    COUNT( DISTINCT film_category.category_id) AS num_categorias_distintas
FROM
    actor a
        JOIN
    film_actor USING (actor_id)
        JOIN
    film USING (film_id)
        JOIN
    film_category USING (film_id)
GROUP BY a.actor_id
HAVING num_categorias_distintas >= 10
ORDER BY num_categorias_distintas DESC;

-- Vamos a hacer esta consulta con un WHERE en lugar de con un having.
-- Esto es un adelanto de una tarea posterior.
SELECT 
    a.actor_id,
    CONCAT(a.first_name, ' ', a.last_name) AS nombre_completo,
    COUNT( DISTINCT film_category.category_id) AS num_categorias_distintas
FROM
    actor a
        JOIN
    film_actor USING (actor_id)
        JOIN
    film USING (film_id)
        JOIN
    film_category USING (film_id)
GROUP BY a.actor_id;

-- Distribución de número de actores por número de categorías distintas en las que trabajan.
SELECT subconsulta.num_categorias_distintas, count(actor_id) AS num_actores
FROM (
		SELECT 
			a.actor_id,
			CONCAT(a.first_name, ' ', a.last_name) AS nombre_completo,
			COUNT( DISTINCT film_category.category_id) AS num_categorias_distintas
		FROM
			actor a
				JOIN
			film_actor USING (actor_id)
				JOIN
			film USING (film_id)
				JOIN
			film_category USING (film_id)
		GROUP BY a.actor_id
	) AS subconsulta

WHERE subconsulta.num_categorias_distintas >= 10
GROUP BY subconsulta.num_categorias_distintas
ORDER BY subconsulta.num_categorias_distintas DESC;



-- Solo para mostrar la necesidad del distinct
SELECT 
    a.actor_id,
    CONCAT(a.first_name, ' ', a.last_name) AS nombre_completo,
    film_category.category_id
FROM
    actor a
        JOIN
    film_actor USING (actor_id)
        JOIN
    film USING (film_id)
        JOIN
    film_category USING (film_id)
order by nombre_completo;

-------------------------------------------------------------------------------
-- 8) Tiendas con más stock disponible. ¿Qué tiendas tienen más stock de películas actualmente disponibles para alquilar?
-------------------------------------------------------------------------------
SELECT 
    inventory_id, COUNT(*)
FROM
    rental
WHERE
    return_date IS NOT NULL
GROUP BY inventory_id;

SELECT 
    *
FROM
    rental
WHERE
    inventory_id = 2047;
    
SELECT 
    *
FROM
    rental
WHERE
    return_date IS NULL
    AND rental_id = 11496;
    
SELECT 
    *
FROM
    rental
WHERE
    return_date IS NULL; 

-- Listado de inventarios disponibles.
SELECT * 
FROM 
	inventory
		JOIN
	store USING(store_id)
WHERE inventory_in_stock(inventory_id);
    
    
-- SOLUCIÓN:
SELECT store_id, COUNT(inventory_id) AS num_stock
FROM 
	inventory
		JOIN
	store USING(store_id)
WHERE inventory_in_stock(inventory_id)
GROUP BY store_id;
    
-- CONCLUSIÓN:
-- Las sopas se comen con cuchara, no con tenedor.

-------------------------------------------------------------------------------
-- 10 películas con mayor diferencia entre coste de reposición y tarifa de alquiler.
-------------------------------------------------------------------------------
-- FILM (coste de reposición, rental_rate)
SELECT 
    *
FROM
    film
LIMIT 15;


SELECT f.film_id, f.title, (f.replacement_cost - f.rental_rate) AS cost_diff
FROM film f
ORDER BY cost_diff DESC
LIMIT 10;


-------------------------------------------------------------------------------
-- 10) Películas con más de tres actores y duración menor a 90 minutos (MUY BONITA)
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- 11) Cliente que más ha gastado
-------------------------------------------------------------------------------

