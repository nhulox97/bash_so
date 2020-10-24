#!/bin/bash

current_dir=`pwd`

function menu() {
    echo '-------------- Menu de opciones --------------'
    echo '(1). Crear un usuario'
    echo '(2). Brindar permisos'
    echo '(3). Matar proceso'
    echo '(4). Salir'
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

function add_user() {
    read -p 'Ingrese el nombre del usuario: ' user 
    read -p 'Ingrese la contraseña del usuario: ' password
    exec_user=`sudo useradd -p $password -m $user`
    # Verificamos si el usario se creo a travez de validar si el directorio
    # /home/$user existe
    check_dir=$(dir_exists /home/$user)
    if [ $check_dir = 'y' ]; then
        echo 'El usuario se creó correctamente.'
    else
        echo 'Error al crear.'
    fi    
} 

function give_permissions() {
    echo 'Give permmissions'
}

function kill_process() {
    read 'Ingrese el nombre del usuario: ' user 
    sudo adduser $user
}

function main() {
    local main_option='s'

    while [ $main_option != 'n' ]; do
        menu
        read -p '=> Ingrese su opcion: ' option
        case $option in
            1)
                clear
                add_user;;
            2)
                clear
                give_permissions;;
            3)
                clear
                kill_process;;
            4)
                clear
                main_option='n';;
        esac
        if [ $option -ne 4 ]; then
            read -p '=> Desea realizar otra operacion? (s)i (n)o: ' main_option
            echo -e "\n"
        fi
        clear
    done
}
main
