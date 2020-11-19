#!/bin/bash
usr=$(hostname)
current_date=`date +"%Y-%m-%d %T"`

show_menu() {
    echo '----------------- Menu -----------------'
    echo '(1). Enviar Mail'
    echo '(2). Salir'
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

practica1() {
    echo '----------------- Enviar mail -----------------'
    read -p '=> Ingrese el email destinatario: ' receiver
    read -p '=> Ingrese el asunto del mail: ' subject
    read -p '=> Ingrese el contenido del mail: ' content
    read -p '=> Desea adjuntar un archivo? (s)i, (n)o: ' need_file
    local file_option='s'
    while [ $file_option = 's' ]; do
        if [ $need_file = 's' ]; then 
            local valid_file_name='s'
            while [ $valid_file_name = 's' ]; do
                read -p '=> Ingrese la ruta hacia el archivo a enviar (incluyendo el archivo en cuestion): ' file
                if [[ $file =~ ^[\\/a-zA-Z0-9_.-]*$ ]]; then
                    check_file=$(file_exists $file)
                    if [ $check_file = 'y' ]; then
                        echo $content | mutt -a "$file" -s "$subject" -- $receiver 
                        echo 'Email enviado correctamente'
                        valid_file_name='n'
                        file_option='n'
                    else
                        echo 'El archivo no existe'
                        echo 'Por favor verificar que la ruta y el nombre del archivo sean correctos'
                    fi
                else
                    echo 'Nombre invalido'
                    echo 'Favor ingresar un nombre valido'
                fi
            done
            file_option='n'
        elif [ $need_file = 'n' ]; then 
            subject="$subject. usr: $usr, date: $current_date"
            echo $content | mail -s "$subject" $receiver
            echo 'Email enviado correctamente'
            file_option='n'
        else
            echo 'Opcion invalida'
        fi 
    done
}

main(){
    menu_condition='s'
    while [ $menu_condition = 's' ]; do
        show_menu
        read -p '=> Ingrese su opcion: ' option
        case $option in
            1)
                clear
                practica1;;
            2)
                clear
                menu_condition='n';;
        esac
        if [ $option -ne 2 ]; then
            echo -e "\n##############################################################################"
            read -p '=> Desea realizar otra operacion? (s)i (n)o: ' menu_condition
            echo -e "\n"
        fi
        clear
    done
}

main

