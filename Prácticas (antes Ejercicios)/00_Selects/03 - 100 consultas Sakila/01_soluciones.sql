USE sakila;

-- ==============================================
-- SECCIÓN A) 30 CONSULTAS CON JOIN DE 2 TABLAS
-- ==============================================

-- 1:  Para cada actor, muestra el número total de películas en las que aparece; es decir, cuenta cuántas filas de film_actor corresponden a cada actor.
SELECT "1:  Para cada actor, muestra el número total de películas en las que aparece; es decir, cuenta cuántas filas de film_actor corresponden a cada actor." AS '';
SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS total_films
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

-- 2:  Lista solo los actores que participan en 20 o más películas (umbral alto) con su conteo.
SELECT "2:  Lista solo los actores que participan en 20 o más películas (umbral alto) con su conteo." AS '';
SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS films_20plus
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(fa.film_id) >= 20;

-- 3:  Para cada idioma, indica cuántas películas están catalogadas en ese idioma.
SELECT "3:  Para cada idioma, indica cuántas películas están catalogadas en ese idioma." AS '';
SELECT l.language_id, l.name AS language_name, COUNT(f.film_id) AS films_in_language
FROM language l
JOIN film f ON f.language_id = l.language_id
GROUP BY l.language_id, l.name;

-- 4:  Muestra el promedio de duración (length) de las películas por idioma y filtra aquellos idiomas con duración media estrictamente mayor a 110 minutos.
SELECT "4:  Muestra el promedio de duración (length) de las películas por idioma y filtra aquellos idiomas con duración media estrictamente mayor a 110 minutos." AS '';
SELECT l.language_id, l.name AS language_name, AVG(f.length) AS avg_length
FROM language l
JOIN film f ON f.language_id = l.language_id
GROUP BY l.language_id, l.name
HAVING AVG(f.length) > 110;

-- 5:  Para cada película, muestra cuántas copias hay en el inventario.
SELECT "5:  Para cada película, muestra cuántas copias hay en el inventario." AS '';
SELECT f.film_id, f.title, COUNT(i.inventory_id) AS copies
FROM film f
JOIN inventory i ON i.film_id = f.film_id
GROUP BY f.film_id, f.title;

-- 6:  Lista solo las películas que tienen al menos 5 copias en inventario.
SELECT "6:  Lista solo las películas que tienen al menos 5 copias en inventario." AS '';
SELECT f.film_id, f.title, COUNT(i.inventory_id) AS copies_5plus
FROM film f
JOIN inventory i ON i.film_id = f.film_id
GROUP BY f.film_id, f.title
HAVING COUNT(i.inventory_id) >= 5;

-- 7:  Para cada artículo de inventario, cuenta cuántos alquileres se han realizado.
SELECT "7:  Para cada artículo de inventario, cuenta cuántos alquileres se han realizado." AS '';
SELECT i.inventory_id, COUNT(r.rental_id) AS rentals
FROM inventory i
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY i.inventory_id;

-- 8:  Para cada cliente, muestra cuántos alquileres ha realizado en total.
SELECT "8:  Para cada cliente, muestra cuántos alquileres ha realizado en total." AS '';
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_rentals
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 9:  Lista los clientes con 30 o más alquileres acumulados.
SELECT "9:  Lista los clientes con 30 o más alquileres acumulados." AS '';
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS rentals_30plus
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(r.rental_id) >= 30;

-- 10:  Para cada cliente, muestra el total de pagos (suma en euros/dólares) que ha realizado.
SELECT "10:  Para cada cliente, muestra el total de pagos (suma en euros/dólares) que ha realizado." AS '';
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_amount
FROM customer c
JOIN payment p ON p.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 11:  Muestra los clientes cuyo importe total pagado es al menos 200.
SELECT "11:  Muestra los clientes cuyo importe total pagado es al menos 200." AS '';
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_amount
FROM customer c
JOIN payment p ON p.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(p.amount) >= 200;

-- 12:  Para cada empleado (staff), muestra el número de pagos que ha procesado.
SELECT "12:  Para cada empleado (staff), muestra el número de pagos que ha procesado." AS '';
SELECT s.staff_id, s.first_name, s.last_name, COUNT(p.payment_id) AS payments_processed
FROM staff s
JOIN payment p ON p.staff_id = s.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name;

-- 13:  Para cada empleado, muestra el importe total procesado.
SELECT "13:  Para cada empleado, muestra el importe total procesado." AS '';
SELECT s.staff_id, s.first_name, s.last_name, SUM(p.amount) AS total_processed
FROM staff s
JOIN payment p ON p.staff_id = s.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name;

-- 14:  Para cada tienda, cuenta cuántos artículos de inventario tiene.
SELECT "14:  Para cada tienda, cuenta cuántos artículos de inventario tiene." AS '';
SELECT st.store_id, COUNT(i.inventory_id) AS total_inventory_items
FROM store st
JOIN inventory i ON i.store_id = st.store_id
GROUP BY st.store_id;

-- 15:  Para cada tienda, cuenta cuántos clientes tiene asignados.
SELECT "15:  Para cada tienda, cuenta cuántos clientes tiene asignados." AS '';
SELECT st.store_id, COUNT(c.customer_id) AS customers_in_store
FROM store st
JOIN customer c ON c.store_id = st.store_id
GROUP BY st.store_id;

-- 16:  Para cada tienda, cuenta cuántos empleados (staff) tiene asignados.
SELECT "16:  Para cada tienda, cuenta cuántos empleados (staff) tiene asignados." AS '';
SELECT st.store_id, COUNT(s.staff_id) AS staff_in_store
FROM store st
JOIN staff s ON s.store_id = st.store_id
GROUP BY st.store_id;

