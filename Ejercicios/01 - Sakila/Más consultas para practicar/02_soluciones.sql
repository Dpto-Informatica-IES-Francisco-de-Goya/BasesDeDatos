USE sakila;

-- ==============================================
-- SECCIÓN E) 30 CONSULTAS (JOIN DE EXACTAMENTE 2 TABLAS)
-- ==============================================

-- 1) Para cada idioma, obtener el replacement_cost máximo y mínimo de sus películas (idioma con >=10 películas).
-- Salida obligatoria (alias en orden): language_id, language_name, max_replacement_cost, min_replacement_cost
SELECT "1) Para cada idioma, obtener el replacement_cost máximo y mínimo de sus películas (idioma con >=10 películas)" AS '';
SELECT l.language_id AS language_id,
       l.name AS language_name,
       MAX(f.replacement_cost) AS max_replacement_cost,
       MIN(f.replacement_cost) AS min_replacement_cost
FROM language l
JOIN film f ON f.language_id = l.language_id
GROUP BY l.language_id, l.name
HAVING COUNT(f.film_id) >= 10;

-- 2) Para cada idioma, contar cuántas películas tienen rating 'R'.
-- Salida obligatoria (alias en orden): language_id, language_name, films_rating_r
SELECT "2) Para cada idioma, contar cuántas películas tienen rating 'R'" AS '';
SELECT l.language_id AS language_id,
       l.name AS language_name,
       COUNT(f.film_id) AS films_rating_r
FROM language l
JOIN film f ON f.language_id = l.language_id
WHERE f.rating = 'R'
GROUP BY l.language_id, l.name;

-- 3) Para cada idioma, media de replacement_cost redondeada a 2 decimales (>=20).
-- Salida obligatoria (alias en orden): language_id, language_name, avg_replacement_cost_2d
SELECT "3) Para cada idioma, media de replacement_cost redondeada a 2 decimales (>=20)" AS '';
SELECT l.language_id AS language_id,
       l.name AS language_name,
       ROUND(AVG(f.replacement_cost), 2) AS avg_replacement_cost_2d
FROM language l
JOIN film f ON f.language_id = l.language_id
GROUP BY l.language_id, l.name
HAVING ROUND(AVG(f.replacement_cost), 2) >= 20;

-- 4) Para cada cliente, fecha del primer y último pago registrados.
-- Salida obligatoria (alias en orden): customer_id, first_name, last_name, first_payment_date, last_payment_date
SELECT "4) Para cada cliente, fecha del primer y último pago registrados" AS '';
SELECT c.customer_id AS customer_id,
       c.first_name AS first_name,
       c.last_name  AS last_name,
       MIN(p.payment_date) AS first_payment_date,
       MAX(p.payment_date) AS last_payment_date
FROM customer c
JOIN payment p ON p.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 5) Para cada cliente, pago medio (2 decimales) solo si tiene más de 5 pagos.
-- Salida obligatoria (alias en orden): customer_id, first_name, last_name, avg_payment_2d
SELECT "5) Para cada cliente, pago medio (2 decimales) solo si tiene más de 5 pagos" AS '';
SELECT c.customer_id AS customer_id,
       c.first_name AS first_name,
       c.last_name  AS last_name,
       ROUND(AVG(p.amount), 2) AS avg_payment_2d
FROM customer c
JOIN payment p ON p.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(p.payment_id) > 5;

-- 6) Para cada cliente, número de pagos hechos en domingo (DAYOFWEEK=1).
-- Salida obligatoria (alias en orden): customer_id, first_name, last_name, sunday_payments
SELECT "6) Para cada cliente, número de pagos hechos en domingo (DAYOFWEEK=1)" AS '';
SELECT c.customer_id AS customer_id,
       c.first_name AS first_name,
       c.last_name  AS last_name,
       COUNT(p.payment_id) AS sunday_payments
FROM customer c
JOIN payment p ON p.customer_id = c.customer_id
WHERE DAYOFWEEK(p.payment_date) = 1
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 7) Para cada empleado, importe máximo y mínimo de un pago procesado.
-- Salida obligatoria (alias en orden): staff_id, first_name, last_name, max_payment, min_payment
SELECT "7) Para cada empleado, importe máximo y mínimo de un pago procesado" AS '';
SELECT s.staff_id AS staff_id,
       s.first_name AS first_name,
       s.last_name  AS last_name,
       MAX(p.amount) AS max_payment,
       MIN(p.amount) AS min_payment
FROM staff s
JOIN payment p ON p.staff_id = s.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name;

-- 8) Para cada empleado, media de importes entre 12:00 y 18:00.
-- Salida obligatoria (alias en orden): staff_id, first_name, last_name, avg_amount_12_18
SELECT "8) Para cada empleado, media de importes entre 12:00 y 18:00" AS '';
SELECT s.staff_id AS staff_id,
       s.first_name AS first_name,
       s.last_name  AS last_name,
       AVG(p.amount) AS avg_amount_12_18
FROM staff s
JOIN payment p ON p.staff_id = s.staff_id
WHERE TIME(p.payment_date) >= '12:00:00' AND TIME(p.payment_date) < '18:00:00'
GROUP BY s.staff_id, s.first_name, s.last_name;

-- 9) Para cada inventario, duración media del alquiler en días (return - rental).
-- Salida obligatoria (alias en orden): inventory_id, avg_days_rented
SELECT "9) Para cada inventario, duración media del alquiler en días (return - rental)" AS '';
SELECT i.inventory_id AS inventory_id,
       AVG(DATEDIFF(r.return_date, r.rental_date)) AS avg_days_rented
FROM inventory i
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY i.inventory_id;

-- 10) Para cada inventario, número de devoluciones el mismo día.
-- Salida obligatoria (alias en orden): inventory_id, same_day_returns
SELECT "10) Para cada inventario, número de devoluciones el mismo día" AS '';
SELECT i.inventory_id AS inventory_id,
       COUNT(r.rental_id) AS same_day_returns
FROM inventory i
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE DATE(r.rental_date) = DATE(r.return_date)
GROUP BY i.inventory_id;

-- 11) Para cada tienda, clientes inactivos (active=0).
-- Salida obligatoria (alias en orden): store_id, inactive_customers
SELECT "11) Para cada tienda, clientes inactivos (active=0)" AS '';
SELECT st.store_id AS store_id,
       COUNT(c.customer_id) AS inactive_customers
FROM store st
JOIN customer c ON c.store_id = st.store_id
WHERE c.active = 0
GROUP BY st.store_id;

-- 12) Para cada tienda, clientes con apellido de >10 caracteres.
-- Salida obligatoria (alias en orden): store_id, customers_lastname_gt10
SELECT "12) Para cada tienda, clientes con apellido de >10 caracteres" AS '';
SELECT st.store_id AS store_id,
       COUNT(c.customer_id) AS customers_lastname_gt10
FROM store st
JOIN customer c ON c.store_id = st.store_id
WHERE LENGTH(c.last_name) > 10
GROUP BY st.store_id;

-- 13) Para cada ciudad, direcciones con postal_code no nulo.
-- Salida obligatoria (alias en orden): city_id, city_name, addresses_with_postalcode
SELECT "13) Para cada ciudad, direcciones con postal_code no nulo" AS '';
SELECT ci.city_id AS city_id,
       ci.city AS city_name,
       COUNT(a.address_id) AS addresses_with_postalcode
FROM city ci
JOIN address a ON a.city_id = ci.city_id
WHERE a.postal_code IS NOT NULL
GROUP BY ci.city_id, ci.city;

