# 18) Productos NUNCA vendidos

**Enunciado.** Lista **todos los productos** que **nunca han sido vendidos**, es decir, aquellos que **no aparecen en ninguna fila** de `detalle_pedido`.

## Salida (columnas y alias)
- `producto` → `productos.nombre`

## Requisitos
- **Sin duplicados:** usar `DISTINCT` para evitar nombres repetidos.
- **Ordenación:** `producto` en **orden ascendente** (`ASC`).
- **Ausencia de ventas:** un producto **solo** se incluye si **no tiene ninguna** línea asociada en `detalle_pedido`.

## Tablas implicadas (asumidas)
- `productos(id_producto, nombre, …)`
- `detalle_pedido(id_pedido, id_producto, cantidad, …)`

## Criterios de aceptación
- Si un producto **no aparece** en `detalle_pedido`, **debe** figurar en la salida **una única vez**.
- Si **todos** los productos han sido vendidos al menos una vez, la consulta devuelve **0 filas**.
- La columna devuelta **debe llamarse** `producto` y estar **ordenada alfabéticamente ascendente**.

---

> **Nota:** Este enunciado corresponde a la consulta *18) Productos NUNCA vendidos* de tu guía.
