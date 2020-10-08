#!/bin/bash

current_dir=`pwd`

function show_menu() {
    echo '--------------Menu--------------'
    echo '(1). Crear un directorio'
    echo '(2). Crear un archivo'
    echo '(3). Brindar permisos'
    echo '(4). Listar directorios'
    echo '(5). Comprimir archivos de un directorio'
    echo '(6). Salir'
}

function dir_exists() {
    local result=''
    if [ -a $1 ]; then
        result='y'
        echo "$result" 
    else
        result='n'
        echo "$result" 
    fi
}

function file_exists() {
    local result=''
    if [ -f $1 ]; then
        result='y'
        echo "$result" 
    else
        result='n'
        echo "$result" 
    fi
}

function create_dir() {
    local dir=''
    local is_valid=0
    echo -e "\n################# Crear mi directorio ###################\n"
    while [ $is_valid -ne 1 ]; do
        read -p '-> Ingrese el nombre del directorio: ' dir
        if [[ $dir =~ ^[a-zA-Z0-9_.-]*$ ]]; then
            if [ -a $dir ]; then
                echo -e "\nEl directorio $dir ya existe, favor introducir un nombre diferente\n"
            else
                mkdir $dir
                echo -e "\nEl directorio $dir se creó correctamente en: $current_dir \n"
                is_valid=1
            fi
        else
            echo -e "\nNombre inválido no se permiten caracteres especiales ni espacios; por favor ingrese un nombre válido\n"
        fi
    done
}

function create_file() {
    local is_valid=0
    echo -e "\n################# Crear mi archivo ###################\n"
    while [ $is_valid -ne 1 ]; do
        read -p '-> Ingrese el nombre del archivo: ' file
        if [[ $file =~ ^[a-zA-Z0-9_.-]*$ ]]; then
            if [ -f $file ]; then
                echo -e "\nEl archivo $file ya existe, favor introducir un nombre diferente\n"
            else
                touch $file
                echo -e "Archivo antes de agregar linea\n-----------------\n"
                cat $file
                read -p "->Ingrese el texto de para el archivo $file: " line
                echo "$line" >> $file
                echo -e "Archivo despues de agregar linea\n-----------------\n"
                cat $file
                echo -e "\nEl archivo $file se creó correctamente en: $current_dir \n"
                is_valid=1
            fi
        else
            echo -e "\nNombre inválido no se permiten caracteres especiales ni espacios; por favor ingrese un nombre válido\n"
        fi
    done
}

function permissions_menu() {
    echo 'Menu de permisos'
    echo '(1). Permisos de lectura'
    echo '(2). Permisos de lectura y escritura'
    echo '(3). Permisos de lectura, escritura y ejecucion'
    echo '(4). Permisos de de escritura'
    echo '(5). Permisos de escritura y ejecucion'
    echo '(6). Permisos de ejecucion'
    echo '(7). Permisos de ejecucion y lectura'
    echo '(8). Ninguno'
}

function set_permissions(){
    case $1 in
        1)
            chmod +r $2;;
        2)
            chmod +rw $2;;
        3)
            chmod +rwx $2;;
        4)
            chmod +w $2;;
        5)
            chmod +wx $2;;
        6)
            chmod +x $2;;
        7)
            chmod +rx $2;;
    esac
}

# validar mediante input del usuario si es archivo o directorio
function give_permissions() {
    echo -e "\n################# Brindar permisos ###################\n"
    option=0
    while [ $option -ne 8 ]; do
        read -p '-> Ingrese el nombre del archivo o directorio al cual se brindarán los permisos: ' name
        if [[ $file =~ ^[a-zA-Z0-9_.-]*$ ]]; then
            read -p '-> Es un archivo o directorio? (a)rchivo (d)irectorio: ' search_option
            if [ $search_option = 'a' ]; then 
                if [ -f $name ]; then
                    permissions_menu
                    read -p "-> Ingrese el tipo de permisos a asignar al archivo: " option
                    if [ $option -ne 8 ]; then
                        echo -e "Permisos del archivo antes de cambiarlos"
                        echo `ls -l $name`
                        set_permissions "$option" "$name"
                        echo -e "Permisos del archivo despues de cambiarlos"
                        echo `ls -l $name`
                        option=8
                    fi 
                else
                    echo -e "\nEl Archivo no existe, si el archivo esta en otro directorio verificar si la ruta es correcta\n"
                fi
            elif [ $search_option = 'd' ]; then 
                if [ -a $name ]; then
                    permissions_menu
                    if [ $option -ne 8 ]; then
                    read -p "-> Ingrese el tipo de permisos a asignar al archivo: " option
                        echo -e "Permisos del archivo antes de cambiarlos"
                        echo `ls -ld $name`
                        set_permissions "$option" "$name"
                        echo -e "Permisos del archivo despues de cambiarlos"
                        echo `ls -ld $name`
                        option=8
                    fi 
                else
                    echo -e "\nEl directorio no existe, si el directorio esta en otro directorio verificar si la ruta es correcta\n"
                fi
            fi
        else
            echo - "\nIngresar un nombre de archivo o directorio valido\n"
        fi
    done
}

function list_dirs_and_files_by_route() {
    echo 'Funcion: list_dirs_and_files_by_route'
}

function compress_files() {
    echo 'Funcion: compress_files'
}

# Testing zone
# dir_exists "a"
# file_exists "a/c.txt"

menu_condition='s'

while [ $menu_condition != 'n' ]; do
    show_menu
    read -p '-> Ingrese su opcion: ' option
    case $option in
        1)
            create_dir;;
        2)
            create_file;;
        3)
            give_permissions;;
        4)
            list_dirs_and_files_by_route;;
        5)
            compress_files;;
        6)
            menu_condition='n';;
    esac
    if [ $option -ne 6 ]; then
        echo -e "\n"
        read -p '-> Desea realizar otra operacion? (s)i (n)o: ' menu_condition
        echo -e "\n"
    fi
done
