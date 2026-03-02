# Anexo Técnico 03: Especificaciones de `orbita_telemetria`

**Base de datos:** `orbita_telemetria`
**Propósito:** Ingesta masiva de datos IoT (Internet of Things), seguimiento geolocalizado (Tracking) y registro de incidencias en tiempo real.
**Volumen estimado:** Entre 10 y 15 tablas (estructura más ligera, pero de volumen de datos masivo).

---

## 1. Dominio de Datos (Entidades a modelar)

El Asistente de IA deberá diseñar el esquema para soportar el flujo constante de datos de nuestros activos:

* **Tracking GPS:** Historial de coordenadas (latitud, longitud, altitud, velocidad, rumbo) emitidas por los transpondedores de buques, aviones y camiones.
* **Sensores IoT (Contenedores):** Dispositivos acoplados a la carga que miden las condiciones internas durante el tránsito.
* **Incidencias y Meteorología:** Registro de eventos climáticos severos, retrasos en ruta, alertas de piratería o fallos mecánicos en tránsito.
* **Nodos de Red:** Antenas y satélites de la red Órbita que reciben los *pings* de los vehículos.

---

## 2. El Reto de la No Estructuración (Payloads JSON)



En el sector logístico, los sensores IoT envían "payloads" (paquetes de datos) muy variables. Un contenedor refrigerado envía temperatura y estado del compresor; un contenedor de obras de arte envía humedad y vibración; y todos envían la versión de su firmware y el nivel de batería. 

**Requisito técnico estricto:** Toda la información del sensor IoT **NO debe desglosarse en múltiples columnas** (como `temperatura`, `humedad`, `bateria`). Todo el paquete de configuración y lectura del sensor debe encapsularse obligatoriamente en una única columna utilizando el tipo de dato nativo `JSON` de MySQL.

*Nota para el SysAdmin: Las IAs, por su entrenamiento relacional clásico, sufren de "sobre-normalización compulsiva". Intentarán crearos 15 columnas distintas o, en el peor de los casos, usar un simple `TEXT` o `VARCHAR`. Debéis rechazar ese código y exigir el uso del tipo `JSON` para garantizar la validación del motor.*

---

## 3. Integridad Cruzada (Cross-Database Foreign Keys)

La telemetría no existe en el vacío. Toda lectura de GPS o sensor debe estar referenciada al vehículo que la emite y al contenedor que la transporta.

El código DDL deberá implementar claves foráneas (Foreign Keys) que apunten a tablas que residen en **otras bases de datos** del servidor.
* Deberéis vincular la telemetría con los vehículos alojados en `orbita_flota`.
* Deberéis vincular los contenedores monitorizados con el catálogo de `orbita_comercial`.

*Sintaxis requerida:* El motor MySQL soporta esto utilizando la nomenclatura `base_de_datos.tabla`. Aseguraos de que la IA no intente crear tablas duplicadas dentro de este esquema.

---

## 4. Prueba de Estrés (Stress Test DML)

El objetivo de esta base de datos es el rendimiento. Un diseño físico no sirve de nada si colapsa al recibir datos. Una vez desplegado el esquema, debéis realizar una prueba de estrés.

**Misión de Ingesta Masiva:**
Debéis poblar la tabla principal de lecturas IoT/GPS con un mínimo de **50.000 registros sintéticos**.

**[⚠️ ALERTA DE SISTEMA] - El Límite de la IA:**
*No intentéis pedirle a la IA: "Générame 50.000 sentencias INSERT". La IA cortará la respuesta a las 100 líneas por sus límites de tokens y os quedaréis con un script inútil e incompleto.*



Para superar este reto, debéis usar la IA como ingenieros: pedidle que os programe un **Procedimiento Almacenado (Stored Procedure)** en MySQL con un bucle `WHILE`, o bien un **script ejecutable en Bash/Python** que genere e inyecte esos miles de registros automáticamente en vuestra base de datos.