-- 17:  Para cada dirección (address), cuenta cuántas tiendas hay ubicadas ahí (debería ser 0/1 en datos estándar).
SELECT "17:  Para cada dirección (address), cuenta cuántas tiendas hay ubicadas ahí (debería ser 0/1 en datos estándar)." AS '';
SELECT a.address_id, a.address, COUNT(st.store_id) AS stores_here
FROM address a
JOIN store st ON st.address_id = a.address_id
GROUP BY a.address_id, a.address;

-- 18:  Para cada dirección, cuenta cuántos empleados residen en esa dirección.
SELECT "18:  Para cada dirección, cuenta cuántos empleados residen en esa dirección." AS '';
SELECT a.address_id, a.address, COUNT(s.staff_id) AS staff_here
FROM address a
JOIN staff s ON s.address_id = a.address_id
GROUP BY a.address_id, a.address;

-- 19:  Para cada dirección, cuenta cuántos clientes residen ahí.
SELECT "19:  Para cada dirección, cuenta cuántos clientes residen ahí." AS '';
SELECT a.address_id, a.address, COUNT(c.customer_id) AS customers_here
FROM address a
JOIN customer c ON c.address_id = a.address_id
GROUP BY a.address_id, a.address;

-- 20:  Para cada ciudad, cuenta cuántas direcciones hay registradas.
SELECT "20:  Para cada ciudad, cuenta cuántas direcciones hay registradas." AS '';
SELECT ci.city_id, ci.city, COUNT(a.address_id) AS addresses_in_city
FROM city ci
JOIN address a ON a.city_id = ci.city_id
GROUP BY ci.city_id, ci.city;

-- 21:  Para cada país, cuenta cuántas ciudades existen.
SELECT "21:  Para cada país, cuenta cuántas ciudades existen." AS '';
SELECT co.country_id, co.country, COUNT(ci.city_id) AS cities_in_country
FROM country co
JOIN city ci ON ci.country_id = co.country_id
GROUP BY co.country_id, co.country;

-- 22:  Para cada idioma, calcula la duración media de películas y muestra solo los idiomas con media entre 90 y 120 inclusive.
SELECT "22:  Para cada idioma, calcula la duración media de películas y muestra solo los idiomas con media entre 90 y 120 inclusive." AS '';
SELECT l.language_id, l.name AS language_name, AVG(f.length) AS avg_length
FROM language l
JOIN film f ON f.language_id = l.language_id
GROUP BY l.language_id, l.name
HAVING AVG(f.length) BETWEEN 90 AND 120;

-- 23:  Para cada película, cuenta el número de alquileres que se han hecho de cualquiera de sus copias (usando inventario).
SELECT "23:  Para cada película, cuenta el número de alquileres que se han hecho de cualquiera de sus copias (usando inventario)." AS '';
SELECT f.film_id, f.title, COUNT(r.rental_id) AS total_rentals
FROM film f
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY f.film_id, f.title;

-- 24:  Para cada cliente, cuenta cuántos pagos ha realizado en 2005 (usando el año de payment_date).
SELECT "24:  Para cada cliente, cuenta cuántos pagos ha realizado en 2005 (usando el año de payment_date)." AS '';
SELECT c.customer_id, c.first_name, c.last_name, COUNT(p.payment_id) AS payments_2005
FROM customer c
JOIN payment p ON p.customer_id = c.customer_id
WHERE YEAR(p.payment_date) = 2005
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 25:  Para cada película, muestra el promedio de tarifa de alquiler (rental_rate) de las copias existentes (es un promedio redundante pero válido).
SELECT "25:  Para cada película, muestra el promedio de tarifa de alquiler (rental_rate) de las copias existentes (es un promedio redundante pero válido)." AS '';
SELECT f.film_id, f.title, AVG(f.rental_rate) AS avg_rate
FROM film f
JOIN inventory i ON i.film_id = f.film_id
GROUP BY f.film_id, f.title;

-- 26:  Para cada actor, muestra la duración media (length) de sus películas.
SELECT "26:  Para cada actor, muestra la duración media (length) de sus películas." AS '';
SELECT a.actor_id, a.first_name, a.last_name, AVG(f.length) AS avg_length_by_actor
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film f ON f.film_id = fa.film_id
GROUP BY a.actor_id, a.first_name, a.last_name;

-- 27:  Para cada ciudad, cuenta cuántos clientes hay (usando la relación cliente->address->city requiere 3 tablas; aquí contamos direcciones por ciudad).
SELECT "27:  Para cada ciudad, cuenta cuántos clientes hay (usando la relación cliente->address->city requiere 3 tablas; aquí contamos direcciones por ciudad)." AS '';
SELECT ci.city_id, ci.city, COUNT(a.address_id) AS total_addresses
FROM city ci
JOIN address a ON a.city_id = ci.city_id
GROUP BY ci.city_id, ci.city;

-- 28:  Para cada película, cuenta cuántos actores tiene asociados.
SELECT "28:  Para cada película, cuenta cuántos actores tiene asociados." AS '';
SELECT f.film_id, f.title, COUNT(fa.actor_id) AS actors_in_film
FROM film f
JOIN film_actor fa ON fa.film_id = f.film_id
GROUP BY f.film_id, f.title;

-- 29:  Para cada categoría (por id), cuenta cuántas películas pertenecen a ella (sin nombre de categoría para mantener 2 tablas).
SELECT "29:  Para cada categoría (por id), cuenta cuántas películas pertenecen a ella (sin nombre de categoría para mantener 2 tablas)." AS '';
SELECT fc.category_id, COUNT(fc.film_id) AS films_in_category
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id
GROUP BY fc.category_id;

-- 30:  Para cada tienda, cuenta cuántos alquileres totales se originan en su inventario.
SELECT "30:  Para cada tienda, cuenta cuántos alquileres totales se originan en su inventario." AS '';
SELECT st.store_id, COUNT(r.rental_id) AS rentals_by_store_inventory
FROM store st
JOIN inventory i ON i.store_id = st.store_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY st.store_id;

-- ==============================================
-- SECCIÓN B) 30 CONSULTAS CON JOIN DE 3 TABLAS
-- ==============================================

