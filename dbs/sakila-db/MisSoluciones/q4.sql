WITH numpelis AS(
	SELECT actor_id, count(film_id) as Numero_Peliculas
	FROM film_actor
	GROUP BY actor_id
	ORDER BY count(film_id) DESC
	LIMIT 5)
SELECT first_name, last_name, Numero_Peliculas
FROM actor 
JOIN numpelis USING(actor_id);