# Consultas con subconsulta

## 1) Película(s) más larga(s) por categoría
- **Objetivo:** Para **cada categoría**, devolver la(s) **película(s) de mayor duración** dentro de esa categoría.
- **Columnas y alias obligatorios:**
  - `category` (nombre de la categoría)
  - `title` (título de la película)
  - `length` (duración en minutos)
- **Reglas:** Si en una categoría hay **empate** en la **duración máxima**, deben **aparecer todas** las películas empatadas. **Sin duplicados** adicionales.
- **Orden:** `category` **ASC**. Dentro de cada categoría, el orden es **indiferente**.

## 2) Número de películas sin stock disponible en ninguna tienda
- **Objetivo:** Devolver **una única fila** con el **recuento** de películas que **no tienen ninguna copia disponible en stock** en **ninguna** tienda.
- **Columna y alias obligatorio:**
  - `num_unavailable_films` (número total de películas sin stock disponible)
- **Reglas:** Solo cuentan las películas cuya **disponibilidad actual** de copias es **cero** en todas las tiendas.

## 3) Recaudación mensual por categoría en 2024
- **Objetivo:** Para **cada categoría** y **cada mes** del año natural **2024**, devolver la **recaudación total** (suma de importes cobrados) correspondiente a esa categoría en ese mes.
- **Columnas y alias obligatorios:**
  - `category` (nombre de la categoría)
  - `month` (número de mes 1–12)
  - `total` (importe total cobrado ese mes en esa categoría)
- **Reglas:** Considerar exclusivamente los **pagos con fecha en 2024**. Pueden **no aparecer** combinaciones categoría–mes **sin recaudación**.
- **Orden:** `category` **ASC**, `month` **ASC**.

## 4) Clientes con alquileres pero sin pagos registrados
- **Objetivo:** Listar los **clientes** que han realizado **al menos un alquiler** y **no tienen ningún pago** registrado.
- **Columnas y alias obligatorios:**
  - `customer_id`
  - `customer` (nombre y apellidos en una sola columna)
- **Reglas:** El cliente debe **cumplir ambas condiciones** (≥1 alquiler y 0 pagos). **Sin duplicados**.
- **Orden:** **Indiferente**.

## 5) Cliente(s) que más ha(n) gastado en cada país
- **Objetivo:** Para **cada país**, devolver el/los **cliente(s) con mayor gasto total** y el **importe gastado**.
- **Columnas y alias obligatorios:**
  - `country` (nombre del país)
  - `top_customer` (nombre y apellidos del cliente)
  - `max_spent` (importe total gastado por ese cliente en ese país)
- **Reglas:** Si hay **empate** en el gasto máximo de un país, **incluir todos** los clientes empatados. **Sin duplicados**.
- **Orden:** `country` **ASC**.

## 6) Categorías con ingresos superiores a la media global
- **Objetivo:** Devolver las **categorías** cuyo **ingreso total** (suma de importes cobrados asociados a sus alquileres) es **estrictamente superior** a la **media global** de ingresos por categoría.
- **Columnas y alias obligatorios:**
  - `category` (nombre de la categoría)
  - `total_revenue` (ingreso total de la categoría)
- **Reglas:** Comparar cada categoría con la **media aritmética** de los **ingresos totales por categoría**; **excluir** las categorías que **no superen** dicha media. **Sin duplicados**.
- **Orden:** `total_revenue` **DESC**.
