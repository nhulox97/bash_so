#!/bin/bash

get_files(){
    # Obtengo todos los archivos con las extensiones requeridas
    files=`ls $HOME | awk '/^.*\.(odt|odp|sh|txt)$/{print $0}'`
    # Sepro los archivos por un espacio, esto ayudara paraa convertir el
    # output en un array
    files=`echo "$files" | awk '{printf "%s%s",sep,$0; sep=" "} END{print ""}'`
    # Retornamos el resultado
    echo "$files"
}

# Obtenemos los archivos
distros=get_files
# Convertimos el output de la funcion en un array. Se hace bajo el formato:
# ($cadena) "Notese que los archivos deben estar separados por un espacio"
distros=($distros)
# recorremos el array para comprobar que la cadena se convirtio en array, deberia imprimir
# los resultados uno por linea
for i in "${distros[@]}"
do
    echo $i
done