-- 14) Para cada ciudad, direcciones con teléfono que empieza por '5'.
-- Salida obligatoria (alias en orden): city_id, city_name, addresses_phone_5
SELECT "14) Para cada ciudad, direcciones con teléfono que empieza por '5'" AS '';
SELECT ci.city_id AS city_id,
       ci.city AS city_name,
       COUNT(a.address_id) AS addresses_phone_5
FROM city ci
JOIN address a ON a.city_id = ci.city_id
WHERE a.phone LIKE '5%'
GROUP BY ci.city_id, ci.city;

-- 15) Para cada categoría, contar películas (>=20).
-- Salida obligatoria (alias en orden): category_id, category_name, films_in_category_20plus
SELECT "15) Para cada categoría, contar películas (>=20)" AS '';
SELECT c.category_id AS category_id,
       c.name AS category_name,
       COUNT(fc.film_id) AS films_in_category_20plus
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
GROUP BY c.category_id, c.name
HAVING COUNT(fc.film_id) >= 20;

-- 16) Para cada categoría, contar películas con id par.
-- Salida obligatoria (alias en orden): category_id, category_name, films_with_even_id
SELECT "16) Para cada categoría, contar películas con id par" AS '';
SELECT c.category_id AS category_id,
       c.name AS category_name,
       COUNT(fc.film_id) AS films_with_even_id
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
WHERE MOD(fc.film_id, 2) = 0
GROUP BY c.category_id, c.name;

-- 17) Para cada idioma, contar películas con título de longitud 10.
-- Salida obligatoria (alias en orden): language_id, language_name, films_title_len_10
SELECT "17) Para cada idioma, contar películas con título de longitud 10" AS '';
SELECT l.language_id AS language_id,
       l.name AS language_name,
       COUNT(f.film_id) AS films_title_len_10
FROM language l
JOIN film f ON f.language_id = l.language_id
WHERE LENGTH(f.title) = 10
GROUP BY l.language_id, l.name;

-- 18) Para cada idioma, contar películas con 'THE' en título (mayúsculas).
-- Salida obligatoria (alias en orden): language_id, language_name, films_with_the
SELECT "18) Para cada idioma, contar películas con 'THE' en título (mayúsculas)" AS '';
SELECT l.language_id AS language_id,
       l.name AS language_name,
       COUNT(f.film_id) AS films_with_the
FROM language l
JOIN film f ON f.language_id = l.language_id
WHERE UPPER(f.title) LIKE '%THE%'
GROUP BY l.language_id, l.name;

-- 19) Para cada cliente, alquileres nocturnos (22:00–06:00).
-- Salida obligatoria (alias en orden): customer_id, first_name, last_name, night_rentals
SELECT "19) Para cada cliente, alquileres nocturnos (22:00–06:00)" AS '';
SELECT c.customer_id AS customer_id,
       c.first_name AS first_name,
       c.last_name  AS last_name,
       COUNT(r.rental_id) AS night_rentals
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
WHERE (TIME(r.rental_date) >= '22:00:00' OR TIME(r.rental_date) < '06:00:00')
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 20) Para cada cliente, media de horas entre alquiler y devolución (1 decimal).
-- Salida obligatoria (alias en orden): customer_id, first_name, last_name, avg_hours_rented_1d
SELECT "20) Para cada cliente, media de horas entre alquiler y devolución (1 decimal)" AS '';
SELECT c.customer_id AS customer_id,
       c.first_name AS first_name,
       c.last_name  AS last_name,
       ROUND(AVG(TIMESTAMPDIFF(HOUR, r.rental_date, r.return_date)), 1) AS avg_hours_rented_1d
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 21) Para cada película, copias de inventario con id impar.
-- Salida obligatoria (alias en orden): film_id, title, odd_inventory_copies
SELECT "21) Para cada película, copias de inventario con id impar" AS '';
SELECT f.film_id AS film_id,
       f.title AS title,
       COUNT(i.inventory_id) AS odd_inventory_copies
FROM film f
JOIN inventory i ON i.film_id = f.film_id
WHERE MOD(i.inventory_id, 2) = 1
GROUP BY f.film_id, f.title;

-- 22) Para cada empleado, pagos procesados en domingo.
-- Salida obligatoria (alias en orden): staff_id, first_name, last_name, sunday_payments
SELECT "22) Para cada empleado, pagos procesados en domingo" AS '';
SELECT s.staff_id AS staff_id,
       s.first_name AS first_name,
       s.last_name  AS last_name,
       COUNT(p.payment_id) AS sunday_payments
FROM staff s
JOIN payment p ON p.staff_id = s.staff_id
WHERE DAYOFWEEK(p.payment_date) = 1
GROUP BY s.staff_id, s.first_name, s.last_name;

-- 23) Para cada ciudad, direcciones con address2 no nulo.
-- Salida obligatoria (alias en orden): city_id, city_name, addresses_with_address2
SELECT "23) Para cada ciudad, direcciones con address2 no nulo" AS '';
SELECT ci.city_id AS city_id,
       ci.city AS city_name,
       COUNT(a.address_id) AS addresses_with_address2
FROM city ci
JOIN address a ON a.city_id = ci.city_id
WHERE a.address2 IS NOT NULL
GROUP BY ci.city_id, ci.city;

-- 24) Para cada ciudad, direcciones cuyo address contiene un espacio.
-- Salida obligatoria (alias en orden): city_id, city_name, addresses_with_space
SELECT "24) Para cada ciudad, direcciones cuyo address contiene un espacio" AS '';
SELECT ci.city_id AS city_id,
       ci.city AS city_name,
       COUNT(a.address_id) AS addresses_with_space
FROM city ci
JOIN address a ON a.city_id = ci.city_id
WHERE INSTR(a.address, ' ') > 0
GROUP BY ci.city_id, ci.city;

-- 25) Para cada cliente, alquileres en 2006 (>=12).
-- Salida obligatoria (alias en orden): customer_id, first_name, last_name, rentals_2006_12plus
SELECT "25) Para cada cliente, alquileres en 2006 (>=12)" AS '';
SELECT c.customer_id AS customer_id,
       c.first_name AS first_name,
       c.last_name  AS last_name,
       COUNT(r.rental_id) AS rentals_2006_12plus
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
WHERE YEAR(r.rental_date) = 2006
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(r.rental_id) >= 12;

-- 26) Para cada cliente, alquileres entre semana (DAYOFWEEK 2–6).
-- Salida obligatoria (alias en orden): customer_id, first_name, last_name, weekday_rentals
SELECT "26) Para cada cliente, alquileres entre semana (DAYOFWEEK 2–6)" AS '';
SELECT c.customer_id AS customer_id,
       c.first_name AS first_name,
       c.last_name  AS last_name,
       COUNT(r.rental_id) AS weekday_rentals
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
WHERE DAYOFWEEK(r.rental_date) BETWEEN 2 AND 6
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 27) Para cada empleado, pagos procesados en sábado.
-- Salida obligatoria (alias en orden): staff_id, first_name, last_name, saturday_payments
SELECT "27) Para cada empleado, pagos procesados en sábado" AS '';
SELECT s.staff_id AS staff_id,
       s.first_name AS first_name,
       s.last_name  AS last_name,
       COUNT(p.payment_id) AS saturday_payments
FROM staff s
JOIN payment p ON p.staff_id = s.staff_id
WHERE DAYOFWEEK(p.payment_date) = 7
GROUP BY s.staff_id, s.first_name, s.last_name;

