--- El enunciado es ambiguo. 
--- ¿Película se refiere a título o a copia del inventario?

--- Títulos que nunca se han alquilado.
SELECT film_id
FROM film
WHERE film_id NOT IN (
	SELECT film_id 
	FROM inventory
	JOIN rental using(inventory_id)
)

--- Copias físicas que no se han alquilado nunca (aunque
--- pueda haber otras copias de la misma peli sí alquiladas)
-- Solución 12: Películas que nunca han sido alquiladas
SELECT f.film_id, f.title
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;