-- 31:  Para cada actor, cuenta cuántas películas tiene y muestra solo los que superan 15 películas.
SELECT "31:  Para cada actor, cuenta cuántas películas tiene y muestra solo los que superan 15 películas." AS '';
SELECT a.actor_id, a.first_name, a.last_name, COUNT(f.film_id) AS films_by_actor
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film f ON f.film_id = fa.film_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(f.film_id) > 15;

-- 32:  Para cada categoría (por nombre), cuenta cuántas películas hay en esa categoría.
SELECT "32:  Para cada categoría (por nombre), cuenta cuántas películas hay en esa categoría." AS '';
SELECT c.category_id, c.name AS category_name, COUNT(f.film_id) AS films_in_category
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
GROUP BY c.category_id, c.name;

-- 33:  Para cada película, cuenta cuántos alquileres se han hecho de sus copias.
SELECT "33:  Para cada película, cuenta cuántos alquileres se han hecho de sus copias." AS '';
SELECT f.film_id, f.title, COUNT(r.rental_id) AS rentals_of_film
FROM film f
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY f.film_id, f.title;

-- 34:  Para cada cliente, suma el importe pagado en 2005 y filtra clientes con total >= 150.
SELECT "34:  Para cada cliente, suma el importe pagado en 2005 y filtra clientes con total >= 150." AS '';
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_2005
FROM customer c
JOIN payment p ON p.customer_id = c.customer_id
JOIN rental r ON r.rental_id = p.rental_id
WHERE YEAR(p.payment_date) = 2005
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(p.amount) >= 150;

-- 35:  Para cada tienda, suma el importe cobrado por todos sus empleados.
SELECT "35:  Para cada tienda, suma el importe cobrado por todos sus empleados." AS '';
SELECT st.store_id, SUM(p.amount) AS revenue_by_store_staff
FROM store st
JOIN staff s ON s.store_id = st.store_id
JOIN payment p ON p.staff_id = s.staff_id
GROUP BY st.store_id;

-- 36:  Para cada ciudad, cuenta cuántos empleados residen ahí (staff -> address -> city).
SELECT "36:  Para cada ciudad, cuenta cuántos empleados residen ahí (staff -> address -> city)." AS '';
SELECT ci.city_id, ci.city, COUNT(s.staff_id) AS staff_in_city
FROM city ci
JOIN address a ON a.city_id = ci.city_id
JOIN staff s ON s.address_id = a.address_id
GROUP BY ci.city_id, ci.city;

-- 37:  Para cada ciudad, cuenta cuántas tiendas existen (store -> address -> city).
SELECT "37:  Para cada ciudad, cuenta cuántas tiendas existen (store -> address -> city)." AS '';
SELECT ci.city_id, ci.city, COUNT(st.store_id) AS stores_in_city
FROM city ci
JOIN address a ON a.city_id = ci.city_id
JOIN store st ON st.address_id = a.address_id
GROUP BY ci.city_id, ci.city;

-- 38:  Para cada actor, calcula la duración media de sus películas del año 2006.
SELECT "38:  Para cada actor, calcula la duración media de sus películas del año 2006." AS '';
SELECT a.actor_id, a.first_name, a.last_name, AVG(f.length) AS avg_len_2006
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film f ON f.film_id = fa.film_id
WHERE f.release_year = 2006
GROUP BY a.actor_id, a.first_name, a.last_name;

-- 39:  Para cada categoría, calcula la duración media y muestra solo las que superan 120.
SELECT "39:  Para cada categoría, calcula la duración media y muestra solo las que superan 120." AS '';
SELECT c.category_id, c.name AS category_name, AVG(f.length) AS avg_len
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
GROUP BY c.category_id, c.name
HAVING AVG(f.length) > 120;

-- 40:  Para cada idioma, suma las tarifas de alquiler (rental_rate) de todas sus películas.
SELECT "40:  Para cada idioma, suma las tarifas de alquiler (rental_rate) de todas sus películas." AS '';
SELECT l.language_id, l.name AS language_name, SUM(f.rental_rate) AS sum_rates
FROM language l
JOIN film f ON f.language_id = l.language_id
JOIN inventory i ON i.film_id = f.film_id
GROUP BY l.language_id, l.name;

-- 41:  Para cada cliente, cuenta cuántos alquileres realizó en fines de semana (SÁB-DO) usando DAYOFWEEK (1=Domingo).
SELECT "41:  Para cada cliente, cuenta cuántos alquileres realizó en fines de semana (SÁB-DO) usando DAYOFWEEK (1=Domingo)." AS '';
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS weekend_rentals
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
JOIN inventory i ON i.inventory_id = r.inventory_id
WHERE DAYOFWEEK(r.rental_date) IN (1,7)
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 42:  Para cada actor, muestra el total de títulos distintos en los que participa (equivale a COUNT DISTINCT, sin subconsulta).
SELECT "42:  Para cada actor, muestra el total de títulos distintos en los que participa (equivale a COUNT DISTINCT, sin subconsulta)." AS '';
SELECT a.actor_id, a.first_name, a.last_name, COUNT(DISTINCT f.film_id) AS distinct_films
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film f ON f.film_id = fa.film_id
GROUP BY a.actor_id, a.first_name, a.last_name;

-- 43:  Para cada ciudad, cuenta cuántos clientes residen ahí (customer -> address -> city).
SELECT "43:  Para cada ciudad, cuenta cuántos clientes residen ahí (customer -> address -> city)." AS '';
SELECT ci.city_id, ci.city, COUNT(c.customer_id) AS customers_in_city
FROM city ci
JOIN address a ON a.city_id = ci.city_id
JOIN customer c ON c.address_id = a.address_id
GROUP BY ci.city_id, ci.city;