-- 28) Para cada categoría, contar películas con category_id impar.
-- Salida obligatoria (alias en orden): category_id, category_name, films_with_odd_category_id
SELECT "28) Para cada categoría, contar películas con category_id impar" AS '';
SELECT c.category_id AS category_id,
       c.name AS category_name,
       COUNT(fc.film_id) AS films_with_odd_category_id
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
WHERE MOD(c.category_id, 2) = 1
GROUP BY c.category_id, c.name;

-- 29) Para cada idioma, contar películas con replacement_cost redondeado (0 decimales) >= 25.
-- Salida obligatoria (alias en orden): language_id, language_name, films_replacement_rounded_25plus
SELECT "29) Para cada idioma, contar películas con replacement_cost redondeado (0 decimales) >= 25" AS '';
SELECT l.language_id AS language_id,
       l.name AS language_name,
       COUNT(f.film_id) AS films_replacement_rounded_25plus
FROM language l
JOIN film f ON f.language_id = l.language_id
WHERE ROUND(f.replacement_cost, 0) >= 25
GROUP BY l.language_id, l.name;

-- 30) Para cada idioma, contar películas cuyo título termina en 'N'.
-- Salida obligatoria (alias en orden): language_id, language_name, films_title_end_n
SELECT "30) Para cada idioma, contar películas cuyo título termina en 'N'" AS '';
SELECT l.language_id AS language_id,
       l.name AS language_name,
       COUNT(f.film_id) AS films_title_end_n
FROM language l
JOIN film f ON f.language_id = l.language_id
WHERE UPPER(f.title) LIKE '%N'
GROUP BY l.language_id, l.name;

-- ==============================================
-- SECCIÓN F) 30 CONSULTAS (JOIN DE EXACTAMENTE 3 TABLAS)
-- ==============================================

-- 31) Para cada ciudad, clientes activos (active=1) residentes en ella.
-- Salida obligatoria (alias en orden): city_id, city_name, active_customers_in_city
SELECT "31) Para cada ciudad, clientes activos (active=1) residentes en ella" AS '';
SELECT ci.city_id AS city_id,
       ci.city AS city_name,
       COUNT(c.customer_id) AS active_customers_in_city
FROM city ci
JOIN address a ON a.city_id = ci.city_id
JOIN customer c ON c.address_id = a.address_id
WHERE c.active = 1
GROUP BY ci.city_id, ci.city;

-- 32) Para cada ciudad, empleados que residen en esa ciudad.
-- Salida obligatoria (alias en orden): city_id, city_name, staff_in_city
SELECT "32) Para cada ciudad, empleados que residen en esa ciudad" AS '';
SELECT ci.city_id AS city_id,
       ci.city AS city_name,
       COUNT(s.staff_id) AS staff_in_city
FROM city ci
JOIN address a ON a.city_id = ci.city_id
JOIN staff s ON s.address_id = a.address_id
GROUP BY ci.city_id, ci.city;

-- 33) Para cada categoría, películas con rating 'PG'.
-- Salida obligatoria (alias en orden): category_id, category_name, films_pg_in_category
SELECT "33) Para cada categoría, películas con rating 'PG'" AS '';
SELECT c.category_id AS category_id,
       c.name AS category_name,
       COUNT(f.film_id) AS films_pg_in_category
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
WHERE f.rating = 'PG'
GROUP BY c.category_id, c.name;

-- 34) Para cada categoría, coste medio de reposición de películas con título > 12 caracteres.
-- Salida obligatoria (alias en orden): category_id, category_name, avg_replacement_long_titles
SELECT "34) Para cada categoría, coste medio de reposición de películas con título > 12 caracteres" AS '';
SELECT c.category_id AS category_id,
       c.name AS category_name,
       AVG(f.replacement_cost) AS avg_replacement_long_titles
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
WHERE LENGTH(f.title) > 12
GROUP BY c.category_id, c.name;

-- 35) Para cada cliente, alquileres en junio de 2005.
-- Salida obligatoria (alias en orden): customer_id, first_name, last_name, rentals_june_2005
SELECT "35) Para cada cliente, alquileres en junio de 2005" AS '';
SELECT c.customer_id AS customer_id,
       c.first_name AS first_name,
       c.last_name  AS last_name,
       COUNT(r.rental_id) AS rentals_june_2005
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
JOIN inventory i ON i.inventory_id = r.inventory_id
WHERE YEAR(r.rental_date) = 2005 AND MONTH(r.rental_date) = 6
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 36) Para cada película, alquileres en el primer trimestre de 2006.
-- Salida obligatoria (alias en orden): film_id, title, rentals_q1_2006
SELECT "36) Para cada película, alquileres en el primer trimestre de 2006" AS '';
SELECT f.film_id AS film_id,
       f.title AS title,
       COUNT(r.rental_id) AS rentals_q1_2006
FROM film f
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE YEAR(r.rental_date) = 2006 AND QUARTER(r.rental_date) = 1
GROUP BY f.film_id, f.title;

-- 37) Para cada empleado, clientes distintos a los que cobró en 2006.
-- Salida obligatoria (alias en orden): staff_id, first_name, last_name, distinct_customers_2006
SELECT "37) Para cada empleado, clientes distintos a los que cobró en 2006" AS '';
SELECT s.staff_id AS staff_id,
       s.first_name AS first_name,
       s.last_name  AS last_name,
       COUNT(DISTINCT p.customer_id) AS distinct_customers_2006
FROM staff s
JOIN payment p ON p.staff_id = s.staff_id
JOIN customer c ON c.customer_id = p.customer_id
WHERE YEAR(p.payment_date) = 2006
GROUP BY s.staff_id, s.first_name, s.last_name;

-- 38) Para cada cliente, importe total pagado por mes de 2005.
-- Salida obligatoria (alias en orden): customer_id, first_name, last_name, payment_month, total_paid_month
SELECT "38) Para cada cliente, importe total pagado por mes de 2005" AS '';
SELECT c.customer_id AS customer_id,
       c.first_name AS first_name,
       c.last_name  AS last_name,
       MONTH(p.payment_date) AS payment_month,
       SUM(p.amount) AS total_paid_month
FROM customer c
JOIN payment p ON p.customer_id = c.customer_id
JOIN staff s ON s.staff_id = p.staff_id
WHERE YEAR(p.payment_date) = 2005
GROUP BY c.customer_id, c.first_name, c.last_name, MONTH(p.payment_date);

-- 39) Para cada película, actores con apellido que empieza por 'A'.
-- Salida obligatoria (alias en orden): film_id, title, actors_lastname_start_a
SELECT "39) Para cada película, actores con apellido que empieza por 'A'" AS '';
SELECT f.film_id AS film_id,
       f.title AS title,
       COUNT(a.actor_id) AS actors_lastname_start_a
FROM film f
JOIN film_actor fa ON fa.film_id = f.film_id
JOIN actor a ON a.actor_id = fa.actor_id
WHERE UPPER(a.last_name) LIKE 'A%'
GROUP BY f.film_id, f.title;

-- 40) Para cada categoría, número de películas con rating en ('G','PG-13').
-- Salida obligatoria (alias en orden): category_id, category_name, films_g_pg13
SELECT "40) Para cada categoría, número de películas con rating en ('G','PG-13')" AS '';
SELECT c.category_id AS category_id,
       c.name AS category_name,
       COUNT(f.film_id) AS films_g_pg13
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
WHERE f.rating IN ('G','PG-13')
GROUP BY c.category_id, c.name;

