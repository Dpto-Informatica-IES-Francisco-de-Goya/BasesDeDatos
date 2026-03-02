# Práctica Evaluable: Despliegue de Arquitectura Logística Distribuida ("Sistema Órbita")

**Módulo:** Gestión de Bases de Datos
**Resultado de Aprendizaje (RA3):** Realiza el diseño físico de bases de datos utilizando asistentes, herramientas gráficas y el lenguaje de definición de datos. (15% de la nota final).
**Duración de la sesión:** 3 horas (Presencial y en directo).

---

## 🏢 Contexto Corporativo: Órbita Logistics

El sistema monolítico heredado de *Órbita Logistics*, uno de los mayores operadores logísticos intercontinentales B2B, ha colapsado. La junta directiva ha aprobado una migración de emergencia hacia una arquitectura distribuida basada en **MySQL**.

Como Administradores de Sistemas (SysAdmins) del departamento de infraestructura, vuestra misión es realizar el **diseño físico, despliegue y validación** del nuevo ecosistema de datos. 

Para cumplir con el estricto límite de 3 horas, la directiva exige el uso de un **Asistente de Inteligencia Artificial** para generar el código DDL (Data Definition Language) y DML (Data Manipulation Language). 

**⚠️ ADVERTENCIA DEL CISO (Chief Information Security Officer):** La IA genera código rápido, pero carece de contexto empresarial. Intentará aplicar "buenas prácticas" genéricas que violan nuestras normativas, se equivocará con los tipos de datos exactos y generará dependencias circulares. Si ejecutáis sus scripts a ciegas en el servidor, el despliegue fallará. Vuestro trabajo no es hacer *prompting*, es **auditar el código, leer los errores del motor MySQL y garantizar un despliegue impecable.**



---

## ⚙️ Arquitectura del Sistema

El ecosistema debe dividirse físicamente en cuatro bases de datos independientes, pero lógicamente interconectadas. Cada base de datos contendrá entre 10 y 30 tablas. Los requisitos de negocio exactos se encuentran en los anexos técnicos adjuntos:

1.  **`orbita_comercial`**: Motor de negocio relacional (Clientes, tarifas, aduanas, impuestos).
2.  **`orbita_flota`**: Gestión de activos físicos (Navíos, aeronaves, camiones, mantenimiento).
3.  **`orbita_telemetria`**: Datos masivos y no estructurados (Lecturas de sensores JSON, tracking GPS).
4.  **`orbita_documental`**: Almacenamiento binario pesado (Contratos, manifiestos de carga, pólizas).

---

## 📜 Reglas de Ejecución y Restricciones Técnicas

1.  **Entorno de Trabajo:** Todo el despliegue debe realizarse desde la terminal de Linux. Queda prohibido el uso de interfaces gráficas (como phpMyAdmin o DBeaver) para la *creación* de la estructura.
2.  **Archivos de Despliegue:** La IA no debe ejecutar nada. Vosotros generaréis archivos `.sql` (ej. `01_deploy_comercial.sql`) que ejecutaréis en bloque mediante el comando source o redirección en bash: `mysql -u root -p < despliegue.sql`.
3.  **Gestión de Binarios Reales:** Deberéis insertar documentos PDF reales en `orbita_documental` lidiando con la función `LOAD_FILE()` y los permisos de lectura del sistema operativo.
4.  **Datos No Estructurados:** Las lecturas de los sensores deben almacenarse utilizando el tipo de dato `JSON` nativo de MySQL.
5.  **Prueba de Estrés (Población Masiva):** Deberéis programar o generar con IA un script (Bash, Python o Procedimientos Almacenados) que inyecte un volumen masivo de datos en la base de datos de telemetría para comprobar el rendimiento.

---

## 📦 Entregables

Al finalizar las 3 horas de la sesión, deberéis subir a esta tarea de Moodle un archivo `.zip` o un enlace a vuestro repositorio de Git con la siguiente estructura:

* 📁 `scripts_ddl/`: Los 4 archivos `.sql` que levantan la estructura completa sin devolver un solo error en la terminal.
* 📁 `scripts_dml/`: Los scripts de inserción masiva y el código utilizado para insertar los PDFs.
* 📄 `auditoria.md`: Un informe **breve y directo** documentando:
    1.  Los 3 errores más graves que cometió la IA al generar el código inicial.
    2.  Qué código de error os devolvió la terminal de MySQL (ej. Error 150, Error 1215).
    3.  Cómo refactorizasteis el código DDL para solucionarlo.

*El despliegue debe ser reproducible. Si el profesor ejecuta vuestros scripts DDL en un servidor limpio y el motor de MySQL devuelve un error de sintaxis, clave foránea o dependencia circular, la práctica se considerará **no superada**.*