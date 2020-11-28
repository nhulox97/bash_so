#!/bin/bash

#variables generales
current=`pwd`
date=`date '+%Y-%m-%d'`
hour=`date '+%H-%M'`
date_hour=`date '+%Y-%m-%d-%H-%M'`
date_hour_letter=`date '+%a-%b-%Y %H:%M'`
log_file="/var/log/testlog.log"

#validar si existe un archivo o directorio
exist(){
    if [ -a $1 ]; then 
        echo 'e'
    else 
        echo 'ne'
    fi
}

#Obtener los nombre de los archivos cuyas extenciones coincidan con la busqueda
#Retorna un string con cada nombre separado por un espacio
get_files(){
    # Obtengo todos los archivos con las extensiones requeridas
    files=`ls $HOME | awk '/^.*\.(odt|odp|sh|txt)$/{print $0}'`
    # Separar los archivos por un espacio, esto ayudara a convertir el
    # output en un array
    files=`echo "$files" | awk '{printf "%s%s",sep,$0; sep=" "} END{print ""}'`
    echo "$files"
}

# Verificar si los archivos retornados por get_files existan en un directorio determinado
# Si existen, preguntar al usuario si los desea reescribir; si el usuario decide reescribirlo, 
# guardar el nombre en un array. Aquellos archivos que no existan dentro de $HOME/backups seran
# almacenados por defecto dentro del array.
check_files(){
    #Se convierte a array el string
    files=($1)
    selected_files=()
    i=0
    sf_i=0
    for file in "${files[@]}"
    do  
        file_route="$HOME/backups/$file"
        existe=$(exist "$file_route")
        if [ $existe = 'e' ]; then
            read -p "Desea sobreescribir el archivo $file ? s(i) n(o): " rewrite
            if [ $rewrite = 's' ]; then
                selected_files[$sf_i]="${files[$i]}"
                sf_i=$sf_i+1
            fi
        else 
            selected_files[$sf_i]="${files[$i]}"
            sf_i=$sf_i+1
        fi
        i=$i+1
    done
    echo "${selected_files[@]}"
}

# get files from $HOME
files=$(get_files)
# Verificar que archivos se van a copiar/reescribir en backups
file=$(check_files "$files")