-- 44:  Para cada categoría, muestra cuántos actores distintos participan en películas de esa categoría.
SELECT "44:  Para cada categoría, muestra cuántos actores distintos participan en películas de esa categoría." AS '';
SELECT c.category_id, c.name AS category_name, COUNT(DISTINCT fa.actor_id) AS actors_in_category
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film_actor fa ON fa.film_id = fc.film_id
GROUP BY c.category_id, c.name;

-- 45:  Para cada tienda, cuenta cuántas copias totales (inventario) tiene de películas en 2006.
SELECT "45:  Para cada tienda, cuenta cuántas copias totales (inventario) tiene de películas en 2006." AS '';
SELECT st.store_id, COUNT(i.inventory_id) AS copies_2006
FROM store st
JOIN inventory i ON i.store_id = st.store_id
JOIN film f ON f.film_id = i.film_id
WHERE f.release_year = 2006
GROUP BY st.store_id;

-- 46:  Para cada cliente, suma el total pagado por alquileres cuyo empleado pertenece a la tienda 1.
SELECT "46:  Para cada cliente, suma el total pagado por alquileres cuyo empleado pertenece a la tienda 1." AS '';
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_amount
FROM customer c
JOIN payment p ON p.customer_id = c.customer_id
JOIN staff s ON s.staff_id = p.staff_id
WHERE s.store_id = 1
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 47:  Para cada película, cuenta cuántos actores tienen el apellido de longitud >= 5.
SELECT "47:  Para cada película, cuenta cuántos actores tienen el apellido de longitud >= 5." AS '';
SELECT f.film_id, f.title, COUNT(a.actor_id) AS actors_lastname_len5plus
FROM film f
JOIN film_actor fa ON fa.film_id = f.film_id
JOIN actor a ON a.actor_id = fa.actor_id
WHERE LENGTH(a.last_name) >= 5
GROUP BY f.film_id, f.title;

-- 48:  Para cada categoría, suma la duración total (length) de sus películas.
SELECT "48:  Para cada categoría, suma la duración total (length) de sus películas." AS '';
SELECT c.category_id, c.name AS category_name, SUM(f.length) AS total_length
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
GROUP BY c.category_id, c.name;

-- 49:  Para cada ciudad, suma los importes pagados por clientes que residen en esa ciudad.
SELECT "49:  Para cada ciudad, suma los importes pagados por clientes que residen en esa ciudad." AS '';
SELECT ci.city_id, ci.city, SUM(p.amount) AS total_paid
FROM city ci
JOIN address a ON a.city_id = ci.city_id
JOIN customer c ON c.address_id = a.address_id
JOIN payment p ON p.customer_id = c.customer_id
GROUP BY ci.city_id, ci.city;

-- 50:  Para cada idioma, cuenta cuántos actores distintos participan en películas de ese idioma.
SELECT "50:  Para cada idioma, cuenta cuántos actores distintos participan en películas de ese idioma." AS '';
SELECT l.language_id, l.name AS language_name, COUNT(DISTINCT fa.actor_id) AS actors_in_language
FROM language l
JOIN film f ON f.language_id = l.language_id
JOIN film_actor fa ON fa.film_id = f.film_id
GROUP BY l.language_id, l.name;

-- 51:  Para cada tienda, cuenta cuántos clientes activos (active=1) tiene.
SELECT "51:  Para cada tienda, cuenta cuántos clientes activos (active=1) tiene." AS '';
SELECT st.store_id, COUNT(c.customer_id) AS active_customers
FROM store st
JOIN customer c ON c.store_id = st.store_id
JOIN address a ON a.address_id = c.address_id
WHERE c.active = 1
GROUP BY st.store_id;

-- 52:  Para cada cliente, cuenta en cuántas categorías distintas ha alquilado (aprox. vía film_category; requiere 4 tablas, aquí contamos películas 2006 por inventario).
SELECT "52:  Para cada cliente, cuenta en cuántas categorías distintas ha alquilado (aprox. vía film_category; requiere 4 tablas, aquí contamos películas 2006 por inventario)." AS '';
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS rentals_2006
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
JOIN inventory i ON i.inventory_id = r.inventory_id
WHERE YEAR(r.rental_date) = 2006
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 53:  Para cada empleado, cuenta cuántos clientes diferentes le han pagado.
SELECT "53:  Para cada empleado, cuenta cuántos clientes diferentes le han pagado." AS '';
SELECT s.staff_id, s.first_name, s.last_name, COUNT(DISTINCT p.customer_id) AS distinct_customers_paid
FROM staff s
JOIN payment p ON p.staff_id = s.staff_id
JOIN customer c ON c.customer_id = p.customer_id
GROUP BY s.staff_id, s.first_name, s.last_name;

-- 54:  Para cada ciudad, cuenta cuántas películas del año 2006 han sido alquiladas por residentes en esa ciudad.
SELECT "54:  Para cada ciudad, cuenta cuántas películas del año 2006 han sido alquiladas por residentes en esa ciudad." AS '';
SELECT ci.city_id, ci.city, COUNT(r.rental_id) AS rentals_2006_by_city
FROM city ci
JOIN address a ON a.city_id = ci.city_id
JOIN customer c ON c.address_id = a.address_id
JOIN rental r ON r.customer_id = c.customer_id
WHERE YEAR(r.rental_date) = 2006
GROUP BY ci.city_id, ci.city;

-- 55:  Para cada categoría, calcula el promedio de replacement_cost de sus películas.
SELECT "55:  Para cada categoría, calcula el promedio de replacement_cost de sus películas." AS '';
SELECT c.category_id, c.name AS category_name, AVG(f.replacement_cost) AS avg_replacement_cost
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
GROUP BY c.category_id, c.name;

-- 56:  Para cada tienda, suma los importes cobrados en 2006 (vía empleados de esa tienda).
SELECT "56:  Para cada tienda, suma los importes cobrados en 2006 (vía empleados de esa tienda)." AS '';
SELECT st.store_id, SUM(p.amount) AS revenue_2006
FROM store st
JOIN staff s ON s.store_id = st.store_id
JOIN payment p ON p.staff_id = s.staff_id
WHERE YEAR(p.payment_date) = 2006
GROUP BY st.store_id;

