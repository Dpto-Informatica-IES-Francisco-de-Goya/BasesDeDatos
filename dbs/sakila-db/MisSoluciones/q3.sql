SELECT 
	category.name AS Categoria,
	Duracion,
	count(film_id) AS NumPelis,
	AVG(length) AS DuracionMedia
FROM
	(SELECT 
		CASE 
			WHEN length < 90 THEN 'Corto'
			WHEN length < 150 THEN 'Medio'
			ELSE 'Largo' END 
		AS Duracion,
		film_id,
		length
	FROM film)
AS newfilm
JOIN film_category USING(film_id)
JOIN category USING(category_id)
GROUP BY category.name,Duracion
ORDER BY 
	Categoria,
	CASE Duracion WHEN 'Corto' THEN 1 WHEN 'Medio' THEN 2 ELSE 3 END;