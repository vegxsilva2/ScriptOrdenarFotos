#!/usr/bin/bash

# Función para verificar si el parametro que se le pasa es un un directorio (Si no lo es, lo dice y termina
function es_directorio() {
  if [ ! -d "$1" ]; then
    echo "$1 no es un directorio"
    exit 1
  fi
}

#Función para verificar que el archivo es una imagen
function es_imagen() {

  res=-1

  #Obtener el tipo de archivo MIME
  tipo_archivo=$(file -b --mime-type "$1")

  #Tipos de archivo MIME correspondiente a imágenes
  tipos_imagen=(
    "image/jpeg"
    "image/png"
    "image/gif"
    "image/bmp"
    "image/tiff"
    "image/webp"
  )

#Obtener el tipo de archivo MIME
  tipo_archivo=$(file -b --mime-type "$1")

  #Tipos de archivo MIME correspondiente a imágenes
  tipos_imagen=(
    "image/jpeg"
    "image/png"
    "image/gif"
    "image/bmp"
    "image/tiff"
    "image/webp"
  )

  for tipo_imagen in "${tipos_imagen[@]}"; do
          if [[ "$tipo_archivo" == "$tipo_imagen" ]]; then
              res=0
          fi
  done

  if [ "$res" == 0 ]; then
    return 0
  else
    return 1
  fi
}

#Función que comprueba si en el directorio ya existe una carpeta 'otros', y en caso contrario la crea
function carpeta_otros() {

  res="$1"

  if [ ! -d "$res"/otros ]; then
     mkdir "$res"/otros
  fi
}

function carpeta_anio() {
  res="$1"
  a="$2"

  if [ ! -d "$res"/"$a" ]; then
    mkdir "$res"/"$a"
  fi
}



# Obtener el directorio del primer argumento
directorio=$1

# Verificar si el directorio existe
es_directorio "$directorio"

#Comprobamos si ya existe nuestra carpeta auxiliar 'otros', en caso contrario se crea
carpeta_otros "$directorio"


# Recorrer el directorio archivo a archivo
for archivo in "$directorio"/*; do
    #Comprobamos si el archivo es una imagen
      if es_imagen "$archivo" ; then
        fecha=$(exiftool "$archivo" | grep "Date/Time Original")

        #Si no se puede acceder a la fecha de creación de la foto (como con fotos descargadas por ejemplo),
        #se crea una carpeta 'otros' donde se van a meter todas
        if [ -z "$fecha" ]; then
          mv "$archivo" "$directorio"/otros
        else
          anio=$(echo "$fecha" | awk '{print $4}' | cut -d':' -f1)
          carpeta_anio "$directorio" "$anio"
          mv "$archivo" "$directorio"/"$anio"
        fi

      fi

done