-- 41) Para cada cliente, importe total pagado en fines de semana (por fecha de pago).
-- Salida obligatoria (alias en orden): customer_id, first_name, last_name, weekend_amount
SELECT "41) Para cada cliente, importe total pagado en fines de semana (por fecha de pago)" AS '';
SELECT c.customer_id AS customer_id,
       c.first_name AS first_name,
       c.last_name  AS last_name,
       SUM(p.amount) AS weekend_amount
FROM customer c
JOIN payment p ON p.customer_id = c.customer_id
JOIN staff s ON s.staff_id = p.staff_id
WHERE DAYOFWEEK(p.payment_date) IN (1,7)
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 42) Para cada idioma, número de copias de inventario de películas en ese idioma.
-- Salida obligatoria (alias en orden): language_id, language_name, inventory_items_language
SELECT "42) Para cada idioma, número de copias de inventario de películas en ese idioma" AS '';
SELECT l.language_id AS language_id,
       l.name AS language_name,
       COUNT(i.inventory_id) AS inventory_items_language
FROM language l
JOIN film f ON f.language_id = l.language_id
JOIN inventory i ON i.film_id = f.film_id
GROUP BY l.language_id, l.name;

-- 43) Para cada tienda, número de inventarios de películas con rating 'NC-17'.
-- Salida obligatoria (alias en orden): store_id, nc17_inventory_items
SELECT "43) Para cada tienda, número de inventarios de películas con rating 'NC-17'" AS '';
SELECT st.store_id AS store_id,
       COUNT(i.inventory_id) AS nc17_inventory_items
FROM store st
JOIN inventory i ON i.store_id = st.store_id
JOIN film f ON f.film_id = i.film_id
WHERE f.rating = 'NC-17'
GROUP BY st.store_id;

-- 44) Para cada tienda, total cobrado en agosto de 2005.
-- Salida obligatoria (alias en orden): store_id, total_amount_aug_2005
SELECT "44) Para cada tienda, total cobrado en agosto de 2005" AS '';
SELECT st.store_id AS store_id,
       SUM(p.amount) AS total_amount_aug_2005
FROM store st
JOIN staff s ON s.store_id = st.store_id
JOIN payment p ON p.staff_id = s.staff_id
WHERE YEAR(p.payment_date) = 2005 AND MONTH(p.payment_date) = 8
GROUP BY st.store_id;

-- 45) Para cada película, media de length considerando solo actores con apellido de >=6 letras.
-- Salida obligatoria (alias en orden): film_id, title, avg_length_for_actors_lastname6plus
SELECT "45) Para cada película, media de length considerando solo actores con apellido de >=6 letras" AS '';
SELECT f.film_id AS film_id,
       f.title AS title,
       AVG(f.length) AS avg_length_for_actors_lastname6plus
FROM film f
JOIN film_actor fa ON fa.film_id = f.film_id
JOIN actor a ON a.actor_id = fa.actor_id
WHERE LENGTH(a.last_name) >= 6
GROUP BY f.film_id, f.title;

-- 46) Para cada cliente, alquileres con retraso > 2 días.
-- Salida obligatoria (alias en orden): customer_id, first_name, last_name, late_returns_gt2
SELECT "46) Para cada cliente, alquileres con retraso > 2 días" AS '';
SELECT c.customer_id AS customer_id,
       c.first_name AS first_name,
       c.last_name  AS last_name,
       COUNT(r.rental_id) AS late_returns_gt2
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
JOIN inventory i ON i.inventory_id = r.inventory_id
WHERE DATEDIFF(r.return_date, r.rental_date) > 2
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 47) Para cada película, número de categorías a las que pertenece.
-- Salida obligatoria (alias en orden): film_id, title, distinct_categories_for_film
SELECT "47) Para cada película, número de categorías a las que pertenece" AS '';
SELECT f.film_id AS film_id,
       f.title AS title,
       COUNT(DISTINCT fc.category_id) AS distinct_categories_for_film
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
GROUP BY f.film_id, f.title;

-- 48) Para cada actor, películas con rating 'G' en su filmografía.
-- Salida obligatoria (alias en orden): actor_id, first_name, last_name, films_rating_g
SELECT "48) Para cada actor, películas con rating 'G' en su filmografía" AS '';
SELECT a.actor_id AS actor_id,
       a.first_name AS first_name,
       a.last_name  AS last_name,
       COUNT(f.film_id) AS films_rating_g
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film f ON f.film_id = fa.film_id
WHERE f.rating = 'G'
GROUP BY a.actor_id, a.first_name, a.last_name;

-- 49) Para cada tienda, clientes registrados con código postal no nulo (vía dirección de cliente).
-- Salida obligatoria (alias en orden): store_id, customers_with_postalcode
SELECT "49) Para cada tienda, clientes registrados con código postal no nulo (vía dirección de cliente)" AS '';
SELECT st.store_id AS store_id,
       COUNT(c.customer_id) AS customers_with_postalcode
FROM store st
JOIN customer c ON c.store_id = st.store_id
JOIN address a ON a.address_id = c.address_id
WHERE a.postal_code IS NOT NULL
GROUP BY st.store_id;

-- 50) Para cada categoría, películas cuyo título empieza por 'A'.
-- Salida obligatoria (alias en orden): category_id, category_name, films_title_start_a
SELECT "50) Para cada categoría, películas cuyo título empieza por 'A'" AS '';
SELECT c.category_id AS category_id,
       c.name AS category_name,
       COUNT(f.film_id) AS films_title_start_a
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
WHERE UPPER(f.title) LIKE 'A%'
GROUP BY c.category_id, c.name;

-- 51) Para cada actor, películas con título de más de 15 caracteres.
-- Salida obligatoria (alias en orden): actor_id, first_name, last_name, films_title_len_gt15
SELECT "51) Para cada actor, películas con título de más de 15 caracteres" AS '';
SELECT a.actor_id AS actor_id,
       a.first_name AS first_name,
       a.last_name  AS last_name,
       COUNT(f.film_id) AS films_title_len_gt15
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film f ON f.film_id = fa.film_id
WHERE LENGTH(f.title) > 15
GROUP BY a.actor_id, a.first_name, a.last_name;

-- 52) Para cada ciudad, clientes con apellidos de > 8 caracteres.
-- Salida obligatoria (alias en orden): city_id, city_name, customers_lastname_gt8
SELECT "52) Para cada ciudad, clientes con apellidos de > 8 caracteres" AS '';
SELECT ci.city_id AS city_id,
       ci.city AS city_name,
       COUNT(c.customer_id) AS customers_lastname_gt8
FROM city ci
JOIN address a ON a.city_id = ci.city_id
JOIN customer c ON c.address_id = a.address_id
WHERE LENGTH(c.last_name) > 8
GROUP BY ci.city_id, ci.city;

-- 53) Para cada cliente, alquileres entre 10:00 y 12:00.
-- Salida obligatoria (alias en orden): customer_id, first_name, last_name, rentals_10_12
SELECT "53) Para cada cliente, alquileres entre 10:00 y 12:00" AS '';
SELECT c.customer_id AS customer_id,
       c.first_name AS first_name,
       c.last_name  AS last_name,
       COUNT(r.rental_id) AS rentals_10_12
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
JOIN inventory i ON i.inventory_id = r.inventory_id
WHERE TIME(r.rental_date) >= '10:00:00' AND TIME(r.rental_date) < '12:00:00'
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 54) Para cada categoría, media de length de películas con rating 'PG-13'.
-- Salida obligatoria (alias en orden): category_id, category_name, avg_length_pg13
SELECT "54) Para cada categoría, media de length de películas con rating 'PG-13'" AS '';
SELECT c.category_id AS category_id,
       c.name AS category_name,
       AVG(f.length) AS avg_length_pg13
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
WHERE f.rating = 'PG-13'
GROUP BY c.category_id, c.name;