-- 57:  Para cada actor, cuenta cuántas películas tienen título de más de 12 caracteres.
SELECT "57:  Para cada actor, cuenta cuántas películas tienen título de más de 12 caracteres." AS '';
SELECT a.actor_id, a.first_name, a.last_name, COUNT(f.film_id) AS films_title_len_gt12
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film f ON f.film_id = fa.film_id
WHERE LENGTH(f.title) > 12
GROUP BY a.actor_id, a.first_name, a.last_name;

-- 58:  Para cada ciudad, calcula la suma de pagos de 2005 y filtra las ciudades con total >= 300.
SELECT "58:  Para cada ciudad, calcula la suma de pagos de 2005 y filtra las ciudades con total >= 300." AS '';
SELECT ci.city_id, ci.city, SUM(p.amount) AS total_2005
FROM city ci
JOIN address a ON a.city_id = ci.city_id
JOIN customer c ON c.address_id = a.address_id
JOIN payment p ON p.customer_id = c.customer_id
WHERE YEAR(p.payment_date) = 2005
GROUP BY ci.city_id, ci.city
HAVING SUM(p.amount) >= 300;

-- 59:  Para cada categoría, cuenta cuántas películas tienen rating 'PG' o 'PG-13'.
SELECT "59:  Para cada categoría, cuenta cuántas películas tienen rating 'PG' o 'PG-13'." AS '';
SELECT c.category_id, c.name AS category_name, COUNT(f.film_id) AS films_pg_pg13
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
WHERE f.rating IN ('PG','PG-13')
GROUP BY c.category_id, c.name;

-- 60:  Para cada cliente, calcula el total pagado en pagos procesados por el empleado 2.
SELECT "60:  Para cada cliente, calcula el total pagado en pagos procesados por el empleado 2." AS '';
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_paid_by_staff2
FROM customer c
JOIN payment p ON p.customer_id = c.customer_id
JOIN staff s ON s.staff_id = p.staff_id
WHERE s.staff_id = 2
GROUP BY c.customer_id, c.first_name, c.last_name;

-- ==============================================
-- SECCIÓN C) 20 CONSULTAS CON JOIN DE 4 TABLAS
-- ==============================================

-- 61:  Para cada ciudad, cuenta cuántos clientes hay y muestra solo ciudades con 10 o más clientes.
SELECT "61:  Para cada ciudad, cuenta cuántos clientes hay y muestra solo ciudades con 10 o más clientes." AS '';
SELECT ci.city_id, ci.city, COUNT(c.customer_id) AS customers_in_city
FROM city ci
JOIN address a ON a.city_id = ci.city_id
JOIN customer c ON c.address_id = a.address_id
JOIN store st ON st.store_id = c.store_id
GROUP BY ci.city_id, ci.city
HAVING COUNT(c.customer_id) >= 10;

-- 62:  Para cada actor, cuenta cuántos alquileres totales suman todas sus películas.
SELECT "62:  Para cada actor, cuenta cuántos alquileres totales suman todas sus películas." AS '';
SELECT a.actor_id, a.first_name, a.last_name, COUNT(r.rental_id) AS rentals_for_actor
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film f ON f.film_id = fa.film_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY a.actor_id, a.first_name, a.last_name;

-- 63:  Para cada categoría, suma los importes pagados derivados de películas de esa categoría.
SELECT "63:  Para cada categoría, suma los importes pagados derivados de películas de esa categoría." AS '';
SELECT c.category_id, c.name AS category_name, SUM(p.amount) AS revenue_by_category
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
JOIN payment p ON p.rental_id = r.rental_id
GROUP BY c.category_id, c.name;

-- 64:  Para cada ciudad, suma los importes pagados por clientes residentes en esa ciudad en 2005.
SELECT "64:  Para cada ciudad, suma los importes pagados por clientes residentes en esa ciudad en 2005." AS '';
SELECT ci.city_id, ci.city, SUM(p.amount) AS total_paid_2005
FROM city ci
JOIN address a ON a.city_id = ci.city_id
JOIN customer c ON c.address_id = a.address_id
JOIN payment p ON p.customer_id = c.customer_id
JOIN staff s ON s.staff_id = p.staff_id
WHERE YEAR(p.payment_date) = 2005
GROUP BY ci.city_id, ci.city;

-- 65:  Para cada tienda, cuenta cuántos actores distintos aparecen en las películas de su inventario.
SELECT "65:  Para cada tienda, cuenta cuántos actores distintos aparecen en las películas de su inventario." AS '';
SELECT st.store_id, COUNT(DISTINCT fa.actor_id) AS distinct_actors_in_store_inventory
FROM store st
JOIN inventory i ON i.store_id = st.store_id
JOIN film_actor fa ON fa.film_id = i.film_id
JOIN actor a ON a.actor_id = fa.actor_id
GROUP BY st.store_id;

-- 66:  Para cada idioma, cuenta cuántos alquileres totales se han hecho de películas en ese idioma.
SELECT "66:  Para cada idioma, cuenta cuántos alquileres totales se han hecho de películas en ese idioma." AS '';
SELECT l.language_id, l.name AS language_name, COUNT(r.rental_id) AS rentals_in_language
FROM language l
JOIN film f ON f.language_id = l.language_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY l.language_id, l.name;

-- 67:  Para cada cliente, cuenta en cuántos meses distintos de 2005 realizó pagos (meses distintos).
SELECT "67:  Para cada cliente, cuenta en cuántos meses distintos de 2005 realizó pagos (meses distintos)." AS '';
SELECT c.customer_id, c.first_name, c.last_name, COUNT(DISTINCT MONTH(p.payment_date)) AS active_months_2005
FROM customer c
JOIN payment p ON p.customer_id = c.customer_id
JOIN staff s ON s.staff_id = p.staff_id
JOIN store st ON st.store_id = s.store_id
WHERE YEAR(p.payment_date) = 2005
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 68:  Para cada categoría, calcula la duración media de las películas alquiladas (considerando solo películas alquiladas).
SELECT "68:  Para cada categoría, calcula la duración media de las películas alquiladas (considerando solo películas alquiladas)." AS '';
SELECT c.category_id, c.name AS category_name, AVG(f.length) AS avg_length_rented
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY c.category_id, c.name;

