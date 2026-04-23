#!/bin/bash

# Nombre de la carpeta destino en el Cloud de EducaMadrid
CLOUD_FOLDER="BasesDeDatos_Material"

show_help() {
    echo "Uso: $0 [opción]"
    echo ""
    echo "Opciones:"
    echo "  -s, --sync    Modo inteligente: solo sube archivos nuevos o modificados (recomendado)."
    echo "  -f, --force   Fuerza la subida de todos los archivos ignorando si ya existen."
    echo "  -h, --help    Muestra esta ayuda."
    echo ""
    echo "Nota: El script no creará carpetas en el cloud que no contengan archivos .pdf."
}

# Cargar credenciales
if [ -f .env ]; then
    source .env
else
    echo "Error: Archivo .env no encontrado."
    exit 1
fi

# Validar credenciales
if [ -z "$EDUMAD_USER" ] || [ -z "$EDUMAD_TOKEN" ]; then
    echo "Error: Las variables EDUMAD_USER o EDUMAD_TOKEN no están definidas en el archivo .env"
    exit 1
fi

# Comprobar si rclone está instalado
if ! command -v rclone &> /dev/null; then
    echo "Error: rclone no está instalado. Instálalo con 'sudo apt install rclone'."
    exit 1
fi

# Configurar argumentos de rclone
RCLONE_ARGS=(
    "--webdav-url" "https://cloud.educa.madrid.org/remote.php/dav/files/$EDUMAD_USER/"
    "--webdav-vendor" "nextcloud"
    "--webdav-user" "$EDUMAD_USER"
    "--webdav-pass" "$(rclone obscure "$EDUMAD_TOKEN")"
    "--include" "*.pdf"
    "--delete-excluded"  # Borra en la nube si borras el PDF en local
    "-P"                 # Mostrar progreso
)

case "$1" in
    -s|--sync)
        echo "--- Iniciando sincronización inteligente (solo cambios) ---"
        rclone sync . ":webdav:$CLOUD_FOLDER" "${RCLONE_ARGS[@]}"
        ;;
    -f|--force)
        echo "--- Forzando subida de todos los archivos ---"
        rclone copy . ":webdav:$CLOUD_FOLDER" "${RCLONE_ARGS[@]}" --ignore-times
        ;;
    -h|--help|*)
        show_help
        exit 0
        ;;
esac

echo "--- Proceso finalizado ---"
