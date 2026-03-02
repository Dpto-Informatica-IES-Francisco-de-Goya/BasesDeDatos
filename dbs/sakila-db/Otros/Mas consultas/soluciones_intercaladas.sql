-- Solución 1: Título de la película más larga por categoría
WITH max_lengths AS (
    SELECT fc.category_id, MAX(f.length) AS max_length
    FROM film f
    JOIN film_category fc ON f.film_id = fc.film_id
    GROUP BY fc.category_id
)
SELECT c.name AS category, f.title, f.length
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN max_lengths ml
  ON fc.category_id = ml.category_id
 AND f.length = ml.max_length
JOIN category c ON ml.category_id = c.category_id
ORDER BY c.name;

-- Solución 11: Recaudación mensual de cada categoría durante 2024
WITH monthly_sales AS (
    SELECT fc.category_id,
           MONTH(p.payment_date) AS month,
           SUM(p.amount) AS total
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film_category fc ON i.film_id = fc.film_id
    WHERE YEAR(p.payment_date) = 2024
    GROUP BY fc.category_id, MONTH(p.payment_date)
)
SELECT c.name AS category, ms.month, ms.total
FROM monthly_sales ms
JOIN category c ON ms.category_id = c.category_id
ORDER BY c.name, ms.month;

-- Query CASE 1: Clasificación de películas por duración
SELECT
  CASE
    WHEN f.length < 90 THEN 'Corto'
    WHEN f.length BETWEEN 90 AND 150 THEN 'Medio'
    ELSE 'Largo'
  END AS categoria,
  COUNT(*) AS num_peliculas,
  ROUND(AVG(f.length), 2) AS duracion_media
FROM film f
GROUP BY categoria
ORDER BY FIELD(categoria, 'Corto', 'Medio', 'Largo');

-- Solución 2: Cinco actores con más películas
SELECT a.actor_id, CONCAT(a.first_name, ' ', a.last_name) AS actor, COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, actor
ORDER BY film_count DESC
LIMIT 5;

-- Solución 12: Películas que nunca han sido alquiladas
SELECT f.film_id, f.title
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;

-- Query CASE 2: Clasificación de pagos por importe
SELECT
  CASE
    WHEN p.amount < 3.00 THEN 'Bajo'
    WHEN p.amount BETWEEN 3.00 AND 5.00 THEN 'Medio'
    ELSE 'Alto'
  END AS rango_pago,
  COUNT(*) AS num_pagos,
  ROUND(SUM(p.amount), 2) AS suma_importes
FROM payment p
GROUP BY rango_pago
ORDER BY FIELD(rango_pago, 'Bajo', 'Medio', 'Alto');

-- Solución 3: País con más clientes
SELECT co.country AS country, COUNT(cu.customer_id) AS num_customers
FROM customer cu
JOIN address ad ON cu.address_id = ad.address_id
JOIN city ci ON ad.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
GROUP BY co.country
ORDER BY num_customers DESC
LIMIT 1;

-- Solución 13: Clientes que han hecho alquileres pero no pagos
SELECT cu.customer_id, CONCAT(cu.first_name, ' ', cu.last_name) AS customer
FROM customer cu
WHERE EXISTS (
    SELECT 1 FROM rental r WHERE r.customer_id = cu.customer_id
)
AND NOT EXISTS (
    SELECT 1 FROM payment p WHERE p.customer_id = cu.customer_id
);

-- Query CASE 3: Clasificación de clientes por gasto total
WITH gasto_cliente AS (
  SELECT
    cu.customer_id,
    SUM(p.amount) AS total_gastado
  FROM customer cu
  JOIN payment p ON cu.customer_id = p.customer_id
  GROUP BY cu.customer_id
)
SELECT
  CASE
    WHEN gc.total_gastado > 100 THEN 'VIP'
    WHEN gc.total_gastado BETWEEN 50 AND 100 THEN 'Regular'
    ELSE 'Ocasional'
  END AS categoria_cliente,
  COUNT(*) AS num_clientes
FROM gasto_cliente gc
GROUP BY categoria_cliente
ORDER BY FIELD(categoria_cliente, 'VIP', 'Regular', 'Ocasional');

-- Solución 4: Tres películas con mayores ingresos por alquiler
SELECT f.film_id, f.title, SUM(p.amount) AS total_revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.film_id, f.title
ORDER BY total_revenue DESC
LIMIT 3;

-- Solución 14: Ingreso promedio por alquiler en cada tienda
SELECT s.store_id, AVG(p.amount) AS avg_revenue_per_rental
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store s ON i.store_id = s.store_id
GROUP BY s.store_id;

-- Query CASE 4: Alquileres gestionados por empleados específicos vs Otros
SELECT
  CONCAT(st.first_name, ' ', st.last_name) AS empleado,
  cnt.total_alquileres
FROM (
  SELECT staff_id, COUNT(*) AS total_alquileres
  FROM rental
  GROUP BY staff_id
) AS cnt
JOIN staff st ON cnt.staff_id = st.staff_id
WHERE cnt.staff_id IN (1, 2)

UNION ALL

SELECT
  'Otros' AS empleado,
  SUM(cnt.total_alquileres) AS total_alquileres
FROM (
  SELECT staff_id, COUNT(*) AS total_alquileres
  FROM rental
  GROUP BY staff_id
  HAVING staff_id NOT IN (1, 2)
) AS cnt;

-- Solución 5: Ventas totales por categoría ordenadas

