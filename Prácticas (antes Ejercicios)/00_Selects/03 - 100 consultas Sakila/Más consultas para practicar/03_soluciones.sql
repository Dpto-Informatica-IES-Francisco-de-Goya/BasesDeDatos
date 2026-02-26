USE sakila;

-- 1) Películas y categoría: columnas -> film_id AS film_id, title AS titulo, category.name AS categoria 
SELECT ' 1) Películas y categoría: columnas -> film_id AS film_id, title AS titulo, category.name AS categoria ' AS '';
SELECT f.film_id AS film_id, f.title AS titulo, c.name AS categoria
FROM film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id
JOIN category AS c ON c.category_id = fc.category_id;

-- 2) Reparto por película: columnas -> title AS titulo, first_name AS nombre_actor, last_name AS apellido_actor 
SELECT ' 2) Reparto por película: columnas -> title AS titulo, first_name AS nombre_actor, last_name AS apellido_actor ' AS '';
SELECT f.title AS titulo, a.first_name AS nombre_actor, a.last_name AS apellido_actor
FROM film AS f
JOIN film_actor AS fa ON fa.film_id = f.film_id
JOIN actor AS a ON a.actor_id = fa.actor_id;

-- 3) Alquileres con título: columnas -> rental_id AS id_alquiler, rental_date AS fecha_alquiler, title AS titulo 
SELECT ' 3) Alquileres con título: columnas -> rental_id AS id_alquiler, rental_date AS fecha_alquiler, title AS titulo ' AS '';
SELECT r.rental_id AS id_alquiler, r.rental_date AS fecha_alquiler, f.title AS titulo
FROM rental AS r
JOIN inventory AS i ON i.inventory_id = r.inventory_id
JOIN film AS f ON f.film_id = i.film_id;

-- 4) Cobros por cliente (importe total): columnas -> customer_id AS id_cliente, cliente, total_pagado 
SELECT ' 4) Cobros por cliente (importe total): columnas -> customer_id AS id_cliente, cliente, total_pagado ' AS '';
SELECT cu.customer_id AS id_cliente,
       CONCAT(cu.first_name,' ',cu.last_name) AS cliente,
       SUM(p.amount) AS total_pagado
FROM payment AS p
JOIN customer AS cu ON cu.customer_id = p.customer_id
GROUP BY cu.customer_id, cliente;

-- 5) Top 10 actores por nº de películas: columnas -> id_actor, actor, num_peliculas 
SELECT ' 5) Top 10 actores por nº de películas: columnas -> id_actor, actor, num_peliculas ' AS '';
SELECT a.actor_id AS id_actor,
       CONCAT(a.first_name,' ',a.last_name) AS actor,
       COUNT(*) AS num_peliculas
FROM film_actor AS fa
JOIN actor AS a ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, actor
ORDER BY num_peliculas DESC
LIMIT 10;

-- 6) Películas >=120 min y su categoría: columnas -> titulo, minutos, categoria 
SELECT ' 6) Películas >=120 min y su categoría: columnas -> titulo, minutos, categoria ' AS '';
SELECT f.title AS titulo, f.length AS minutos, c.name AS categoria
FROM film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id
JOIN category AS c ON c.category_id = fc.category_id
WHERE f.length >= 120;

-- 7) Cobros por país: columnas -> pais, total_pais 
SELECT ' 7) Cobros por país: columnas -> pais, total_pais ' AS '';
SELECT co.country AS pais, SUM(p.amount) AS total_pais
FROM payment AS p
JOIN customer AS cu ON cu.customer_id = p.customer_id
JOIN address AS a ON a.address_id = cu.address_id
JOIN city AS ci ON ci.city_id = a.city_id
JOIN country AS co ON co.country_id = ci.country_id
GROUP BY co.country
ORDER BY total_pais DESC;

-- 8) Rotación por tienda (alquileres): columnas -> tienda, alquileres 
SELECT ' 8) Rotación por tienda (alquileres): columnas -> tienda, alquileres ' AS '';
SELECT s.store_id AS tienda, COUNT(*) AS alquileres
FROM rental AS r
JOIN inventory AS i ON i.inventory_id = r.inventory_id
JOIN store AS s ON s.store_id = i.store_id
GROUP BY s.store_id
ORDER BY alquileres DESC;

-- 9) Ticket medio por empleado: columnas -> id_staff, staff, ticket_medio 
SELECT ' 9) Ticket medio por empleado: columnas -> id_staff, staff, ticket_medio ' AS '';
SELECT st.staff_id AS id_staff,
       CONCAT(st.first_name,' ',st.last_name) AS staff,
       AVG(p.amount) AS ticket_medio
FROM payment AS p
JOIN staff AS st ON st.staff_id = p.staff_id
GROUP BY st.staff_id, staff
ORDER BY ticket_medio DESC;

-- 10) Películas por idioma y rating: columnas -> idioma, clasificacion, num_peliculas 
SELECT ' 10) Películas por idioma y rating: columnas -> idioma, clasificacion, num_peliculas ' AS '';
SELECT l.name AS idioma, f.rating AS clasificacion, COUNT(*) AS num_peliculas
FROM film AS f
JOIN language AS l ON l.language_id = f.language_id
GROUP BY l.name, f.rating
ORDER BY l.name, f.rating;