-- 55) Para cada película, alquileres realizados en viernes (DAYOFWEEK=6).
-- Salida obligatoria (alias en orden): film_id, title, friday_rentals
SELECT "55) Para cada película, alquileres realizados en viernes (DAYOFWEEK=6)" AS '';
SELECT f.film_id AS film_id,
       f.title AS title,
       COUNT(r.rental_id) AS friday_rentals
FROM film f
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE DAYOFWEEK(r.rental_date) = 6
GROUP BY f.film_id, f.title;

-- 56) Para cada tienda, clientes por empleado (conteo de clientes asociados a la tienda de ese empleado).
-- Salida obligatoria (alias en orden): staff_id, first_name, last_name, customers_in_staff_store
SELECT "56) Para cada tienda, clientes por empleado (conteo de clientes asociados a la tienda de ese empleado)" AS '';
SELECT s.staff_id AS staff_id,
       s.first_name AS first_name,
       s.last_name  AS last_name,
       COUNT(c.customer_id) AS customers_in_staff_store
FROM staff s
JOIN store st ON st.store_id = s.store_id
JOIN customer c ON c.store_id = st.store_id
GROUP BY s.staff_id, s.first_name, s.last_name;

-- 57) Para cada idioma, películas cuyo título termina en 'S'.
-- Salida obligatoria (alias en orden): language_id, language_name, films_title_end_s
SELECT "57) Para cada idioma, películas cuyo título termina en 'S'" AS '';
SELECT l.language_id AS language_id,
       l.name AS language_name,
       COUNT(f.film_id) AS films_title_end_s
FROM language l
JOIN film f ON f.language_id = l.language_id
JOIN inventory i ON i.film_id = f.film_id
WHERE UPPER(f.title) LIKE '%S'
GROUP BY l.language_id, l.name;

-- 58) Para cada ciudad, clientes inactivos (active=0) residentes en ella.
-- Salida obligatoria (alias en orden): city_id, city_name, inactive_customers_in_city
SELECT "58) Para cada ciudad, clientes inactivos (active=0) residentes en ella" AS '';
SELECT ci.city_id AS city_id,
       ci.city AS city_name,
       COUNT(c.customer_id) AS inactive_customers_in_city
FROM city ci
JOIN address a ON a.city_id = ci.city_id
JOIN customer c ON c.address_id = a.address_id
WHERE c.active = 0
GROUP BY ci.city_id, ci.city;

-- 59) Para cada categoría, suma de rental_rate de sus películas.
-- Salida obligatoria (alias en orden): category_id, category_name, sum_rental_rate
SELECT "59) Para cada categoría, suma de rental_rate de sus películas" AS '';
SELECT c.category_id AS category_id,
       c.name AS category_name,
       SUM(f.rental_rate) AS sum_rental_rate
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
GROUP BY c.category_id, c.name;

-- 60) Para cada empleado, media de importes procesados en meses pares de 2005.
-- Salida obligatoria (alias en orden): staff_id, first_name, last_name, avg_amount_even_months_2005
SELECT "60) Para cada empleado, media de importes procesados en meses pares de 2005" AS '';
SELECT s.staff_id AS staff_id,
       s.first_name AS first_name,
       s.last_name  AS last_name,
       AVG(p.amount) AS avg_amount_even_months_2005
FROM staff s
JOIN payment p ON p.staff_id = s.staff_id
JOIN customer c ON c.customer_id = p.customer_id
WHERE YEAR(p.payment_date) = 2005 AND MOD(MONTH(p.payment_date), 2) = 0
GROUP BY s.staff_id, s.first_name, s.last_name;

-- ==============================================
-- SECCIÓN G) 20 CONSULTAS (JOIN DE EXACTAMENTE 4 TABLAS)
-- ==============================================

-- 61) Para cada país, suma de importes de pagos en 2005.
-- Salida obligatoria (alias en orden): country_id, country_name, total_amount_2005
SELECT "61) Para cada país, suma de importes de pagos en 2005" AS '';
SELECT co.country_id AS country_id,
       co.country AS country_name,
       SUM(p.amount) AS total_amount_2005
FROM country co
JOIN city ci ON ci.country_id = co.country_id
JOIN address a ON a.city_id = ci.city_id
JOIN customer c ON c.address_id = a.address_id
JOIN payment p ON p.customer_id = c.customer_id
WHERE YEAR(p.payment_date) = 2005
GROUP BY co.country_id, co.country;

-- 62) Para cada país, clientes que realizaron alquiler en 2006 (distintos).
-- Salida obligatoria (alias en orden): country_id, country_name, customers_with_rentals_2006
SELECT "62) Para cada país, clientes que realizaron alquiler en 2006 (distintos)" AS '';
SELECT co.country_id AS country_id,
       co.country AS country_name,
       COUNT(DISTINCT c.customer_id) AS customers_with_rentals_2006
FROM country co
JOIN city ci ON ci.country_id = co.country_id
JOIN address a ON a.city_id = ci.city_id
JOIN customer c ON c.address_id = a.address_id
JOIN rental r ON r.customer_id = c.customer_id
WHERE YEAR(r.rental_date) = 2006
GROUP BY co.country_id, co.country;

-- 63) Para cada tienda, total cobrado por trimestre de 2006.
-- Salida obligatoria (alias en orden): store_id, quarter_2006, total_amount_quarter
SELECT "63) Para cada tienda, total cobrado por trimestre de 2006" AS '';
SELECT st.store_id AS store_id,
       QUARTER(p.payment_date) AS quarter_2006,
       SUM(p.amount) AS total_amount_quarter
FROM store st
JOIN staff s ON s.store_id = st.store_id
JOIN payment p ON p.staff_id = s.staff_id
JOIN customer c ON c.customer_id = p.customer_id
WHERE YEAR(p.payment_date) = 2006
GROUP BY st.store_id, QUARTER(p.payment_date);

-- 64) Para cada categoría, alquileres por tienda.
-- Salida obligatoria (alias en orden): category_id, category_name, store_id, rentals_count
SELECT "64) Para cada categoría, alquileres por tienda" AS '';
SELECT c.category_id AS category_id,
       c.name AS category_name,
       st.store_id AS store_id,
       COUNT(r.rental_id) AS rentals_count
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN inventory i ON i.film_id = fc.film_id
JOIN store st ON st.store_id = i.store_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY c.category_id, c.name, st.store_id;

-- 65) Para cada actor, clientes distintos que alquilaron sus películas.
-- Salida obligatoria (alias en orden): actor_id, first_name, last_name, distinct_customers_for_actor
SELECT "65) Para cada actor, clientes distintos que alquilaron sus películas" AS '';
SELECT a.actor_id AS actor_id,
       a.first_name AS first_name,
       a.last_name  AS last_name,
       COUNT(DISTINCT r.customer_id) AS distinct_customers_for_actor
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN inventory i ON i.film_id = fa.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY a.actor_id, a.first_name, a.last_name;

