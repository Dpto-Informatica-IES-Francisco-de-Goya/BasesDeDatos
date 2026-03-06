## 🏗️ Esquema Relacional: AutoRepair DB

Se requiere la creación de la base de datos `taller_autorepair`. Prestad extrema atención al orden de creación de las tablas y a la naturaleza de las claves primarias.

### 1. Entidad Generalizada: `personas`
*Almacena los datos comunes de cualquier individuo registrado en el sistema.*

| **Campo** | **Tipo** | **Clave** | **Atributos / Restricciones** |
| :--- | :--- | :--- | :--- |
| **id_persona** | Numérico | PK | AUTO_INCREMENT |
| **dni** | Cadena | Único | Obligatorio. **Exactamente 9 caracteres**. |
| **nombre_completo** | Cadena | | Obligatorio. |
| **email** | Cadena | Único | Obligatorio. **Debe contener el carácter '@'**. |

### 2. Entidad Especializada: `empleados`
*Especialización de `personas`. Implementa dos relaciones reflexivas: una de jerarquía (opcional) y otra de trabajo en binomio (obligatoria).*

| **Campo** | **Tipo** | **Clave** | **Atributos / Restricciones** |
| :--- | :--- | :--- | :--- |
| **id_persona** | Numérico | PK, FK | Ref: `personas`. Obligatorio. (Es PK y FK simultáneamente). |
| **num_ss** | Cadena | Único | Obligatorio. |
| **capacitaciones** | Lista | | Tipo **SET**. Valores: 'MOTOR', 'CHAPA', 'PINTURA', 'ELECTRICIDAD'. |
| **id_jefe** | Numérico | FK | Ref: `empleados`. (Relación reflexiva opcional, un empleado puede no tener jefe). |
| **id_pareja_asignada** | Numérico | FK | Ref: `empleados`. (Relación reflexiva obligatoria. Todo mecánico trabaja en pareja). **NOT NULL**. |

### 3. Entidad Especializada: `clientes`
*Especialización de `personas`.*

| **Campo** | **Tipo** | **Clave** | **Atributos / Restricciones** |
| :--- | :--- | :--- | :--- |
| **id_persona** | Numérico | PK, FK | Ref: `personas`. Obligatorio. |
| **tipo_cliente** | Cadena | | ENUM: 'PARTICULAR', 'EMPRESA', 'FLOTA'. Obligatorio. |
| **limite_credito** | Decimal | | Por defecto 0.00. No puede ser negativo. |

### 4. Tabla: `vehiculos`

| **Campo** | **Tipo** | **Clave** | **Atributos / Restricciones** |
| :--- | :--- | :--- | :--- |
| **id_vehiculo** | Numérico | PK | AUTO_INCREMENT |
| **matricula** | Cadena | Único | Obligatorio. **Exactamente 7 caracteres**. |
| **id_cliente** | Numérico | FK | Ref: `clientes`. Obligatorio. |

### 5. Tabla: `reparaciones`

| **Campo** | **Tipo** | **Clave** | **Atributos / Restricciones** |
| :--- | :--- | :--- | :--- |
| **id_reparacion** | Numérico | PK | AUTO_INCREMENT |
| **fecha_ingreso** | Fecha | | Por defecto, la fecha actual del sistema. |
| **id_vehiculo** | Numérico | FK | Ref: `vehiculos`. Obligatorio. |

### 6. Tabla: `piezas`

| **Campo** | **Tipo** | **Clave** | **Atributos / Restricciones** |
| :--- | :--- | :--- | :--- |
| **id_pieza** | Numérico | PK | AUTO_INCREMENT |
| **referencia** | Cadena | Único | Obligatorio. |
| **stock_actual** | Numérico | | Por defecto 0. |

### 7. Tabla N:M (PK Compuesta): `piezas_compatibles`
*Registra qué piezas pueden usarse como sustitutas de otras.*

| **Campo** | **Tipo** | **Clave** | **Atributos / Restricciones** |
| :--- | :--- | :--- | :--- |
| **id_pieza_original** | Numérico | PK, FK | Ref: `piezas` (ON DELETE CASCADE). |
| **id_pieza_sustituta** | Numérico | PK, FK | Ref: `piezas` (ON DELETE CASCADE). |

### 8. Tabla N:M (Surrogate PK): `inspecciones_previas`
*Relaciona vehículos con empleados. Usa un ID propio porque la asignación del empleado puede posponerse (FK opcional).*

| **Campo** | **Tipo** | **Clave** | **Atributos / Restricciones** |
| :--- | :--- | :--- | :--- |
| **id_inspeccion** | Numérico | PK | AUTO_INCREMENT |
| **id_vehiculo** | Numérico | FK | Ref: `vehiculos`. Obligatorio. |
| **id_empleado_revisor**| Numérico | FK | Ref: `empleados`. **Puede ser NULO** (Inspección pendiente de asignar). |
| **fecha_programada** | Fecha | | Obligatorio. |
| **gravedad_estimada** | Numérico | | Nivel del 1 al 5. Impleméntese con un CHECK. |

### 9. Tabla Ternaria: `instalaciones`
*Relaciona qué empleado concreto instaló qué pieza en qué reparación. Su clave primaria es la combinación de las 3 entidades.*

| **Campo** | **Tipo** | **Clave** | **Atributos / Restricciones** |
| :--- | :--- | :--- | :--- |
| **id_empleado** | Numérico | PK, FK | Ref: `empleados`. |
| **id_reparacion** | Numérico | PK, FK | Ref: `reparaciones`. |
| **id_pieza** | Numérico | PK, FK | Ref: `piezas`. |
| **cantidad_usada** | Numérico | | Obligatorio. Debe ser mayor que 0. |