su# Práctica Creación BBDD

Esta práctica evalúa los CE a-d del RA de creación de bases de datos.

## 📌 Instrucciones Generales y Normativa de Entrega

El objetivo de esta práctica es demostrar la asimilación de los contenidos relacionados con el Lenguaje de Definición de Datos (DDL). Deberéis generar un único script `.sql` que construya desde cero el esquema relacional detallado más abajo. Debe poder ejecutarse y funcionar ejecutando en la terminal el siguiente comando:

```bash
$ mysql -u admin -p < tu_entrega.sql
```

<aside>
💡

 **MUY IMPORTANTE: Corrección Automatizada**

</aside>

La evaluación de esta entrega **se realizará de forma 100% automática** mediante un script de corrección que ejecutará baterías de pruebas (inserciones válidas, tests de restricciones, control de borrados en cascada, etc.). Será como el ejemplo de clase.

Por este motivo, **el modelo relacional debe respetarse de manera milimétrica**. Cualquier desviación en el nombre de una tabla, el nombre de una columna, el tipo de dato exacto o la ausencia de una restricción (PK, FK, UNIQUE, CHECK, ENUM, DEFAULT, NOT NULL) provocará que el script de pruebas falle y, en consecuencia, que la calificación de ese apartado (o de la práctica entera) pueda ser un **0**. No habrá revisión manual por errores tipográficos; el código debe ser perfecto y funcional.

**🤖 Uso de Inteligencia Artificial y Buenas Prácticas**
Durante las clases se han explicado detalladamente una serie de **buenas prácticas de diseño, estructuración del código SQL y convenciones de nomenclatura**. Vuestro script debe reflejar estrictamente esta forma de trabajar.
Si el código entregado funciona, pero utiliza sintaxis no explicada, ignora los estándares de la asignatura o presenta estructuras atípicas, **será considerado sospechoso de haber sido generado mediante herramientas de Inteligencia Artificial (ChatGPT, Gemini, Copilot, etc.)**.
En caso de detectar indicios de uso de IA en lugar del trabajo personal, el alumno o alumna será convocado a **un examen práctico oral e in situ en el aula**. En esta prueba deberá defender su código, modificarlo en tiempo real y demostrar la autoría del mismo. Si no se supera esta comprobación, la nota de la práctica será un 0 y se aplicará la normativa ya explicada.

**💡 Consejo para el Examen**
Esta práctica no es un simple trámite; es **la mejor preparación posible para el examen del RA**. La prueba de evaluación presencial será sumamente parecida a la creación de este esquema (incluyendo dependencias complejas y restricciones avanzadas). Si delegáis este trabajo en una máquina, os estaréis haciendo trampa a vosotros mismos. Os recomiendo encarecidamente que escribáis el código a mano en vuestro entorno habitual (utilizando, eso sí, la documentación oficial), os peleéis con los errores de sintaxis, analicéis los fallos de las claves foráneas y entendáis perfectamente cómo resolver el esquema. [Es la mejor forma de asegurar el aprendizaje.](https://cacm.acm.org/news/the-impact-of-ai-on-computer-science-education/)

---

## 🏗️ Esquema Relacional: Gestión Universitaria

Debéis crear una base de datos llamada `gestion_universidad`. Tened especial cuidado con el orden de creación de las tablas. 

**Tabla: `facultades`**

| **Campo** | **Tipo** | **Clave** | **Atributos / Restricciones** |
| --- | --- | --- | --- |
| **id_facultad** | Numérico | PK | AUTO_INCREMENT |
| **codigo** | Cadena | Único | Obligatorio. Exactamente 4 caracteres. |
| **nombre** | Cadena | Único | Obligatorio |
| **id_decano** | Numérico | FK | Ref: `profesores` (Puede ser nulo inicialmente) |

**Tabla: `profesores`**

| **Campo** | **Tipo** | **Clave** | **Atributos / Restricciones** |
| --- | --- | --- | --- |
| **id_profesor** | Numérico | PK | AUTO_INCREMENT |
| **nif** | Cadena | Único | Obligatorio. Exactamente 9 caracteres. |
| **nombre_completo** | Cadena |  | Obligatorio |
| **salario** | Número decimal |  | Por defecto 2000.00. Debe ser mayor que 0. |
| **id_facultad** | Numérico | FK | Ref: `facultades`. Obligatorio. |

**Tabla: `grados`**

| **Campo** | **Tipo** | **Clave** | **Atributos / Restricciones** |
| --- | --- | --- | --- |
| **id_grado** | Numérico | PK | AUTO_INCREMENT |
| **nombre** | Cadena | Único | Obligatorio |
| **id_facultad** | Numérico | FK | Ref: `facultades`. Obligatorio. |

**Tabla: `asignaturas`**

| **Campo** | **Tipo** | **Clave** | **Atributos / Restricciones** |
| --- | --- | --- | --- |
| **id_asignatura** | Numérico | PK | AUTO_INCREMENT |
| **codigo_asig** | Cadena | Único | Obligatorio. Máximo 10 caracteres. |
| **nombre** | Cadena |  | Obligatorio |
| **creditos** | Numérico |  | Por defecto 6. Debe ser >= 3. |

**Tabla: `imparten`**

| **Campo** | **Tipo** | **Clave** | **Atributos / Restricciones** |
| --- | --- | --- | --- |
| **id_profesor** | Numérico | PK, FK | Ref: `profesores` (ON DELETE CASCADE) |
| **id_asignatura** | Numérico | PK, FK | Ref: `asignaturas` (ON DELETE CASCADE) |
| **tipo_grupo** | Cadena |  | ENUM: 'TEORIA', 'PRACTICA' (Default: 'TEORIA') |

## 👁️ Vistas (Consultas Almacenadas)
Para completar el diseño del esquema, debéis implementar las siguientes dos vistas. Estas permiten simplificar el acceso a la información compleja y son fundamentales para la capa de presentación de cualquier aplicación.

### 1. Vista: v_cuadro_docente
El objetivo de esta vista es obtener un listado legible de qué profesores imparten qué asignaturas y en qué facultades están destinados. Debe ocultar los IDs internos y mostrar información descriptiva.

Columnas a mostrar:

- profesor: Nombre completo del profesor.

- nif_profesor: NIF del profesor.

- asignatura: Nombre de la asignatura que imparte.

- modalidad: El tipo de grupo (Teoría o Práctica).

- facultad_origen: Nombre de la facultad a la que pertenece el profesor.

- Lógica: Debe realizar los JOIN necesarios entre profesores, imparten, asignaturas y facultades.

### 2. Vista: v_resumen_facultades
Esta vista proporciona una métrica de gestión económica y organizativa por cada facultad del sistema.

Columnas a mostrar:

- facultad: Nombre de la facultad.

- codigo_facultad: Código de 4 caracteres.

- num_profesores: Cantidad total de profesores adscritos a esa facultad.

- masa_salarial: Suma total de los salarios de todos los profesores de esa facultad.

- salario_medio: Salario promedio de la facultad (redondeado a 2 decimales).

- Lógica: Requiere el uso de GROUP BY por facultad y funciones de agregado (COUNT, SUM, AVG).