-- 66) Para cada categoría, suma de replacement_cost de películas alquiladas.
-- Salida obligatoria (alias en orden): category_id, category_name, total_replacement_rented
SELECT "66) Para cada categoría, suma de replacement_cost de películas alquiladas" AS '';
SELECT c.category_id AS category_id,
       c.name AS category_name,
       SUM(f.replacement_cost) AS total_replacement_rented
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY c.category_id, c.name;

-- 67) Para cada país, alquileres de películas con rating 'R'.
-- Salida obligatoria (alias en orden): country_id, country_name, rentals_rating_r
SELECT "67) Para cada país, alquileres de películas con rating 'R'" AS '';
SELECT co.country_id AS country_id,
       co.country AS country_name,
       COUNT(r.rental_id) AS rentals_rating_r
FROM country co
JOIN city ci ON ci.country_id = co.country_id
JOIN address a ON a.city_id = ci.city_id
JOIN customer c ON c.address_id = a.address_id
JOIN rental r ON r.customer_id = c.customer_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON f.film_id = i.film_id
WHERE f.rating = 'R'
GROUP BY co.country_id, co.country;

-- 68) Para cada tienda, categorías distintas alquiladas en 2005.
-- Salida obligatoria (alias en orden): store_id, distinct_categories_rented_2005
SELECT "68) Para cada tienda, categorías distintas alquiladas en 2005" AS '';
SELECT st.store_id AS store_id,
       COUNT(DISTINCT fc.category_id) AS distinct_categories_rented_2005
FROM store st
JOIN inventory i ON i.store_id = st.store_id
JOIN rental r ON r.inventory_id = i.inventory_id
JOIN film_category fc ON fc.film_id = i.film_id
WHERE YEAR(r.rental_date) = 2005
GROUP BY st.store_id;

-- 69) Para cada país, máximo importe de un pago de sus clientes.
-- Salida obligatoria (alias en orden): country_id, country_name, max_single_payment
SELECT "69) Para cada país, máximo importe de un pago de sus clientes" AS '';
SELECT co.country_id AS country_id,
       co.country AS country_name,
       MAX(p.amount) AS max_single_payment
FROM country co
JOIN city ci ON ci.country_id = co.country_id
JOIN address a ON a.city_id = ci.city_id
JOIN customer c ON c.address_id = a.address_id
JOIN payment p ON p.customer_id = c.customer_id
GROUP BY co.country_id, co.country;

-- 70) Para cada actor, tiendas distintas en las que se alquilaron sus películas en 2005 y 2006.
-- Salida obligatoria (alias en orden): actor_id, first_name, last_name, distinct_stores_2005_2006
SELECT "70) Para cada actor, tiendas distintas en las que se alquilaron sus películas en 2005 y 2006" AS '';
SELECT a.actor_id AS actor_id,
       a.first_name AS first_name,
       a.last_name  AS last_name,
       COUNT(DISTINCT i.store_id) AS distinct_stores_2005_2006
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN inventory i ON i.film_id = fa.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE YEAR(r.rental_date) IN (2005, 2006)
GROUP BY a.actor_id, a.first_name, a.last_name;

-- 71) Para cada tienda, media de length de películas alquiladas por mes.
-- Salida obligatoria (alias en orden): store_id, rental_month, avg_length_by_month
SELECT "71) Para cada tienda, media de length de películas alquiladas por mes" AS '';
SELECT st.store_id AS store_id,
       MONTH(r.rental_date) AS rental_month,
       AVG(f.length) AS avg_length_by_month
FROM store st
JOIN inventory i ON i.store_id = st.store_id
JOIN rental r ON r.inventory_id = i.inventory_id
JOIN film f ON f.film_id = i.film_id
GROUP BY st.store_id, MONTH(r.rental_date);

-- 72) Para cada categoría, alquileres iniciados entre 18:00 y 23:59.
-- Salida obligatoria (alias en orden): category_id, category_name, evening_rentals
SELECT "72) Para cada categoría, alquileres iniciados entre 18:00 y 23:59" AS '';
SELECT c.category_id AS category_id,
       c.name AS category_name,
       COUNT(r.rental_id) AS evening_rentals
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN inventory i ON i.film_id = fc.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE TIME(r.rental_date) >= '18:00:00'
GROUP BY c.category_id, c.name;

-- 73) Para cada categoría, clientes distintos que alquilaron películas con 'LIFE' en el título.
-- Salida obligatoria (alias en orden): category_id, category_name, distinct_customers_life
SELECT "73) Para cada categoría, clientes distintos que alquilaron películas con 'LIFE' en el título" AS '';
SELECT c.category_id AS category_id,
       c.name AS category_name,
       COUNT(DISTINCT r.customer_id) AS distinct_customers_life
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE UPPER(f.title) LIKE '%LIFE%'
GROUP BY c.category_id, c.name;

-- 74) Para cada país, clientes con más de 20 alquileres (conteo sobre filas y filtro por HAVING).
-- Salida obligatoria (alias en orden): country_id, country_name, customers_20plus_rentals
SELECT "74) Para cada país, clientes con más de 20 alquileres (conteo sobre filas y filtro por HAVING)" AS '';
SELECT co.country_id AS country_id,
       co.country AS country_name,
       COUNT(DISTINCT c.customer_id) AS customers_20plus_rentals
FROM country co
JOIN city ci ON ci.country_id = co.country_id
JOIN address a ON a.city_id = ci.city_id
JOIN customer c ON c.address_id = a.address_id
JOIN rental r ON r.customer_id = c.customer_id
GROUP BY co.country_id, co.country
HAVING COUNT(r.rental_id) > 20;

-- 75) Para cada país, media de importe por pago en 2006 (2 decimales).
-- Salida obligatoria (alias en orden): country_id, country_name, avg_payment_2d_2006
SELECT "75) Para cada país, media de importe por pago en 2006 (2 decimales)" AS '';
SELECT co.country_id AS country_id,
       co.country AS country_name,
       ROUND(AVG(p.amount), 2) AS avg_payment_2d_2006
FROM country co
JOIN city ci ON ci.country_id = co.country_id
JOIN address a ON a.city_id = ci.city_id
JOIN customer c ON c.address_id = a.address_id
JOIN payment p ON p.customer_id = c.customer_id
WHERE YEAR(p.payment_date) = 2006
GROUP BY co.country_id, co.country;

-- 76) Para cada tienda, importes de pagos de clientes cuyo apellido empieza por 'S'.
-- Salida obligatoria (alias en orden): store_id, total_amount_customers_lastname_s
SELECT "76) Para cada tienda, importes de pagos de clientes cuyo apellido empieza por 'S'" AS '';
SELECT st.store_id AS store_id,
       SUM(p.amount) AS total_amount_customers_lastname_s
FROM store st
JOIN staff s ON s.store_id = st.store_id
JOIN payment p ON p.staff_id = s.staff_id
JOIN customer c ON c.customer_id = p.customer_id
WHERE UPPER(c.last_name) LIKE 'S%'
GROUP BY st.store_id;

-- 77) Para cada idioma, clientes distintos que alquilaron películas de ese idioma.
-- Salida obligatoria (alias en orden): language_id, language_name, distinct_customers_language
SELECT "77) Para cada idioma, clientes distintos que alquilaron películas de ese idioma" AS '';
SELECT l.language_id AS language_id,
       l.name AS language_name,
       COUNT(DISTINCT r.customer_id) AS distinct_customers_language
FROM language l
JOIN film f ON f.language_id = l.language_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY l.language_id, l.name;

