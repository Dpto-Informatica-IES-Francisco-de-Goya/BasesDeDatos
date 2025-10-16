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


-- 4) Cliente que más ha gastado
-- 5) Ingreso promedio por alquiler en cada tienda
-- 6) Ventas totales por categoría ordenadas
-- 7) Actores con al menos diez películas de categorías distintas
-- 8) Tiendas con más stock disponible
-- 9) Películas que nunca han sido alquiladas
-- 10) Diez películas con mayor diferencia entre coste de reposición y tarifa de alquiler
-- 11) Películas con más de tres actores y duración menor a 90 minutos