SELECT c.category_id, c.name AS category, SUM(p.amount) AS total_sales
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.category_id, c.name
ORDER BY total_sales DESC;

-- Solución 15: Actores con al menos diez películas de categorías distintas
SELECT a.actor_id, CONCAT(a.first_name, ' ', a.last_name) AS actor
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film_category fc ON fa.film_id = fc.film_id
GROUP BY a.actor_id, actor
HAVING COUNT(DISTINCT fc.category_id) >= 10;

-- Query CASE 5: Porcentaje de copias disponibles por película
SELECT
  f.title,
  CASE
    WHEN tot.total = 0 THEN 0
    ELSE ROUND((stock.available * 100.0) / tot.total, 2)
  END AS pct_disponible
FROM film f
LEFT JOIN (
  SELECT film_id, COUNT(*) AS available
  FROM inventory
  WHERE inventory_in_stock(inventory_id)
  GROUP BY film_id
) AS stock ON f.film_id = stock.film_id
LEFT JOIN (
  SELECT film_id, COUNT(*) AS total
  FROM inventory
  GROUP BY film_id
) AS tot ON f.film_id = tot.film_id
ORDER BY pct_disponible DESC;

-- Solución 6: Tiendas con más stock disponible
SELECT s.store_id, COUNT(*) AS available_stock
FROM inventory i
JOIN store s ON i.store_id = s.store_id
WHERE inventory_in_stock(i.inventory_id)
GROUP BY s.store_id
ORDER BY available_stock DESC;

-- Solución 16: Cliente que más ha gastado por país
WITH country_spending AS (
    SELECT co.country_id, cu.customer_id, SUM(p.amount) AS spent
    FROM payment p
    JOIN customer cu ON p.customer_id = cu.customer_id
    JOIN address ad ON cu.address_id = ad.address_id
    JOIN city ci ON ad.city_id = ci.city_id
    JOIN country co ON ci.country_id = co.country_id
    GROUP BY co.country_id, cu.customer_id
),
max_spending AS (
    SELECT country_id, MAX(spent) AS max_spent
    FROM country_spending
    GROUP BY country_id
)
SELECT co.country, CONCAT(cu.first_name, ' ', cu.last_name) AS top_customer, ms.max_spent
FROM max_spending ms
JOIN country_spending cs
  ON ms.country_id = cs.country_id
 AND ms.max_spent = cs.spent
JOIN country co ON ms.country_id = co.country_id
JOIN customer cu ON cs.customer_id = cu.customer_id
ORDER BY co.country;

-- Solución 7: Número de actores que han trabajado en más de dos géneros
SELECT COUNT(*) AS num_actors
FROM (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN film_category fc ON fa.film_id = fc.film_id
    GROUP BY fa.actor_id
    HAVING COUNT(DISTINCT fc.category_id) > 2
) AS sub;

-- Solución 17: Diez películas con mayor diferencia entre coste de reposición y tarifa de alquiler
SELECT f.film_id, f.title, (f.replacement_cost - f.rental_rate) AS cost_diff
FROM film f
ORDER BY cost_diff DESC
LIMIT 10;

-- Solución 8: Películas con más de tres actores y duración menor a 90 minutos
SELECT f.film_id, f.title, COUNT(fa.actor_id) AS num_actors
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE f.length < 90
GROUP BY f.film_id, f.title
HAVING COUNT(fa.actor_id) > 3;

-- Solución 18: Número de películas por idioma original
SELECT ol.name AS original_language, COUNT(*) AS num_films
FROM film f
JOIN language ol ON f.original_language_id = ol.language_id
GROUP BY ol.name
ORDER BY num_films DESC;

-- Solución 9: Cliente que más ha gastado
SELECT cu.customer_id, CONCAT(cu.first_name, ' ', cu.last_name) AS customer, SUM(p.amount) AS total_spent
FROM customer cu
JOIN payment p ON cu.customer_id = p.customer_id
GROUP BY cu.customer_id, customer
ORDER BY total_spent DESC
LIMIT 1;

-- Solución 19: Ciudades distintas donde viven los clientes de cada empleado
SELECT st.staff_id, CONCAT(st.first_name, ' ', st.last_name) AS staff, COUNT(DISTINCT ci.city) AS num_cities
FROM staff st
JOIN rental r ON st.staff_id = r.staff_id
JOIN customer cu ON r.customer_id = cu.customer_id
JOIN address ad ON cu.address_id = ad.address_id
JOIN city ci ON ad.city_id = ci.city_id
GROUP BY st.staff_id, staff
ORDER BY num_cities DESC;

-- Solución 10: Número de películas no disponibles en ninguna tienda
SELECT COUNT(*) AS num_unavailable_films
FROM film f
WHERE NOT EXISTS (
    SELECT 1
    FROM inventory i
    WHERE i.film_id = f.film_id
      AND inventory_in_stock(i.inventory_id)
);

-- Solución 20: Categorías con ingresos superiores a la media global
WITH category_revenue AS (
    SELECT fc.category_id, SUM(p.amount) AS total_revenue
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film_category fc ON i.film_id = fc.film_id
    GROUP BY fc.category_id
),
avg_revenue AS (
    SELECT AVG(total_revenue) AS avg_rev FROM category_revenue
)
SELECT c.name AS category, cr.total_revenue
FROM category_revenue cr
JOIN avg_revenue av
  ON cr.total_revenue > av.avg_rev
JOIN category c ON cr.category_id = c.category_id
ORDER BY cr.total_revenue DESC;
