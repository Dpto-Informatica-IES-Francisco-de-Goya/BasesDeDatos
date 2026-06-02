
/*******************************************************************
*******************************************************************
						ALMACENES
                        (terminado el miércoles a la hora de comer)
*******************************************************************
*******************************************************************/

select * from almacenes;

/* TODOs:
- Eliminar la _ de cod_almacen
- El nombre de sucursal es absurdo. Quitar la palabra "sucursal" del nombro si todos son sucursales de verdad
- Revisar que no haya nombres de sucursal repetidos y añadirle una restricción de unique. [EX - 1pto]
- Hacer una tabla "ciudades" con los nombres de las ciudades y dejar en esta tabla almacenes un id que sea FK a esa tabla ciudades [EX - 2.5pts]
- Barna y VLC ponerlos como Valencia y Barcelona.
- Dejar capacidad_m3 como una columna numérica. [EX - 1.5 pto]
- Teléfonos de contacto con prefijo español, solo pueden empezar por 9,7 o 6.
- Separar ubicación geográfica en 2 columnas numéricas diferentes llamadas latitud y longitud. Borrar después esa columna.
- Eliminar duplicados por código de almacen si están en la misma ciudad. [EX - 2.5 pto]
- Eliminar duplicados por código de almacen si se llaman igual.
- Eliminar duplicados por nombre.
- Tipo_gestión es una columna un poco rara. Ponerla bonita.
- Convertir a L la capacidad (sabiendo que 1m³ son 1000L). [EX - 2pto] 
- PRO: Sacar la distancia entre almacenes con una formulita a partir de latitud y longitud. (Esa formulita se la sabe chatty).*/


/*******************************************************************
*******************************************************************
						CLIENTES (la tarde del miércoles)
*******************************************************************
*******************************************************************/



/*******************************************************************
*******************************************************************
						empleados
*******************************************************************
*******************************************************************/



/*******************************************************************
*******************************************************************
						ENVIOS
*******************************************************************
*******************************************************************/

SELECT * FROM envios;

/* TODOs:
- Eliminar duplicados por traking numer
- Arreglar FKs (cliente_id, vehiculo_id, empleado_id, almacen_destino_id ...)
- Arreglar Fechas
...
*/
