# Práctica usuarios y permisos

# Despliegue y Auditoría de Privilegios Distribuidos en Entornos Reales

**Objetivo principal:** Implementar una topología de red de bases de datos segura, aplicando el principio de mínimo privilegio, control de acceso basado en roles (RBAC) y restricciones de host.

**Objetivo secundario:** Familiarizarse con herramientas de Inteligencia Artificial. Recomendación: gemini con tu cuenta corporativa de @educa.madrid.org .

## 0. Prerrequisitos y Buenas Prácticas de Seguridad (Lectura Obligatoria)

Antes de teclear un solo comando, todos los servidores deben cumplir con estas directrices de seguridad de la industria. Su incumplimiento en la memoria supondrá una penalización directa:

- **Aislamiento de red:** El usuario `root` jamás debe tener acceso remoto (`'root'@'%'` es un fallo crítico). Solo debe poder conectar desde `localhost`.
- **Autenticación robusta:** Utilizad el plugin nativo de MySQL 8.0+ (`caching_sha2_password`). Si algún conector os obliga a usar `mysql_native_password`, documentad el motivo técnico de la deuda técnica.
- **Principio de mínimo privilegio:** Se asignan los permisos estrictamente necesarios para la función a realizar. Los permisos globales (`.*`) están terminantemente prohibidos para usuarios no administradores.
- **Trazabilidad:** Toda asignación de permisos a usuarios finales se hará a través de **ROLES**. No se asignan permisos sueltos a cuentas de usuario directamente.

## 1. Topología y Escenario

- Formaréis grupos de 4 personas. Cada miembro del grupo (numerados del 1 al 4) es el Administrador de Sistemas (Tier 1) exclusivo de su propio servidor físico/virtual (equipo del aula).
- Todos los servidores alojarán una base de datos idéntica llamada `erp_sostenibilidad` (con al menos una tabla `huella_carbono` con datos ficticios).
- Las IPs de vuestros equipos del aula serán las únicas permitidas para las conexiones. No se permite el comodín `%` en el host de ningún usuario.

## 2. Jerarquía de Privilegios (Matriz de Acceso)

Cada administrador debe crear cuentas para sus 3 compañeros en su servidor. La jerarquía de roles se desplaza en anillo dependiendo de quién sea el propietario del servidor, siguiendo estos perfiles:

- **Tier 1 (Propietario/DBA):** Acceso total (`root@localhost`).
- **Tier 2 (Delegado Técnico):** Rol con permisos de Estructura y Datos sobre `erp_sostenibilidad`. Puede ejecutar `SELECT`, `INSERT`, `UPDATE`, `DELETE`, `CREATE`, `DROP`, `ALTER`.
- **Tier 3 (Desarrollador Backend):** Rol exclusivo para manipulación de datos (DML). Puede ejecutar `SELECT`, `INSERT`, `UPDATE`, `DELETE` sobre `erp_sostenibilidad`.
- **Tier 4 (Auditor Externo):** Rol de solo lectura para generar informes. Solo puede ejecutar `SELECT` sobre `erp_sostenibilidad`.

**Matriz de asignación por servidor:**

| Servidor (Propietario) | Rol: Delegado Técnico (Tier 2) | Rol: Desarrollador (Tier 3) | Rol: Auditor (Tier 4) |
| --- | --- | --- | --- |
| **Servidor 1** (Alumno 1) | Alumno 2 | Alumno 3 | Alumno 4 |
| **Servidor 2** (Alumno 2) | Alumno 3 | Alumno 4 | Alumno 1 |
| **Servidor 3** (Alumno 3) | Alumno 4 | Alumno 1 | Alumno 2 |
| **Servidor 4** (Alumno 4) | Alumno 1 | Alumno 2 | Alumno 3 |

> **Ejemplo:** En el equipo del Alumno 3, él es el administrador. Debe crear un rol de Delegado y asignárselo a la IP del Alumno 4; un rol de Desarrollador para la IP del Alumno 1; y un rol de Auditor para la IP del Alumno 2.
> 

## 3. Requisitos de Ejecución y Pruebas

Para asegurar que comprendéis cómo funciona el motor de MySQL por debajo, debéis documentar interacciones cruzadas en vivo.

- **Demostración de Restricción de Host:** El Alumno 4 debe intentar conectarse al Servidor 1 utilizando el usuario del Alumno 2. Debe fallar por restricción de IP, no por contraseña.
- **Demostración de Límite de Privilegios:** El Alumno 3 (Desarrollador en el Servidor 1) debe intentar hacer un `DROP TABLE huella_carbono`. El motor debe denegar la acción.
- **Auditoría sin Atajos:** Queda estrictamente prohibido utilizar la sentencia `SHOW GRANTS` en la memoria. Toda demostración de que los usuarios, roles y permisos están bien creados debe hacerse mediante consultas a las tablas del diccionario de datos: `mysql.user`, `mysql.db`, `mysql.role_edges` y `mysql.default_roles`.
- **Gestión de Incidentes (Revocación en caliente):** A mitad de la práctica, el Administrador de cada servidor decidirá que el "Desarrollador" ya no puede borrar registros. Debe revocar el permiso `DELETE` del rol de Desarrollador. Inmediatamente, el alumno afectado debe intentar hacer un `DELETE` desde su equipo y documentar el error *Access denied*.

## 4. Entregable (Memoria Técnica)

El grupo presentará un único documento en formato PDF, junto con 4 archivos `G1_Alumno1_Apellido_Nombre.sql` , donde `G1` indica el número de grupo y `Alumno1` indica la posición del alumno de entre los 4 del grupo. Debe ser un archivo comentado.

La memoria debe ser técnica, concisa y profesional. Debe contener:

- **Mapa de Red:** Un esquema indicando las IPs de los 4 equipos del aula y qué alumno ocupa cada IP (salida de `ip a` en la terminal de Linux Mint de cada uno).
- **Script de Despliegue:** El código SQL estandarizado que habéis diseñado para crear la base de datos, los roles y asignar los usuarios con sus respectivas IPs.
- **Evidencias de Auditoría Interna:** Capturas de pantalla de la terminal (fondo negro en la que se vea el nombre del equipo) ejecutando las consultas sobre `mysql.user`, `mysql.role_edges` y `mysql.db` en, al menos uno de los servidores, demostrando la topología final de permisos.
- **Evidencias de Bloqueo (Troubleshooting):** Capturas de pantalla desde cada máquina de los clientes recibiendo los errores exactos al intentar violar su nivel de seguridad (El `DROP` bloqueado del Tier 3, el `INSERT` bloqueado del Tier 4, el fallo de conexión por IP no autorizada, …).
- **Evidencia de Revocación:** Captura del antes y el después de la revocación del permiso `DELETE` al rol de desarrollador.

---