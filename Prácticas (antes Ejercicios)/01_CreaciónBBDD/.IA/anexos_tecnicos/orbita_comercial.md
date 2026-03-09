# Anexo Técnico 01: Especificaciones de `orbita_comercial`

**Base de datos:** `orbita_comercial`
**Propósito:** Motor relacional del negocio. Gestión de cartera de clientes, facturación internacional, agentes de aduanas y definición de tarifas de carga.
**Volumen estimado:** Entre 15 y 25 tablas.

---

## 1. Dominio de Datos (Entidades a modelar)

El Asistente de IA deberá generar un modelo normalizado que incluya, como mínimo, las siguientes áreas lógicas:

* **Geopolítica y Fiscalidad:** Países, regiones comerciales (ej. UE, NAFTA), monedas oficiales y tipos de impuestos aduaneros aplicables.
* **Cartera de Clientes:** Empresas corporativas, filiales dependientes, información de contacto fiscal y clasificación de clientes (Estándar, VIP, Gubernamental).
* **Gestión Aduanera:** Agentes de aduanas homologados, delegaciones aduaneras por país y estados de tramitación legal.
* **Catálogo Comercial:** Tipos de contenedores homologados (Estándar de 20ft/40ft, Refrigerados, Peligrosos, Especiales Aéreos), servicios logísticos ofrecidos y tarifas base.
* **Facturación:** Contratos marco, facturas emitidas, líneas de detalle de factura y estados de pago.

---

## 2. Restricciones de Negocio (Constraints)



El código DDL generado debe implementar **estrictamente** las siguientes reglas de negocio a nivel de motor de base de datos. No se aceptará que estas reglas se controlen "desde la aplicación", deben estar en el esquema:

1.  **Límites de Carga Físicos:** En el catálogo de tipos de contenedores, el peso máximo permitido jamás puede ser un valor negativo. Además, si la categoría del contenedor está marcada para transporte `Aéreo`, el peso máximo no puede superar bajo ninguna circunstancia las `5.5` toneladas.
2.  **Prevención de Fraude Fiscal:** Para evitar inconsistencias legales, la base de datos debe impedir a nivel de tabla que la fecha de emisión de cualquier factura mercantil sea una fecha futura al momento de la inserción.
3.  **Jerarquía de Filiales:** Una empresa filial siempre debe tener una empresa matriz, pero una empresa matriz no puede ser filial de sí misma. 

---

## 3. Reglas de Integridad y Dependencias (¡ATENCIÓN!)

El departamento legal exige un control absoluto sobre quién gestiona a nuestros grandes clientes. Debéis modelar la siguiente relación entre las entidades `Cliente_Corporativo` y `Agente_Aduanero`:

* Todo **Agente Aduanero** homologado en nuestro sistema tiene que estar contratado en nómina por un **Cliente Corporativo** específico (para evitar el espionaje industrial). 
* Simultáneamente, todo **Cliente Corporativo** registrado en el sistema **debe tener obligatoriamente** un **Agente Aduanero** asignado por defecto como su contacto principal para emergencias en puertos.
*  *Nota técnica para el SysAdmin: Aseguraos de que el script de creación DDL de la IA sea capaz de compilar de principio a fin sin devolver errores de tablas inexistentes.*

## 4. Borrados en Cascada (Integridad Referencial)

Deberéis configurar las cláusulas `ON DELETE` siguiendo estas directrices:
* Si el sistema elimina un `Pais` que ha dejado de existir, la base de datos **debe impedir** la acción si hay `Clientes_Corporativos` registrados en dicho país.
* Si un `Cliente_Corporativo` se da de baja y se elimina, sus `Contratos_Marco` deben desaparecer automáticamente de la base de datos.
* Si se elimina un `Cliente_Corporativo`, sus `Facturas` históricas **no pueden eliminarse jamás** por ley de auditoría fiscal. Deben conservarse, pero perdiendo la vinculación directa con el cliente borrado.