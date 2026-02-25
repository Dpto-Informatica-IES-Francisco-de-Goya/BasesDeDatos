## Ejemplos:

### 3. Ejercicios Prácticos de Implementación


### Ejercicio 1: Auditoría de Sintaxis y Refactorización

**Contexto:** Un desarrollador junior ha entregado el siguiente script que funciona, pero incumple todos los estándares de buenas prácticas de administración de bases de datos.

```sql
CREATE TABLE vehiculos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    matricula VARCHAR(10) UNIQUE,
    tipo VARCHAR(50),
    precio FLOAT,
    fecha_compra TIMESTAMP
);
```

**Tarea:**

1. Reescribir el `CREATE TABLE` aplicando tipos de datos estrictos (la matrícula tiene formato fijo, el precio es dinero, la fecha no necesita zonas horarias).
    
    

### Ejercicio 2: Scripting Modular y Dependencias Circulares

**Contexto:** Tienes dos entidades: `investigador` y `laboratorio`. Un laboratorio es dirigido por un investigador (FK de laboratorio a investigador), y un investigador trabaja en un laboratorio principal (FK de investigador a laboratorio).

**Tarea:**

1. Generar un script SQL estructurado que permita la creación de ambas tablas de forma exitosa. 
2. Todas las restricciones deben estar debidamente nombradas.
3. El script debe incluir una cabecera `DROP TABLE IF EXISTS...` en el orden correcto para poder ejecutarse de forma iterativa en la terminal de Linux sin generar errores.

### Ejemplo 3: Creación BBDD completa (Ejercicio de hacer en clase que se corrige automático)

Crea en MySQL la base de datos de este esquema relacional.

**Tabla: `empleados`**

| **Campo** | **Tipo** | Restricciones | **Restricciones** |
| --- | --- | --- | --- |
| **id_empleado** | Numérico | PK | AUTO_INCREMENT |
| **dni** | Cadena | UNIQUE | Obligatorio |
| **salario** | Número decimal |  | Por defecto, 1200.00 |
| **estado** |  |  | 'ACTIVO', 'INACTIVO' (Default: 'ACTIVO') |

**Tabla: `proyectos`**

| **Campo** | **Tipo** | **Clave** | **Atributos / Restricciones** |
| --- | --- | --- | --- |
| **id_proyecto** | Numérico | PK | AUTO_INCREMENT |
| **nombre** | Cadena | Único | Obligatorio |
| **id_departamento** | Numérico | FK, Obligatorio | (Ref: `departamentos`) |
| **fecha_inicio** | Fecha | Obligatorio |  |
| **fecha_fin** | Fecha |  | NULL o > fecha_inicio |

**Tabla: `asignaciones`**

| **Campo** | **Tipo** | **Clave** | **Atributos / Restricciones** |
| --- | --- | --- | --- |
| **id_empleado** | Numérico | PK, FK | Ref: `empleados` (ON DELETE CASCADE) |
| **id_proyecto** | Numérico | PK, FK | Ref: `proyectos` (ON DELETE CASCADE) |
| **horas_asignadas** | Numérico |  | DEFAULT 0 |

**Tabla: `departamentos`**

| **Campo** | **Tipo** | **Clave** | **Atributos / Restricciones** |
| --- | --- | --- | --- |
| **id_departamento** | Numérico | PK | AUTO_INCREMENT |
| **codigo_dpto** | Cadena | Único, obligatorio | Todos tienen 5 caracteres |
| **nombre** | Cadena |  | Obligatorio |
| **presupuesto** | Número decimal |  | Obligatorio. No puede ser negativo. |
