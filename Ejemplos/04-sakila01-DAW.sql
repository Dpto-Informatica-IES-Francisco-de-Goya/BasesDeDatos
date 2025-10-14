use sakila;

-- Curiosidad:
select * from tienda_online.clientes;

select * from actor limit 5;

-- 1) Cinco actores con más películas
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

-- 2) Películas que nunca han sido alquiladas
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

-- 3) País con más clientes

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
SELECT country AS Pais, count(customer_id) AS num_paises
FROM 
	customer
		JOIN 
	address USING(address_id)
		JOIN
	city USING(city_id)
		JOIN
	country USING(country_id)
GROUP BY country.country_id
ORDER BY num_paises DESC;
-- 4) Tres películas con mayores ingresos por alquiler. 
/* Pistas:
- Los ingresos están en payment.amount
- Saca id,nombre de cada película con los ingresos.
*/


-- 5) Ingreso promedio por alquiler en cada tienda


-- 6) Ventas totales por categoría ordenadas
-- 7) Actores con al menos diez películas de categorías distintas
-- 8) Tiendas con más stock disponible
-- 9) Diez películas con mayor diferencia entre coste de reposición y tarifa de alquiler
-- 10) Películas con más de tres actores y duración menor a 90 minutos
-- 11) Cliente que más ha gastado