-- 78) Para cada categoría, máximo de días de alquiler observado.
-- Salida obligatoria (alias en orden): category_id, category_name, max_days_rented
SELECT "78) Para cada categoría, máximo de días de alquiler observado" AS '';
SELECT c.category_id AS category_id,
       c.name AS category_name,
       MAX(DATEDIFF(r.return_date, r.rental_date)) AS max_days_rented
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN inventory i ON i.film_id = fc.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY c.category_id, c.name;

-- 79) Para cada país, películas distintas alquiladas por sus clientes.
-- Salida obligatoria (alias en orden): country_id, country_name, distinct_films_rented
SELECT "79) Para cada país, películas distintas alquiladas por sus clientes" AS '';
SELECT co.country_id AS country_id,
       co.country AS country_name,
       COUNT(DISTINCT i.film_id) AS distinct_films_rented
FROM country co
JOIN city ci ON ci.country_id = co.country_id
JOIN address a ON a.city_id = ci.city_id
JOIN customer c ON c.address_id = a.address_id
JOIN rental r ON r.customer_id = c.customer_id
JOIN inventory i ON i.inventory_id = r.inventory_id
GROUP BY co.country_id, co.country;

-- 80) Para cada tienda, clientes que realizaron algún pago > 50 (distintos).
-- Salida obligatoria (alias en orden): store_id, customers_with_payment_gt50
SELECT "80) Para cada tienda, clientes que realizaron algún pago > 50 (distintos)" AS '';
SELECT st.store_id AS store_id,
       COUNT(DISTINCT p.customer_id) AS customers_with_payment_gt50
FROM store st
JOIN staff s ON s.store_id = st.store_id
JOIN payment p ON p.staff_id = s.staff_id
JOIN customer c ON c.customer_id = p.customer_id
WHERE p.amount > 50
GROUP BY st.store_id;

-- ==============================================
-- SECCIÓN H) 20 CONSULTAS EXTRA (DIFICULTAD +, <=4 JOINS)
-- ==============================================

-- 81) Para cada cliente, días entre primer y último pago de 2006 (clientes con >=8 pagos ese año).
-- Salida obligatoria (alias en orden): customer_id, first_name, last_name, days_between_first_last_payment_2006
SELECT "81) Para cada cliente, días entre primer y último pago de 2006 (clientes con >=8 pagos ese año)" AS '';
SELECT c.customer_id AS customer_id,
       c.first_name AS first_name,
       c.last_name  AS last_name,
       DATEDIFF(MAX(p.payment_date), MIN(p.payment_date)) AS days_between_first_last_payment_2006
FROM customer c
JOIN payment p ON p.customer_id = c.customer_id
WHERE YEAR(p.payment_date) = 2006
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(p.payment_id) >= 8;

-- 82) Para cada actor, clientes distintos que alquilaron películas con título que comience por 'A' o 'B'.
-- Salida obligatoria (alias en orden): actor_id, first_name, last_name, distinct_customers_titles_ab
SELECT "82) Para cada actor, clientes distintos que alquilaron películas con título que comience por 'A' o 'B'" AS '';
SELECT a.actor_id AS actor_id,
       a.first_name AS first_name,
       a.last_name  AS last_name,
       COUNT(DISTINCT r.customer_id) AS distinct_customers_titles_ab
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN inventory i ON i.film_id = fa.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
JOIN film f ON f.film_id = i.film_id
WHERE UPPER(f.title) REGEXP '^[AB]'
GROUP BY a.actor_id, a.first_name, a.last_name;

-- 83) Para cada categoría, alquileres devueltos el mismo día.
-- Salida obligatoria (alias en orden): category_id, category_name, same_day_returns
SELECT "83) Para cada categoría, alquileres devueltos el mismo día" AS '';
SELECT c.category_id AS category_id,
       c.name AS category_name,
       COUNT(r.rental_id) AS same_day_returns
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN inventory i ON i.film_id = fc.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE DATE(r.rental_date) = DATE(r.return_date)
GROUP BY c.category_id, c.name;

-- 84) Para cada tienda, media de importe de pagos de clientes con first_name de 4 letras.
-- Salida obligatoria (alias en orden): store_id, avg_amount_firstname_len4
SELECT "84) Para cada tienda, media de importe de pagos de clientes con first_name de 4 letras" AS '';
SELECT st.store_id AS store_id,
       AVG(p.amount) AS avg_amount_firstname_len4
FROM store st
JOIN staff s ON s.store_id = st.store_id
JOIN payment p ON p.staff_id = s.staff_id
JOIN customer c ON c.customer_id = p.customer_id
WHERE LENGTH(c.first_name) = 4
GROUP BY st.store_id;

-- 85) Para cada idioma, alquileres de películas con título de longitud par.
-- Salida obligatoria (alias en orden): language_id, language_name, rentals_even_title_len
SELECT "85) Para cada idioma, alquileres de películas con título de longitud par" AS '';
SELECT l.language_id AS language_id,
       l.name AS language_name,
       COUNT(r.rental_id) AS rentals_even_title_len
FROM language l
JOIN film f ON f.language_id = l.language_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE MOD(LENGTH(f.title), 2) = 0
GROUP BY l.language_id, l.name;

-- 86) Para cada país, media de length de películas alquiladas por sus clientes en 2006.
-- Salida obligatoria (alias en orden): country_id, country_name, avg_length_rented_2006
SELECT "86) Para cada país, media de length de películas alquiladas por sus clientes en 2006" AS '';
SELECT co.country_id AS country_id,
       co.country AS country_name,
       AVG(f.length) AS avg_length_rented_2006
FROM country co
JOIN city ci ON ci.country_id = co.country_id
JOIN address a ON a.city_id = ci.city_id
JOIN customer c ON c.address_id = a.address_id
JOIN rental r ON r.customer_id = c.customer_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON f.film_id = i.film_id
WHERE YEAR(r.rental_date) = 2006
GROUP BY co.country_id, co.country;

-- 87) Para cada cliente, categorías distintas en las que alquiló durante 2006.
-- Salida obligatoria (alias en orden): customer_id, first_name, last_name, distinct_categories_2006
SELECT "87) Para cada cliente, categorías distintas en las que alquiló durante 2006" AS '';
SELECT c.customer_id AS customer_id,
       c.first_name AS first_name,
       c.last_name  AS last_name,
       COUNT(DISTINCT fc.category_id) AS distinct_categories_2006
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film_category fc ON fc.film_id = i.film_id
WHERE YEAR(r.rental_date) = 2006
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 88) Para cada empleado, meses distintos con pagos procesados (YYYY-MM).
-- Salida obligatoria (alias en orden): staff_id, first_name, last_name, distinct_year_months
SELECT "88) Para cada empleado, meses distintos con pagos procesados (YYYY-MM)" AS '';
SELECT s.staff_id AS staff_id,
       s.first_name AS first_name,
       s.last_name  AS last_name,
       COUNT(DISTINCT CONCAT(YEAR(p.payment_date), '-', LPAD(MONTH(p.payment_date),2,'0'))) AS distinct_year_months
FROM staff s
JOIN payment p ON p.staff_id = s.staff_id
JOIN customer c ON c.customer_id = p.customer_id
GROUP BY s.staff_id, s.first_name, s.last_name;

