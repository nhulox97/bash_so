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
    local is_valid=0
    echo -e "################# Crear mi directorio ###################\n"
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
    echo -e "################# Crear mi archivo ###################\n"
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

function give_permissions() {
    echo -e "################# Brindar permisos ###################\n"
    option=0
    while [ $option -ne 8 ]; do
        read -p '-> Ingrese el nombre del archivo o directorio al cual se brindarán los permisos: ' name
        if [[ $file =~ ^[\\/a-zA-Z0-9_.-]*$ ]]; then
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
            elif [ -a $name ]; then
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
                echo -e "\nEl directorio o archivo no existe, si el directorio o archivo esta en otro directorio verificar si la ruta es la correcta\n"
            fi

        else
            echo -e "\nIngresar un nombre de archivo o directorio valido\n"
        fi
    done
}

function list_dirs_and_files_by_route() {
    local is_valid=0
    echo -e "################# Listar mi directorio ###################\n"
    while [ $is_valid -ne 1 ]; do
        read -p '-> Ingrese el nombre del directorio: ' dir
        if [[ $dir =~ ^[\\/a-zA-Z0-9_.-]*$ ]]; then
            check_dir=$(dir_exists $dir)
            if [ $check_dir = 'y' ]; then
                # dir_listed=`ls -lh --block-size=MB $dir`
                echo '###############################################'
                echo -e "Lista de archivos y directorios del directorio: $dir\n"
                # echo $dir_listed
                ls -lh --block-size=MB $dir
                echo -e "\n"
                is_valid=1
            elif [ $check_dir = 'n' ]; then
                echo -e "\nEl directorio $dir no existe, favor verificar la ruta"
            fi
        else
            echo -e "\nIngresar un nombre de archivo o directorio valido\n"
        fi
    done
}

function compression_menu() {
    echo -e "\n========Seleccione el tipo de compresión"
    echo '(1). zip'
    echo '(2). tar'
}

function do_compress() {
    echo -e "\n"
    read -p "-> Ingrese el nombre que le asignará al comprimido: " filename
    if [ $1 -eq 1 ]; then
        # zip compression
        compress=`zip -r $3/$filename.zip $2`
        echo -e "\nEl directorio $2 se comprimió en $3/$filename.zip"
    elif [ $1 -eq 2 ]; then
        # tar compression
        compress=`tar -cvf $3/$filename.tar $2`
        echo -e "\nEl directorio $2 se comprimió en $3/$filename.zip"
    fi
}

function compress_files() {
    local is_valid=0
    echo -e "################# Comprimir mi directorio ###################\n"
    while [ $is_valid -ne 1 ]; do
        # Solicitando directorio origen
        read -p '-> Ingrese el nombre del directorio a comprimir: ' org_dir
        # validando rura
        if [[ $org_dir =~ ^[\\/a-zA-Z0-9_.-]*$ ]]; then
            check_dir=$(dir_exists $org_dir)
            if [ $check_dir = 'y' ]; then
                # Solicitando directorio destino
                echo -e "\n"
                read -p "-> Ingrese la ruta en donde se almacenará el comprimido, si desea guardar el comprimido en la misma carpeta escriba 'origen': " dest_dir
                # comprimir en carpeta origen
                if [ $dest_dir = 'origen' ]; then
                    compression_menu    
                    read -p '-> Ingrese su opción: ' option
                    echo $option
                    result="$(do_compress $option $org_dir $org_dir)"
                    clear
                    echo $result
                    is_valid=1
                    # comprimir en otra ruta 
                elif [[ $dest_dir =~ ^[\\/a-zA-Z0-9_.-]*$ ]]; then
                    check_dir=$(dir_exists $dest_dir)
                    if [ $check_dir = 'y' ]; then
                        compression_menu    
                        read -p '-> Ingrese su opción: ' option
                        echo $option
                        result="$(do_compress $option $org_dir $dest_dir)"
                        clear
                        echo $result
                        is_valid=1
                    elif [ $check_dir = 'n' ]; then
                        echo -e "\nEl directorio destino $dest_dir no existe, favor verificar la ruta"
                    fi
                else
                    echo -e "\nIngresar un nombre de archivo o directorio valido\n"
                fi
            elif [ $check_dir = 'n' ]; then
                echo -e "\nEl directorio origen $org_dir no existe, favor verificar la ruta"
            fi
        else
            echo -e "\nIngresar un nombre de archivo o directorio valido\n"
        fi
    done
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
            clear
            create_dir;;
        2)
            clear
            create_file;;
        3)
            clear
            give_permissions;;
        4)
            clear
            list_dirs_and_files_by_route;;
        5)
            clear
            compress_files;;
        6)
            clear
            menu_condition='n';;
    esac
    if [ $option -ne 6 ]; then
        read -p '-> Desea realizar otra operacion? (s)i (n)o: ' menu_condition
        echo -e "\n"
    fi
    clear
done
