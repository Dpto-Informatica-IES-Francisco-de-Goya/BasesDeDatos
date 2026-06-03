-- Recuperación Ordinaria RA3 DAM/DAW - Consultas SQL
-- Base de datos: Sakila

-- Consulta 1 [RA3-CE.e]
-- Clientes con más de 40 alquileres.
SELECT "Clientes con más de 40 alquileres." AS "";
SELECT r.customer_id, COUNT(r.rental_id) AS num_alquileres
FROM rental r
GROUP BY r.customer_id
HAVING num_alquileres > 40
ORDER BY num_alquileres DESC
LIMIT 5;

-- Consulta 2 [RA3-CE.c]
-- Película, idioma y categoría (4 tablas).
SELECT "Película, idioma y categoría (4 tablas)." AS "";
SELECT f.title, l.name AS idioma, c.name AS categoria
FROM film f
JOIN language l ON f.language_id = l.language_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
LIMIT 5;

-- Consulta 3 [RA3-CE.d]
-- Número de categorías distintas por idioma (incluyendo idiomas sin películas → 0).
SELECT "Número de categorías distintas por idioma (incluyendo idiomas sin películas)." AS "";
-- Solución con LEFT JOIN:
SELECT l.name AS idioma,
       COUNT(DISTINCT c.category_id) AS num_categorias
FROM language l
LEFT JOIN film f        ON l.language_id  = f.language_id
LEFT JOIN film_category fc ON f.film_id   = fc.film_id
LEFT JOIN category c   ON fc.category_id  = c.category_id
GROUP BY l.language_id, l.name
ORDER BY l.name;
-- Solución equivalente con RIGHT JOIN (partiendo desde film):
-- SELECT l.name AS idioma,
--        COUNT(DISTINCT c.category_id) AS num_categorias
-- FROM film f
-- LEFT JOIN film_category fc ON f.film_id      = fc.film_id
-- LEFT JOIN category c       ON fc.category_id = c.category_id
-- RIGHT JOIN language l      ON f.language_id  = l.language_id
-- GROUP BY l.language_id, l.name
-- ORDER BY l.name;

-- Consulta 4 [RA3-CE.f]
-- Pagos cuyo importe sea estrictamente superior a la media de todos los pagos registrados.
SELECT "Pagos cuyo importe sea estrictamente superior a la media de todos los pagos registrados." AS "";
SELECT payment_id, amount 
FROM payment 
WHERE amount > (SELECT AVG(amount) FROM payment);

