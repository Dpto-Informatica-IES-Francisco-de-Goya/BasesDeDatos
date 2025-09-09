---1. ¿Cuál es el título de la película más larga por cada categoría de películas?

SELECT 
	m.category, 
	f.title,
	f.length 
FROM film_list as f 
JOIN (
		SELECT
			category,
			max(length) as max 
		FROM film_list 
		GROUP BY category) as m
ON f.length=m.max 
	AND f.category=m.category;