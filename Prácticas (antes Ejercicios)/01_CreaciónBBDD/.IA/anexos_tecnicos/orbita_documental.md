# Anexo Técnico 04: Especificaciones de `orbita_documental`

**Base de datos:** `orbita_documental`
**Propósito:** Repositorio legal inmutable. Almacenamiento seguro de documentación física escaneada, contratos firmados y pólizas de seguros.
**Volumen estimado:** Entre 10 y 15 tablas.

---

## 1. Dominio de Datos (Entidades a modelar)

El Asistente de IA deberá diseñar un esquema para organizar el volumen de papel digitalizado que mueve *Órbita Logistics*:

* **Documentación de Carga:** Manifiestos de carga (Bill of Lading), Declaraciones Únicas de Aduanas (DUA) e inspecciones fitosanitarias.
* **Documentación Legal:** Contratos de fletamento, Acuerdos de Nivel de Servicio (SLA) con clientes VIP y Acuerdos de Confidencialidad (NDA).
* **Seguros:** Pólizas de seguros marítimos y aéreos, y peritajes de siniestros.
* **Firmas y Auditoría:** Registro de qué empleado (auditor/agente) subió cada documento y en qué fecha exacta (Time-stamping).

---

## 2. La Trampa de las "Buenas Prácticas" (Almacenamiento Binario)

El CISO de la compañía ha decretado que, por motivos de seguridad y auditoría frente a hackeos del servidor de archivos, **los documentos físicos deben residir DENTRO de la base de datos**, no en carpetas del sistema operativo.

**Requisito técnico estricto:** Los archivos PDF escaneados deben almacenarse directamente en tablas utilizando los tipos de datos binarios masivos de MySQL (`BLOB`, `MEDIUMBLOB` o `LONGBLOB`).

**[⚠️ ALERTA DE SISTEMA] - La Desobediencia de la IA:**
*Nota para el SysAdmin: Las IAs están entrenadas con tutoriales de desarrollo web que consideran el almacenamiento de BLOBs una "mala práctica". Por defecto, la IA ignorará esta directriz y generará columnas tipo `VARCHAR(255)` llamadas `ruta_archivo_pdf` o `url_documento`. Debéis auditar el código DDL, rechazar esa estructura y forzar a la IA a implementar el tipo `LONGBLOB`.*

---

## 3. El Reto de la Ingesta de Archivos Físicos (`LOAD_FILE`)

Para validar que el diseño físico funciona, debéis realizar una prueba de concepto (PoC) insertando al menos **dos archivos PDF reales** (podéis generar PDFs vacíos o de prueba en vuestro equipo local) dentro de la base de datos `orbita_documental`.



Es humanamente imposible copiar y pegar el código binario de un PDF en la terminal. Deberéis utilizar vuestra IA para que os guíe sobre cómo usar la función nativa `LOAD_FILE('/ruta/absoluta/al/archivo.pdf')` en vuestras sentencias `INSERT`.

---

## 4. Auditoría de Permisos (El Muro de Linux)

Al intentar ejecutar el `INSERT` con `LOAD_FILE()`, os chocaréis de frente con las medidas de seguridad combinadas de Linux y MySQL.

Para que el insert sea exitoso, deberéis investigar y resolver dos bloqueos como administradores de sistemas:
1.  **Permisos del SO:** El usuario del sistema `mysql` debe tener permisos de lectura sobre el directorio de Linux donde habéis guardado el PDF de prueba.
2.  **La variable `secure_file_priv`:** Por seguridad, MySQL restringe desde qué directorios puede importar archivos. Deberéis consultar a vuestra IA cómo averiguar el valor de esta variable en vuestro servidor (`SHOW VARIABLES LIKE...`) y mover vuestros PDFs a esa ruta autorizada, o reconfigurar el servidor para permitir la lectura.

*El éxito de esta base de datos se evaluará comprobando mediante una consulta `SELECT` que el campo BLOB contiene datos (no es NULL) y refleja el tamaño del archivo.*