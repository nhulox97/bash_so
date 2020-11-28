#!/bin/bash

current=`pwd`

get_files(){
    # Obtengo todos los archivos con las extensiones requeridas
    files=`ls $HOME | awk '/^.*\.(odt|odp|sh|txt)$/{print $0}'`
    # Sepro los archivos por un espacio, esto ayudara paraa convertir el
    # output en un array
    files=`echo "$files" | awk '{printf "%s%s",sep,$0; sep=" "} END{print ""}'`
    # Retornamos el resultado
    echo "$files"
}

file_exists() {
    local result=''
    if [ -f $1 ]; then
        result='y'
        echo "$result" 
    else
        result='n'
        echo "$result" 
    fi
}

files=$(get_files)
# Convertimos el output de la funcion en un array. Se hace bajo el formato:
# ($cadena) "Notese que los archivos deben estar separados por un espacio"
# files=($files)
# recorremos el array para comprobar que la cadena se convirtio en array, deberia imprimir
# los resultados uno por linea
# for i in "${files[@]}"
# do
#    check_file=$(file_exists "$HOME/$i")
#    if [ $check_file = 'y' ]; then
#        echo 'Existe'
#    else
#        echo 'No existe'
#    fi
# done

compress_files(){
    array=($1)
    for i in ${!array[@]}; do
        array[$i]="../${array[$i]}"
    done
    cd $HOME/backups && tar -cvf test1.tar "${array[@]}" && cd $current
}

compress_files "$files"