-- 69:  Para cada país, cuenta cuántos clientes hay (country -> city -> address -> customer).
SELECT "69:  Para cada país, cuenta cuántos clientes hay (country -> city -> address -> customer)." AS '';
SELECT co.country_id, co.country, COUNT(c.customer_id) AS customers_in_country
FROM country co
JOIN city ci ON ci.country_id = co.country_id
JOIN address a ON a.city_id = ci.city_id
JOIN customer c ON c.address_id = a.address_id
GROUP BY co.country_id, co.country;

-- 70:  Para cada país, suma los importes pagados por sus clientes.
SELECT "70:  Para cada país, suma los importes pagados por sus clientes." AS '';
SELECT co.country_id, co.country, SUM(p.amount) AS total_paid_by_country
FROM country co
JOIN city ci ON ci.country_id = co.country_id
JOIN address a ON a.city_id = ci.city_id
JOIN customer c ON c.address_id = a.address_id
JOIN payment p ON p.customer_id = c.customer_id
GROUP BY co.country_id, co.country;

-- 71:  Para cada tienda, cuenta cuántas categorías distintas existen en su inventario.
SELECT "71:  Para cada tienda, cuenta cuántas categorías distintas existen en su inventario." AS '';
SELECT st.store_id, COUNT(DISTINCT fc.category_id) AS distinct_categories_in_store
FROM store st
JOIN inventory i ON i.store_id = st.store_id
JOIN film_category fc ON fc.film_id = i.film_id
JOIN category c ON c.category_id = fc.category_id
GROUP BY st.store_id;

-- 72:  Para cada tienda, suma la recaudación por categoría (resultado agregado por tienda y categoría).
SELECT "72:  Para cada tienda, suma la recaudación por categoría (resultado agregado por tienda y categoría)." AS '';
SELECT st.store_id, c.category_id, c.name AS category_name, SUM(p.amount) AS revenue
FROM store st
JOIN staff s ON s.store_id = st.store_id
JOIN payment p ON p.staff_id = s.staff_id
JOIN rental r ON r.rental_id = p.rental_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film_category fc ON fc.film_id = i.film_id
JOIN category c ON c.category_id = fc.category_id
GROUP BY st.store_id, c.category_id, c.name;

-- 73:  Para cada actor, cuenta en cuántas tiendas distintas se han alquilado sus películas.
SELECT "73:  Para cada actor, cuenta en cuántas tiendas distintas se han alquilado sus películas." AS '';
SELECT a.actor_id, a.first_name, a.last_name, COUNT(DISTINCT i.store_id) AS stores_with_actor_films_rented
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN inventory i ON i.film_id = fa.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY a.actor_id, a.first_name, a.last_name;

-- 74:  Para cada categoría, cuenta cuántos clientes distintos han alquilado películas de esa categoría.
SELECT "74:  Para cada categoría, cuenta cuántos clientes distintos han alquilado películas de esa categoría." AS '';
SELECT c.category_id, c.name AS category_name, COUNT(DISTINCT r.customer_id) AS distinct_customers
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN inventory i ON i.film_id = fc.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY c.category_id, c.name;

-- 75:  Para cada idioma, cuenta cuántos actores distintos participan en películas alquiladas en ese idioma.
SELECT "75:  Para cada idioma, cuenta cuántos actores distintos participan en películas alquiladas en ese idioma." AS '';
SELECT l.language_id, l.name AS language_name, COUNT(DISTINCT fa.actor_id) AS actors_in_rented_language_films
FROM language l
JOIN film f ON f.language_id = l.language_id
JOIN film_actor fa ON fa.film_id = f.film_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY l.language_id, l.name;

-- 76:  Para cada país, cuenta cuántas tiendas hay (país->ciudad->address->store).
SELECT "76:  Para cada país, cuenta cuántas tiendas hay (país->ciudad->address->store)." AS '';
SELECT co.country_id, co.country, COUNT(st.store_id) AS stores_in_country
FROM country co
JOIN city ci ON ci.country_id = co.country_id
JOIN address a ON a.city_id = ci.city_id
JOIN store st ON st.address_id = a.address_id
GROUP BY co.country_id, co.country;

-- 77:  Para cada cliente, cuenta los alquileres en los que la devolución (return_date) fue el mismo día del alquiler.
SELECT "77:  Para cada cliente, cuenta los alquileres en los que la devolución (return_date) fue el mismo día del alquiler." AS '';
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS same_day_returns
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON f.film_id = i.film_id
WHERE DATE(r.rental_date) = DATE(r.return_date)
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 78:  Para cada tienda, cuenta cuántos clientes distintos realizaron pagos en 2005.
SELECT "78:  Para cada tienda, cuenta cuántos clientes distintos realizaron pagos en 2005." AS '';
SELECT st.store_id, COUNT(DISTINCT p.customer_id) AS distinct_customers_2005
FROM store st
JOIN staff s ON s.store_id = st.store_id
JOIN payment p ON p.staff_id = s.staff_id
JOIN customer c ON c.customer_id = p.customer_id
WHERE YEAR(p.payment_date) = 2005
GROUP BY st.store_id;

-- 79:  Para cada categoría, cuenta cuántas películas con título de longitud > 15 han sido alquiladas.
SELECT "79:  Para cada categoría, cuenta cuántas películas con título de longitud > 15 han sido alquiladas." AS '';
SELECT c.category_id, c.name AS category_name, COUNT(r.rental_id) AS rentals_long_title
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE LENGTH(f.title) > 15
GROUP BY c.category_id, c.name;

