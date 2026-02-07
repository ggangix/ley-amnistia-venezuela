#!/usr/bin/env bash
set -euo pipefail

# Script para verificar si los documentos del servidor han cambiado
# Compara el hash SHA256 del archivo en el servidor con el archivo local

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMP_FILE=$(mktemp)
trap "rm -f $TEMP_FILE" EXIT

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sin color

# Documentos a verificar (carpeta|url|hash_esperado)
DOCUMENTOS=(
    "ley-de-amnistia|https://www.asambleanacional.gob.ve/storage/documentos/documentos/proyecto-de-ley-de-amnistia-20260207004109.pdf|aea6e5f2c6805195d03d4ba388b09c2a78913982be56de0e9573406a650ace77"
    "consulta-de-ley|https://www.asambleanacional.gob.ve/storage/documentos/documentos/planilla-de-consulta-de-ley-de-amnistia-20260207004157.pdf|484ec052d95ae62298d0c677cbd15fcf61f773da76f49be9ccdc53e759bff1a7"
)

echo "======================================"
echo "  Verificador de Documentos Amnistía"
echo "  $(date '+%Y-%m-%d %H:%M:%S')"
echo "======================================"
echo ""

CAMBIOS=0
ERRORES=0

for doc in "${DOCUMENTOS[@]}"; do
    IFS='|' read -r CARPETA URL HASH_ESPERADO <<< "$doc"

    echo "Verificando: $CARPETA"
    echo "  URL: $URL"

    # Descargar archivo del servidor
    if ! curl -s -L -k -o "$TEMP_FILE" "$URL" 2>/dev/null; then
        echo -e "  ${RED}ERROR: No se pudo descargar${NC}"
        ((ERRORES++))
        echo ""
        continue
    fi

    # Calcular hash del archivo descargado
    HASH_SERVIDOR=$(shasum -a 256 "$TEMP_FILE" | cut -d' ' -f1)

    echo "  Hash local:    $HASH_ESPERADO"
    echo "  Hash servidor: $HASH_SERVIDOR"

    if [ "$HASH_SERVIDOR" = "$HASH_ESPERADO" ]; then
        echo -e "  ${GREEN}✓ SIN CAMBIOS${NC}"
    else
        echo -e "  ${RED}✗ ¡DOCUMENTO MODIFICADO!${NC}"
        ((CAMBIOS++))

        # Guardar el nuevo archivo para comparación
        BACKUP_DIR="$SCRIPT_DIR/$CARPETA/cambios"
        mkdir -p "$BACKUP_DIR"
        FECHA=$(date '+%Y%m%d-%H%M%S')
        cp "$TEMP_FILE" "$BACKUP_DIR/file-$FECHA.pdf"
        echo "$HASH_SERVIDOR  file-$FECHA.pdf" > "$BACKUP_DIR/sha256-$FECHA.txt"
        echo -e "  ${YELLOW}Nuevo archivo guardado en: $BACKUP_DIR/file-$FECHA.pdf${NC}"
    fi
    echo ""
done

echo "======================================"
echo "  Resumen"
echo "======================================"
echo "  Documentos verificados: ${#DOCUMENTOS[@]}"
echo "  Cambios detectados: $CAMBIOS"
echo "  Errores: $ERRORES"

if [ $CAMBIOS -gt 0 ]; then
    echo ""
    echo -e "${RED}¡ALERTA! Se detectaron cambios en $CAMBIOS documento(s)${NC}"
    exit 1
elif [ $ERRORES -gt 0 ]; then
    echo ""
    echo -e "${YELLOW}Hubo $ERRORES error(es) al verificar${NC}"
    exit 2
else
    echo ""
    echo -e "${GREEN}Todos los documentos están intactos${NC}"
    exit 0
fi
