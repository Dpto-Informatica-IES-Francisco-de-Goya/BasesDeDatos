#!/bin/bash

# Script para compilar todos los exámenes de recuperación en esta carpeta.
# Este script busca archivos .tex que contengan \documentclass y los compila con pdflatex.

# Obtener la ruta absoluta del directorio del script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

# 1. Asegurar que los estilos están instalados
if [ -f "$REPO_ROOT/utilities/install_styles.sh" ]; then
    bash "$REPO_ROOT/utilities/install_styles.sh"
fi

SUCCESS_COUNT=0
FAILED_COUNT=0
FAILED_FILES=()

# 2. Buscar y compilar
while IFS= read -r -d '' f; do
    # Solo compilar archivos que sean documentos completos
    if ! grep -q '\\documentclass' "$f"; then
        continue
    fi

    dir=$(dirname "$f")
    base=$(basename "$f")
    pdf_file="${f%.tex}.pdf"
    
    # Solo compilar si el .tex es más reciente que el .pdf o si el .pdf no existe
    if [ -f "$pdf_file" ] && [ "$f" -ot "$pdf_file" ]; then
        echo "SALTANDO (ya actualizado): $base"
        ((SUCCESS_COUNT++))
        continue
    fi

    echo "---------------------------------------------------"
    echo "Compilando: $base"
    echo "Directorio: $dir"
    
    if (cd "$dir" && latexmk -pdf -interaction=nonstopmode -silent "$base" > /dev/null 2>&1); then
        echo "RESULTADO: ÉXITO"
        ((SUCCESS_COUNT++))
        # Limpiar archivos auxiliares
        (cd "$dir" && latexmk -c "$base" > /dev/null 2>&1)
    else
        echo "RESULTADO: FALLO"
        ((FAILED_COUNT++))
        FAILED_FILES+=("$f")
    fi
done < <(find "$SCRIPT_DIR" -name "*.tex" -print0)

echo "---------------------------------------------------"
echo "RESUMEN DE COMPILACIÓN"
echo "Éxito: $SUCCESS_COUNT"
echo "Fallo: $FAILED_COUNT"

if [ $FAILED_COUNT -gt 0 ]; then
    echo "Archivos que fallaron:"
    for f in "${FAILED_FILES[@]}"; do
        echo "  - $f"
    done
    exit 1
fi

exit 0
