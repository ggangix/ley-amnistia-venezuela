# Ley de Amnistía Venezuela - Archivo de Evidencias

Repositorio para la preservación y verificación de documentos oficiales relacionados con la Ley de Amnistía publicados por la Asamblea Nacional de Venezuela.

Inicialmente en estas urls:

- Proyecto de Ley de Amnistía: https://www.asambleanacional.gob.ve/storage/documentos/documentos/proyecto-de-ley-de-amnistia-20260207004109.pdf
- Planilla de Consulta de Ley de Amnistía: https://www.asambleanacional.gob.ve/storage/documentos/documentos/planilla-de-consulta-de-ley-de-amnistia-20260207004157.pdf


## Documentos Archivados

| Documento | Fecha | SHA256 |
|-----------|-------|--------|
| [Proyecto de Ley de Amnistía](/ley-de-amnistia/) | 2026-02-07 | `aea6e5f2...` |
| [Planilla de Consulta](/consulta-de-ley/) | 2026-02-07 | `484ec052...` |


## Verificación de Autenticidad

Cada documento incluye:

- **SHA256**: Hash criptográfico para verificar integridad
- **EXIF/Metadatos**: Información del PDF original
- **URL fuente**: Enlace al documento en asambleanacional.gob.ve

### Verificar un documento

```bash
# Descargar el documento
curl -L -k -o file.pdf "<URL_DEL_DOCUMENTO>"

# Calcular hash SHA256
shasum -a 256 file.pdf

# Comparar con el hash esperado en el README del documento
```

## Monitoreo de Cambios

El script `verificar.sh` permite detectar si los documentos en el servidor han sido modificados.

### Uso

```bash
./verificar.sh
```


## Fuentes

- Asamblea Nacional de Venezuela: https://www.asambleanacional.gob.ve
