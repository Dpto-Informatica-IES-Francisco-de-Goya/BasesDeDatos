# Anexo Técnico 02: Especificaciones de `orbita_flota`

**Base de datos:** `orbita_flota`
**Propósito:** Gestión integral de los activos físicos de transporte, infraestructuras base y personal operativo.
**Volumen estimado:** Entre 15 y 25 tablas.

---

## 1. Dominio de Datos (Entidades a modelar)

El Asistente de IA deberá generar el modelo físico de las siguientes áreas:

* **Infraestructura Base:** Puertos marítimos internacionales, aeropuertos de carga, terminales logísticas terrestres y hangares de mantenimiento.
* **Activos de Transporte (Flota):** Buques portacontenedores, aviones de carga (Freighters) y flotas de camiones pesados. 
* **Personal Operativo:** Capitanes, pilotos, conductores, ingenieros navales y mecánicos de aviación. Se requiere gestionar sus certificaciones y licencias habilitantes.
* **Operaciones de Mantenimiento:** Revisiones técnicas, piezas sustituidas (inventario básico), órdenes de reparación y estados de aeronavegabilidad/navegabilidad.

---

## 2. Precisión de Tipos de Datos (Identificadores Críticos)

En *Órbita Logistics*, el volumen de nuestros activos es masivo. Los identificadores por defecto que utilizan los frameworks web estándar (`INT`) son insuficientes y provocan desbordamientos de enteros (Integer Overflow). 

Debéis aseguraros de que el código DDL cumpla **estrictamente** con los siguientes tipos de datos para las claves primarias (Primary Keys):

1.  **Identificadores de Flota (Buques, Aviones y Camiones):** Deben ser números enteros enormes, que jamás admitan valores negativos y que se autoincrementen. No se aceptarán identificadores estándar.
2.  **Identificadores de Personal Operativo:** El ID de cualquier empleado (pilotos, mecánicos, etc.) debe ser un `BIGINT` estricto, sin signo.
3.  **Códigos de Infraestructura:** Los puertos y aeropuertos no usan números, sino sus códigos internacionales IATA/UNLOCODE exactos (ej. 'ESVLC' para Valencia, 'MAD' para Madrid). Deben ser cadenas de texto de longitud fija de exactamente 3 o 5 caracteres, ni uno más ni uno menos, para optimizar el almacenamiento.

---

## 3. Integridad Referencial y Mantenimiento

Todo vehículo de la flota está sujeto a inspecciones y tiene personal asignado. Las dependencias deben modelarse con las siguientes reglas lógicas:

* **Órdenes de Mantenimiento:** Toda orden de reparación debe estar vinculada obligatoriamente a un activo de transporte (el vehículo reparado) y a un mecánico (el responsable). 
* **Tripulación:** Todo vehículo en activo tiene asignada una tripulación actual.
* **[⚠️ ALERTA DE SISTEMA] - El temido Error 150:** *Nota para el SysAdmin: Cuando la IA intente vincular la tabla de Mantenimiento con la tabla de la Flota o de Personal, vigilad atentamente los tipos de datos de las claves foráneas (Foreign Keys). Si la IA utiliza un tipo de dato que no sea un clon exacto, bit a bit, de la clave primaria referenciada, el motor MySQL abortará el despliegue.*

---

## 4. Borrados en Cascada (Ciclo de Vida del Activo)

La directiva exige que el sistema gestor de bases de datos limpie automáticamente los registros cuando un activo llega al final de su vida útil, aplicando estas reglas en el diseño DDL:

* Si un buque o avión sufre un siniestro total o es desguazado (se elimina de la base de datos), **todo su historial de mantenimiento y reparaciones debe ser destruido automáticamente** para no ocupar espacio en disco.
* Sin embargo, si ese buque o avión es eliminado, **la tripulación asignada jamás debe ser borrada del sistema**. Simplemente deben quedar en estado "disponible" (sin vehículo asignado).
* No se puede demoler (eliminar) un hangar o terminal logística si actualmente tiene vehículos estacionados o en reparación en su interior.