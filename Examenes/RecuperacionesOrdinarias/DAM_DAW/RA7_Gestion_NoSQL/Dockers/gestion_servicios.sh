#!/bin/bash

# Script para la gestión de servicios NoSQL de EcoDrive / GloboTour
# Uso: ./gestion_servicios.sh [up|down]

COMANDO=$1
SERVICIOS=("mongodb" "redis" "cassandra" "neo4j")

# Validar argumento
if [[ "$COMANDO" != "up" && "$COMANDO" != "down" ]]; then
    echo "Uso incorrecto."
    echo "Uso: $0 up   -> Levanta todos los servicios (modo background)"
    echo "Uso: $0 down -> Detiene y elimina los contenedores"
    exit 1
fi

echo "===================================================="
echo "Iniciando operación: $COMANDO en todos los servicios"
echo "===================================================="

for SERVICIO in "${SERVICIOS[@]}"; do
    if [ -d "$SERVICIO" ]; then
        echo "[+] Procesando $SERVICIO..."
        cd "$SERVICIO"
        
        if [ "$COMANDO" == "up" ]; then
            docker compose up -d
        else
            docker compose down
        fi
        
        cd ..
    else
        echo "[!] Error: No se encontró la carpeta $SERVICIO"
    fi
    echo "----------------------------------------------------"
done

echo "Operación finalizada."
