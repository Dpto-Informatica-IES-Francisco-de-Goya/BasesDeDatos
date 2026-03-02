USE sakila;
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



-- Solución 13: Clientes que han hecho alquileres pero no pagos
SELECT cu.customer_id, CONCAT(cu.first_name, ' ', cu.last_name) AS customer
FROM customer cu
WHERE EXISTS (
    SELECT 1 FROM rental r WHERE r.customer_id = cu.customer_id
)
AND NOT EXISTS (
    SELECT 1 FROM payment p WHERE p.customer_id = cu.customer_id
);

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
