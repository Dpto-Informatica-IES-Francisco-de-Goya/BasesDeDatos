# Enunciados intercalados de las consultas SQL

1. ¿Cuál es el título de la película más larga por cada categoría de películas?
2. Con un CTE, calcula la recaudación mensual de cada categoría durante 2024.
3. Clasifica las películas en 'Corto' (< 90 min), 'Medio' (90–150 min) y 'Largo' (> 150 min). Muestra el número de películas y la duración media para cada categoría.
4. ¿Cuáles son los 5 actores que han participado en más películas, y cuántas películas tiene cada uno?
5. Identifica todas las películas que nunca han sido alquiladas.
6. Clasifica los pagos en 'Bajo' (< 3.00), 'Medio' (3.00–5.00) y 'Alto' (> 5.00). Muestra el conteo de pagos y la suma total de importes para cada categoría.
7. ¿Qué país tiene más clientes?
8. Determina qué clientes han realizado alquileres pero no han efectuado ningún pago.
9. Para cada cliente, calcula su gasto total y clasifícalo como 'VIP' (> 100), 'Regular' (50–100) u 'Ocasional' (< 50). Muestra el número de clientes en cada clasificación.
10. ¿Qué 3 películas han generado más ingresos totales en alquileres?
11. Calcula el ingreso promedio por alquiler en cada tienda.
12. Para los empleados con `staff_id` en (1, 2), muestra el total de alquileres gestionados, y agrupa el resto como 'Otros' usando `UNION`. Devuelve el nombre del empleado y el conteo.
13. ¿Qué categorías han generado más ventas totales?
14. Enumera los actores que han intervenido en al menos 10 películas de categorías distintas.
15. Para cada película, calcula el porcentaje de copias disponibles (stock) respecto al total de copias. Usa `CASE` para manejar divisiones por cero. Muestra el título y el porcentaje de disponibilidad.
16. ¿Qué tiendas tienen más stock de películas actualmente disponibles para alquilar?
17. Para cada país, muestra el cliente que más ha gastado y el importe total que ha abonado.
18. ¿Cuántos actores hay que han trabajado en películas de más de 2 géneros distintos?
19. Encuentra las 10 películas con la mayor diferencia entre su coste de reposición y su tarifa de alquiler.
20. ¿Qué películas tienen más de 3 actores y duran menos de 90 minutos?
21. Cuenta cuántas películas hay para cada idioma original y ordénalas de mayor a menor cantidad.
22. ¿Qué cliente ha gastado más dinero en alquileres en la historia?
23. Para cada empleado, determina en cuántas ciudades diferentes viven sus clientes.
24. ¿Cuántas películas no están disponibles actualmente en ninguna tienda?
25. Usando una CTE, determina el total de ingresos por categoría y filtra únicamente aquellas categorías cuyo ingreso supere la media global de todas las categorías.