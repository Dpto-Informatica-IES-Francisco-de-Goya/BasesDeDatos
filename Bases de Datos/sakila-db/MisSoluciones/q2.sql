--- 2. Con un CTE, calcula la recaudación mensual de cada categoría durante 2024.

--- No hay datos para el año 2024, así que lo hago para el 2005.

WITH recaudacionmensual AS( 
	SELECT 
		rental_id, MONTH(payment_date) as month, sum(amount) as pretotal 
	FROM payment  
	WHERE  YEAR(payment_date) = 2005
	GROUP BY rental_id,MONTH(payment_date) 
), 
categoryRental AS( 
	SELECT 
		rental.rental_id, 
		inventory.film_id, 
		category.name 
	FROM film_category 
	JOIN inventory 
		ON film_category.film_id = inventory.film_id 
	JOIN category 
		USING(category_id) 
	JOIN rental
		USING(inventory_id)
) 
SELECT  
	recaudacionmensual.month, 
	categoryRental.name ,
	sum(recaudacionmensual.pretotal) as sum
FROM categoryRental 
JOIN recaudacionmensual 
	USING(rental_id) 
GROUP BY 
	recaudacionmensual.month,
	categoryRental.name
ORDER BY sum DESC;

--- ChatGPT sugiere filtrar por fechas y no por YEAR(fecha) para poder aprovechar índices.
/**
 *
 *   WHERE p.payment_date >= '2005-01-01'
    	AND p.payment_date <  '2006-01-01' 
 * 
 * 	mejor que 
 * 		WHERE
 **/