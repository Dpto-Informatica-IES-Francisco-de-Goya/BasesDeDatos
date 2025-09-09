SELECT
	category_id, 
	clasificacion, 
	count(payment_id) as numPagos,
	sum(amount) as total
FROM (
	SELECT
		payment.payment_id,
		amount,
		film_category.category_id,
		CASE WHEN amount <3 THEN 'Bajo'
			WHEN amount <5 THEN 'Medio'
			ELSE 'Alto' END as clasificacion
	FROM payment
	JOIN rental USING(rental_id)
	JOIN inventory USING (inventory_id)
	JOIN film_category USING (film_id)
) AS subq
GROUP BY clasificacion,category_id


--- ¿Y esto funciona? ¡Sí!

SELECT
	film_category.category_id,
	CASE WHEN amount <3 THEN 'Bajo'
		WHEN amount <5 THEN 'Medio'
		ELSE 'Alto' END as clasificacion, 
	count(payment_id) as numPagos,
	sum(amount) as total		
FROM payment
JOIN rental USING(rental_id)
JOIN inventory USING (inventory_id)
JOIN film_category USING (film_id)
GROUP BY clasificacion,film_category.category_id