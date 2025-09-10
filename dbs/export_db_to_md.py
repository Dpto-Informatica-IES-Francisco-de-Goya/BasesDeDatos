import mysql.connector
import argparse
import getpass

# Configuración del parser de argumentos
parser = argparse.ArgumentParser(description="Generar un archivo Markdown con los datos de una base de datos MySQL")
parser.add_argument('database', help='El nombre de la base de datos a procesar')

# Parsear los argumentos
args = parser.parse_args()

# Solicitar la contraseña de la base de datos de manera segura
password = getpass.getpass(prompt="Introduce la contraseña de MySQL: ")

# Conectar a la base de datos MySQL
conn = mysql.connector.connect(
    host='localhost',      # Cambiar según tu configuración
    user='root',           # Cambiar según tu configuración
    password=password,     # Usamos la contraseña solicitada
    database=args.database # Usamos el nombre de la base de datos proporcionado como argumento
)

cursor = conn.cursor()

# Obtener todas las tablas de la base de datos
cursor.execute("SHOW TABLES;")
tables = cursor.fetchall()

# Inicializar el contenido del archivo Markdown
md_content = f"# Datos de la Base de Datos: {args.database}\n\n"

# Recorrer cada tabla y hacer SELECT *
for (table,) in tables:
    md_content += f"## Tabla: {table}\n"
    cursor.execute(f"SELECT * FROM {table};")
    rows = cursor.fetchall()

    # Obtener los nombres de las columnas
    cursor.execute(f"DESCRIBE {table};")
    columns = cursor.fetchall()
    column_names = [column[0] for column in columns]

    # Añadir los datos de la tabla en formato Markdown
    md_content += "| " + " | ".join(column_names) + " |\n"
    md_content += "| " + " | ".join(["---"] * len(column_names)) + " |\n"

    for row in rows:
        md_content += "| " + " | ".join(str(value) for value in row) + " |\n"

    md_content += "\n\n"

# Guardar el archivo Markdown
output_file = f"{args.database}_data.md"
with open(output_file, "w") as file:
    file.write(md_content)

# Cerrar la conexión
cursor.close()
conn.close()

print(f"Archivo Markdown generado con éxito: {output_file}")