-- 11) Duración media por categoría: columnas -> categoria, duracion_media 
SELECT ' 11) Duración media por categoría: columnas -> categoria, duracion_media ' AS '';
SELECT c.name AS categoria, ROUND(AVG(f.length),2) AS duracion_media
FROM film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id
JOIN category AS c ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY duracion_media DESC;

-- 12) Top 5 países por nº de clientes: columnas -> pais, clientes 
SELECT ' 12) Top 5 países por nº de clientes: columnas -> pais, clientes ' AS '';
SELECT co.country AS pais, COUNT(*) AS clientes
FROM customer AS cu
JOIN address AS a ON a.address_id = cu.address_id
JOIN city AS ci ON ci.city_id = a.city_id
JOIN country AS co ON co.country_id = ci.country_id
GROUP BY co.country
ORDER BY clientes DESC
LIMIT 5;

-- 13) Importe total cobrado por tienda: columnas -> tienda, total_tienda 
SELECT ' 13) Importe total cobrado por tienda: columnas -> tienda, total_tienda ' AS '';
SELECT s.store_id AS tienda, SUM(p.amount) AS total_tienda
FROM payment AS p
JOIN staff AS st ON st.staff_id = p.staff_id
JOIN store AS s ON s.store_id = st.store_id
GROUP BY s.store_id
ORDER BY total_tienda DESC;

-- 14) Nº de copias por película y tienda: columnas -> tienda, titulo, copias 
SELECT ' 14) Nº de copias por película y tienda: columnas -> tienda, titulo, copias ' AS '';
SELECT s.store_id AS tienda, f.title AS titulo, COUNT(*) AS copias
FROM inventory AS i
JOIN store AS s ON s.store_id = i.store_id
JOIN film AS f ON f.film_id = i.film_id
GROUP BY s.store_id, f.title
ORDER BY tienda, copias DESC;

-- 15) Actores con >= 20 películas: columnas -> actor, num_peliculas 
SELECT ' 15) Actores con >= 20 películas: columnas -> actor, num_peliculas ' AS '';
SELECT CONCAT(a.first_name,' ',a.last_name) AS actor, COUNT(*) AS num_peliculas
FROM film_actor AS fa
JOIN actor AS a ON a.actor_id = fa.actor_id
GROUP BY actor
HAVING COUNT(*) >= 20
ORDER BY num_peliculas DESC;

-- 16) Clientes inactivos y país: columnas -> cliente, pais 
SELECT ' 16) Clientes inactivos y país: columnas -> cliente, pais ' AS '';
SELECT CONCAT(cu.first_name,' ',cu.last_name) AS cliente, co.country AS pais
FROM customer AS cu
JOIN address AS a ON a.address_id = cu.address_id
JOIN city AS ci ON ci.city_id = a.city_id
JOIN country AS co ON co.country_id = ci.country_id
WHERE cu.active = 0
ORDER BY pais, cliente;

-- 17) Alquileres por año-mes y tienda: columnas -> anio, mes, tienda, alquileres 
SELECT ' 17) Alquileres por año-mes y tienda: columnas -> anio, mes, tienda, alquileres ' AS '';
SELECT YEAR(r.rental_date) AS anio, MONTH(r.rental_date) AS mes, s.store_id AS tienda, COUNT(*) AS alquileres
FROM rental AS r
JOIN inventory AS i ON i.inventory_id = r.inventory_id
JOIN store AS s ON s.store_id = i.store_id
GROUP BY YEAR(r.rental_date), MONTH(r.rental_date), s.store_id
ORDER BY anio, mes, tienda;

-- 18) Ticket medio por país: columnas -> pais, ticket_medio 
SELECT ' 18) Ticket medio por país: columnas -> pais, ticket_medio ' AS '';
SELECT co.country AS pais, ROUND(AVG(p.amount),2) AS ticket_medio
FROM payment AS p
JOIN customer AS cu ON cu.customer_id = p.customer_id
JOIN address AS a ON a.address_id = cu.address_id
JOIN city AS ci ON ci.city_id = a.city_id
JOIN country AS co ON co.country_id = ci.country_id
GROUP BY co.country
ORDER BY ticket_medio DESC;

-- 19) Películas con > 3 actores: columnas -> titulo, num_actores 
SELECT ' 19) Películas con > 3 actores: columnas -> titulo, num_actores ' AS '';
SELECT f.title AS titulo, COUNT(*) AS num_actores
FROM film AS f
JOIN film_actor AS fa ON fa.film_id = f.film_id
GROUP BY f.film_id, f.title
HAVING COUNT(*) > 3
ORDER BY num_actores DESC, titulo;

-- 20) Importe total por categoría 
SELECT ' 20) Importe total por categoría ' AS '';
SELECT c.name AS categoria, SUM(p.amount) AS total_categoria
FROM payment AS p
JOIN rental AS r ON r.rental_id = p.rental_id
JOIN inventory AS i ON i.inventory_id = r.inventory_id
JOIN film AS f ON f.film_id = i.film_id
JOIN film_category AS fc ON fc.film_id = f.film_id
JOIN category AS c ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY total_categoria DESC;