-- 89) Para cada categoría, alquileres cuyo pago asociado (payment.amount) sea >= 5.
-- Salida obligatoria (alias en orden): category_id, category_name, rentals_amount_ge_5
SELECT "89) Para cada categoría, alquileres cuyo pago asociado (payment.amount) sea >= 5" AS '';
SELECT c.category_id AS category_id,
       c.name AS category_name,
       COUNT(r.rental_id) AS rentals_amount_ge_5
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN inventory i ON i.film_id = fc.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
JOIN payment p ON p.rental_id = r.rental_id
WHERE p.amount >= 5
GROUP BY c.category_id, c.name;

-- 90) Para cada idioma, actores con apellido de longitud 5 en películas de ese idioma.
-- Salida obligatoria (alias en orden): language_id, language_name, actors_lastname_len5
SELECT "90) Para cada idioma, actores con apellido de longitud 5 en películas de ese idioma" AS '';
SELECT l.language_id AS language_id,
       l.name AS language_name,
       COUNT(DISTINCT a.actor_id) AS actors_lastname_len5
FROM language l
JOIN film f ON f.language_id = l.language_id
JOIN film_actor fa ON fa.film_id = f.film_id
JOIN actor a ON a.actor_id = fa.actor_id
WHERE LENGTH(a.last_name) = 5
GROUP BY l.language_id, l.name;

-- 91) Para cada tienda, clientes distintos que alquilaron los lunes (DAYOFWEEK=2).
-- Salida obligatoria (alias en orden): store_id, distinct_customers_monday
SELECT "91) Para cada tienda, clientes distintos que alquilaron los lunes (DAYOFWEEK=2)" AS '';
SELECT st.store_id AS store_id,
       COUNT(DISTINCT r.customer_id) AS distinct_customers_monday
FROM store st
JOIN inventory i ON i.store_id = st.store_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE DAYOFWEEK(r.rental_date) = 2
GROUP BY st.store_id;

-- 92) Para cada país, clientes con apellidos que terminan en 'EZ'.
-- Salida obligatoria (alias en orden): country_id, country_name, customers_lastname_end_ez
SELECT "92) Para cada país, clientes con apellidos que terminan en 'EZ'" AS '';
SELECT co.country_id AS country_id,
       co.country AS country_name,
       COUNT(c.customer_id) AS customers_lastname_end_ez
FROM country co
JOIN city ci ON ci.country_id = co.country_id
JOIN address a ON a.city_id = ci.city_id
JOIN customer c ON c.address_id = a.address_id
WHERE UPPER(c.last_name) LIKE '%EZ'
GROUP BY co.country_id, co.country;

-- 93) Para cada categoría, alquileres de 2006 cuyo título tenga exactamente 2 palabras.
-- Salida obligatoria (alias en orden): category_id, category_name, rentals_title_two_words_2006
SELECT "93) Para cada categoría, alquileres de 2006 cuyo título tenga exactamente 2 palabras" AS '';
SELECT c.category_id AS category_id,
       c.name AS category_name,
       COUNT(r.rental_id) AS rentals_title_two_words_2006
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE YEAR(r.rental_date) = 2006
  AND (LENGTH(f.title) - LENGTH(REPLACE(f.title, ' ', ''))) = 1
GROUP BY c.category_id, c.name;

-- 94) Para cada tienda, media de replacement_cost de películas alquiladas por trimestre.
-- Salida obligatoria (alias en orden): store_id, rental_quarter, avg_replacement_by_quarter
SELECT "94) Para cada tienda, media de replacement_cost de películas alquiladas por trimestre" AS '';
SELECT st.store_id AS store_id,
       QUARTER(r.rental_date) AS rental_quarter,
       AVG(f.replacement_cost) AS avg_replacement_by_quarter
FROM store st
JOIN inventory i ON i.store_id = st.store_id
JOIN rental r ON r.inventory_id = i.inventory_id
JOIN film f ON f.film_id = i.film_id
GROUP BY st.store_id, QUARTER(r.rental_date);

-- 95) Para cada categoría, inventarios disponibles (filas en inventory) asociados a películas de esa categoría.
-- Salida obligatoria (alias en orden): category_id, category_name, inventory_items_in_category
SELECT "95) Para cada categoría, inventarios disponibles (filas en inventory) asociados a películas de esa categoría" AS '';
SELECT c.category_id AS category_id,
       c.name AS category_name,
       COUNT(i.inventory_id) AS inventory_items_in_category
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN inventory i ON i.film_id = fc.film_id
GROUP BY c.category_id, c.name;

-- 96) Para cada idioma, pagos asociados a alquileres de películas en ese idioma.
-- Salida obligatoria (alias en orden): language_id, language_name, payments_for_language
SELECT "96) Para cada idioma, pagos asociados a alquileres de películas en ese idioma" AS '';
SELECT l.language_id AS language_id,
       l.name AS language_name,
       COUNT(p.payment_id) AS payments_for_language
FROM language l
JOIN film f ON f.language_id = l.language_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
JOIN payment p ON p.rental_id = r.rental_id
GROUP BY l.language_id, l.name;

-- 97) Para cada actor, media de importe cobrado en pagos vinculados a alquileres de sus películas.
-- Salida obligatoria (alias en orden): actor_id, first_name, last_name, avg_amount_for_actor
SELECT "97) Para cada actor, media de importe cobrado en pagos vinculados a alquileres de sus películas" AS '';
SELECT a.actor_id AS actor_id,
       a.first_name AS first_name,
       a.last_name  AS last_name,
       AVG(p.amount) AS avg_amount_for_actor
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN inventory i ON i.film_id = fa.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
JOIN payment p ON p.rental_id = r.rental_id
GROUP BY a.actor_id, a.first_name, a.last_name;

-- 98) Para cada país, alquileres iniciados en horario laboral (09:00–17:00).
-- Salida obligatoria (alias en orden): country_id, country_name, business_hour_rentals
SELECT "98) Para cada país, alquileres iniciados en horario laboral (09:00–17:00)" AS '';
SELECT co.country_id AS country_id,
       co.country AS country_name,
       COUNT(r.rental_id) AS business_hour_rentals
FROM country co
JOIN city ci ON ci.country_id = co.country_id
JOIN address a ON a.city_id = ci.city_id
JOIN customer c ON c.address_id = a.address_id
JOIN rental r ON r.customer_id = c.customer_id
WHERE TIME(r.rental_date) >= '09:00:00' AND TIME(r.rental_date) < '17:00:00'
GROUP BY co.country_id, co.country;

-- 99) Para cada tienda, clientes distintos que alquilaron películas con replacement_cost >= 25.
-- Salida obligatoria (alias en orden): store_id, distinct_customers_replacement_25plus
SELECT "99) Para cada tienda, clientes distintos que alquilaron películas con replacement_cost >= 25" AS '';
SELECT st.store_id AS store_id,
       COUNT(DISTINCT r.customer_id) AS distinct_customers_replacement_25plus
FROM store st
JOIN inventory i ON i.store_id = st.store_id
JOIN film f ON f.film_id = i.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE f.replacement_cost >= 25
GROUP BY st.store_id;

-- 100) Para cada idioma, número de actores distintos que participan en películas de ese idioma.
-- Salida obligatoria (alias en orden): language_id, language_name, distinct_actors_in_language
SELECT "100) Para cada idioma, número de actores distintos que participan en películas de ese idioma" AS '';
SELECT l.language_id AS language_id,
       l.name AS language_name,
       COUNT(DISTINCT fa.actor_id) AS distinct_actors_in_language
FROM language l
JOIN film f ON f.language_id = l.language_id
JOIN film_actor fa ON fa.film_id = f.film_id
GROUP BY l.language_id, l.name;
