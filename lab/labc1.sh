#!/bin/bash

current_dir=`pwd`

function menu() {
    echo '-------------- Menu de opciones --------------'
    echo '(1). Crear un usuario'
    echo '(2). Brindar permisos'
    echo '(3). Matar proceso'
    echo '(4). Salir'
}

function add_user() {
    echo 'Add user'
} 

function give_permissions() {
    echo 'Give permmissions'
}

function kill_process() {
    echo 'Kill process'
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
            read -p '=> Desea realizar otra operacion? (s)i (n)o: ' menu_condition
            echo -e "\n"
        fi
        clear
    done
}
 main