-- 80:  Para cada país, suma los pagos procesados por los empleados de las tiendas ubicadas en ese país.
SELECT "80:  Para cada país, suma los pagos procesados por los empleados de las tiendas ubicadas en ese país." AS '';
SELECT co.country_id, co.country, SUM(p.amount) AS revenue_by_country_staff
FROM country co
JOIN city ci ON ci.country_id = co.country_id
JOIN address a ON a.city_id = ci.city_id
JOIN store st ON st.address_id = a.address_id
JOIN staff s ON s.store_id = st.store_id
JOIN payment p ON p.staff_id = s.staff_id
GROUP BY co.country_id, co.country;

-- ==============================================
-- SECCIÓN D) 20 CONSULTAS EXTRA (DIFICULTAD +), <=4 JOINS
-- ==============================================

-- 81:  Para cada cliente, muestra el total pagado con IVA teórico del 21% aplicado (total*1.21), redondeado a 2 decimales.
SELECT "81:  Para cada cliente, muestra el total pagado con IVA teórico del 21% aplicado (total*1.21), redondeado a 2 decimales." AS '';
SELECT c.customer_id, c.first_name, c.last_name, ROUND(SUM(p.amount) * 1.21, 2) AS total_with_vat_21
FROM customer c
JOIN payment p ON p.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 82:  Para cada hora del día (0-23), cuenta cuántos alquileres se iniciaron en esa hora.
SELECT "82:  Para cada hora del día (0-23), cuenta cuántos alquileres se iniciaron en esa hora." AS '';
SELECT HOUR(r.rental_date) AS rental_hour, COUNT(r.rental_id) AS rentals_in_hour
FROM rental r
JOIN customer c ON c.customer_id = r.customer_id
GROUP BY HOUR(r.rental_date)
ORDER BY rental_hour;

-- 83:  Para cada tienda, muestra la media de length de las películas alquiladas en 2005 y filtra las tiendas con media >= 100.
SELECT "83:  Para cada tienda, muestra la media de length de las películas alquiladas en 2005 y filtra las tiendas con media >= 100." AS '';
SELECT st.store_id, AVG(f.length) AS avg_length_2005
FROM store st
JOIN inventory i ON i.store_id = st.store_id
JOIN rental r ON r.inventory_id = i.inventory_id
JOIN film f ON f.film_id = i.film_id
WHERE YEAR(r.rental_date) = 2005
GROUP BY st.store_id
HAVING AVG(f.length) >= 100;

-- 84:  Para cada categoría, muestra la media de replacement_cost de las películas alquiladas un domingo.
SELECT "84:  Para cada categoría, muestra la media de replacement_cost de las películas alquiladas un domingo." AS '';
SELECT c.category_id, c.name AS category_name, AVG(f.replacement_cost) AS avg_replacement_sundays
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE DAYOFWEEK(r.rental_date) = 1
GROUP BY c.category_id, c.name;

-- 85:  Para cada empleado, muestra el importe total por pagos realizados entre las 00:00 y 06:00 (inclusive 00:00, exclusivo 06:00).
SELECT "85:  Para cada empleado, muestra el importe total por pagos realizados entre las 00:00 y 06:00 (inclusive 00:00, exclusivo 06:00)." AS '';
SELECT s.staff_id, s.first_name, s.last_name, SUM(p.amount) AS night_shift_amount
FROM staff s
JOIN payment p ON p.staff_id = s.staff_id
WHERE TIME(p.payment_date) >= '00:00:00' AND TIME(p.payment_date) < '06:00:00'
GROUP BY s.staff_id, s.first_name, s.last_name;

-- 86:  Para cada actor, cuenta cuántas de sus películas tienen un título que contiene la palabra 'LOVE' (mayúsculas).
SELECT "86:  Para cada actor, cuenta cuántas de sus películas tienen un título que contiene la palabra 'LOVE' (mayúsculas)." AS '';
SELECT a.actor_id, a.first_name, a.last_name, COUNT(f.film_id) AS films_with_love
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film f ON f.film_id = fa.film_id
WHERE UPPER(f.title) LIKE '%LOVE%'
GROUP BY a.actor_id, a.first_name, a.last_name;

-- 87:  Para cada idioma, muestra el total de pagos de alquileres de películas en ese idioma.
SELECT "87:  Para cada idioma, muestra el total de pagos de alquileres de películas en ese idioma." AS '';
SELECT l.language_id, l.name AS language_name, SUM(p.amount) AS total_amount_in_language
FROM language l
JOIN film f ON f.language_id = l.language_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
JOIN payment p ON p.rental_id = r.rental_id
GROUP BY l.language_id, l.name;

-- 88:  Para cada cliente, cuenta en cuántos días distintos de 2005 realizó algún alquiler.
SELECT "88:  Para cada cliente, cuenta en cuántos días distintos de 2005 realizó algún alquiler." AS '';
SELECT c.customer_id, c.first_name, c.last_name, COUNT(DISTINCT DATE(r.rental_date)) AS active_days_2005
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
WHERE YEAR(r.rental_date) = 2005
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 89:  Para cada categoría, calcula la longitud media de títulos (número de caracteres) de sus películas alquiladas.
SELECT "89:  Para cada categoría, calcula la longitud media de títulos (número de caracteres) de sus películas alquiladas." AS '';
SELECT c.category_id, c.name AS category_name, AVG(LENGTH(f.title)) AS avg_title_len_rented
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY c.category_id, c.name;

-- 90:  Para cada tienda, cuenta cuántos clientes distintos alquilaron en el primer trimestre de 2006 (enero-marzo).
SELECT "90:  Para cada tienda, cuenta cuántos clientes distintos alquilaron en el primer trimestre de 2006 (enero-marzo)." AS '';
SELECT st.store_id, COUNT(DISTINCT r.customer_id) AS distinct_customers_q1_2006
FROM store st
JOIN inventory i ON i.store_id = st.store_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE YEAR(r.rental_date) = 2006 AND QUARTER(r.rental_date) = 1
GROUP BY st.store_id;

