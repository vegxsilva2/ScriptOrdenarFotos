#!/usr/bin/bash

# Función para verificar si un directorio existe
function directorio_existe() {
  if [ ! -d "$1" ]; then
    echo "$1 no es un directorio"
    exit 1
  fi
}

# Obtener el directorio del primer argumento
directorio=$1

# Verificar si el directorio existe
#directorio_existe "$directorio"

# Recorrer el directorio y listar los archivos
for archivo in "$directorio"/*; do
  echo "$archivo"
done