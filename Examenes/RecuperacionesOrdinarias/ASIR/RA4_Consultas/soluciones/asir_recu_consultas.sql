-- Recuperación Ordinaria RA4 ASIR - Consultas SQL
-- Base de datos: Sakila

-- Consulta 1 [RA4-CE.c]
-- Actores con más de 35 películas.
SELECT "Actores con más de 35 películas." AS "";
SELECT actor_id, COUNT(film_id) AS total_peliculas
FROM film_actor
GROUP BY actor_id
HAVING total_peliculas > 35
ORDER BY total_peliculas DESC
LIMIT 5;

-- Consulta 2 [RA4-CE.d]
-- Clientes con dirección, ciudad y país.
SELECT "Clientes con dirección, ciudad y país."AS "";
SELECT c.first_name, c.last_name, a.address, ci.city, co.country
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
ORDER BY co.country, ci.city
LIMIT 5;

-- Consulta 3 [RA4-CE.e]
-- Todas las categorías y sus películas (incluyendo categorías vacías).
SELECT "Todas las categorías y sus películas (incluyendo categorías vacías)."AS "";
SELECT c.name AS categoria, f.title
FROM category c
LEFT JOIN film_category fc ON c.category_id = fc.category_id
LEFT JOIN film f ON fc.film_id = f.film_id
LIMIT 5;

-- Consulta 4 [RA4-CE.f]
-- Películas con duración superior a la media global.
SELECT "Películas con duración superior a la media global."AS "";
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film)
LIMIT 5;