-- 91:  Para cada país, cuenta cuántas categorías diferentes han sido alquiladas por clientes residentes en ese país.
SELECT "91:  Para cada país, cuenta cuántas categorías diferentes han sido alquiladas por clientes residentes en ese país." AS '';
SELECT co.country_id, co.country, COUNT(DISTINCT fc.category_id) AS distinct_categories_rented_by_country
FROM country co
JOIN city ci ON ci.country_id = co.country_id
JOIN address a ON a.city_id = ci.city_id
JOIN customer c ON c.address_id = a.address_id
JOIN rental r ON r.customer_id = c.customer_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film_category fc ON fc.film_id = i.film_id
GROUP BY co.country_id, co.country;

-- 92:  Para cada cliente, muestra el importe medio de sus pagos redondeado a 2 decimales, solo si ha hecho al menos 10 pagos.
SELECT "92:  Para cada cliente, muestra el importe medio de sus pagos redondeado a 2 decimales, solo si ha hecho al menos 10 pagos." AS '';
SELECT c.customer_id, c.first_name, c.last_name, ROUND(AVG(p.amount), 2) AS avg_payment
FROM customer c
JOIN payment p ON p.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(p.payment_id) >= 10;

-- 93:  Para cada categoría, muestra el número de películas con replacement_cost > 20 que hayan sido alquiladas al menos una vez.
SELECT "93:  Para cada categoría, muestra el número de películas con replacement_cost > 20 que hayan sido alquiladas al menos una vez." AS '';
SELECT c.category_id, c.name AS category_name, COUNT(DISTINCT f.film_id) AS pricey_rented_films
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE f.replacement_cost > 20
GROUP BY c.category_id, c.name;

-- 94:  Para cada tienda, suma los importes pagados en fines de semana.
SELECT "94:  Para cada tienda, suma los importes pagados en fines de semana." AS '';
SELECT st.store_id, SUM(p.amount) AS weekend_revenue
FROM store st
JOIN staff s ON s.store_id = st.store_id
JOIN payment p ON p.staff_id = s.staff_id
WHERE DAYOFWEEK(p.payment_date) IN (1,7)
GROUP BY st.store_id;

-- 95:  Para cada actor, cuenta cuántas películas suyas fueron alquiladas por al menos 5 clientes distintos (se cuenta alquileres y luego se filtra por HAVING).
SELECT "95:  Para cada actor, cuenta cuántas películas suyas fueron alquiladas por al menos 5 clientes distintos (se cuenta alquileres y luego se filtra por HAVING)." AS '';
SELECT a.actor_id, a.first_name, a.last_name, COUNT(DISTINCT r.customer_id) AS distinct_customers
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN inventory i ON i.film_id = fa.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(DISTINCT r.customer_id) >= 5;

-- 96:  Para cada idioma, muestra el número de películas cuyo título empieza por la letra 'A' y que han sido alquiladas.
SELECT "96:  Para cada idioma, muestra el número de películas cuyo título empieza por la letra 'A' y que han sido alquiladas." AS '';
SELECT l.language_id, l.name AS language_name, COUNT(DISTINCT f.film_id) AS films_starting_A_rented
FROM language l
JOIN film f ON f.language_id = l.language_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE f.title LIKE 'A%'
GROUP BY l.language_id, l.name;

-- 97:  Para cada país, suma el importe total de pagos realizados por clientes residentes y filtra países con total >= 1000.
SELECT "97:  Para cada país, suma el importe total de pagos realizados por clientes residentes y filtra países con total >= 1000." AS '';
SELECT co.country_id, co.country, SUM(p.amount) AS total_amount
FROM country co
JOIN city ci ON ci.country_id = co.country_id
JOIN address a ON a.city_id = ci.city_id
JOIN customer c ON c.address_id = a.address_id
JOIN payment p ON p.customer_id = c.customer_id
GROUP BY co.country_id, co.country
HAVING SUM(p.amount) >= 1000;

-- 98:  Para cada cliente, cuenta cuántos días han pasado entre su primer y su último alquiler en 2005 (diferencia de fechas), mostrando solo clientes con >= 5 alquileres en 2005.
SELECT "98:  Para cada cliente, cuenta cuántos días han pasado entre su primer y su último alquiler en 2005 (diferencia de fechas), mostrando solo clientes con >= 5 alquileres en 2005." AS '';
--     (Se evita subconsulta calculando sobre el conjunto agrupado por cliente y usando MIN/MAX de rental_date en 2005).
SELECT c.customer_id, c.first_name, c.last_name,
       DATEDIFF(MAX(r.rental_date), MIN(r.rental_date)) AS days_between_first_last_2005
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
WHERE YEAR(r.rental_date) = 2005
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(r.rental_id) >= 5;

-- 99:  Para cada tienda, muestra la media de importes cobrados por transacción en el año 2006, con dos decimales.
SELECT "99:  Para cada tienda, muestra la media de importes cobrados por transacción en el año 2006, con dos decimales." AS '';
SELECT st.store_id, ROUND(AVG(p.amount), 2) AS avg_payment_2006
FROM store st
JOIN staff s ON s.store_id = st.store_id
JOIN payment p ON p.staff_id = s.staff_id
WHERE YEAR(p.payment_date) = 2006
GROUP BY st.store_id;

-- 100:  Para cada categoría, calcula la media de duración (length) de películas alquiladas en 2006 y ordénalas descendentemente por dicha media.
SELECT "100:  Para cada categoría, calcula la media de duración (length) de películas alquiladas en 2006 y ordénalas descendentemente por dicha media." AS '';
SELECT c.category_id, c.name AS category_name, AVG(f.length) AS avg_length_rented_2006
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE YEAR(r.rental_date) = 2006
GROUP BY c.category_id, c.name
ORDER BY avg_length_rented_2006 DESC;
