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
    exec_user=`sudo useradd -m -s /bin/bash -p $password $user`
    # Verificamos si el usario se creo a travez de validar si el directorio
    # /home/$user existe
    check_dir=$(dir_exists /home/$user)
    if [ $check_dir = 'y' ]; then
        echo 'El usuario se creó correctamente.'
    else
        echo 'Error al crear.'
    fi    
} 

function menu_permissions_with_numbers() {
    echo '####### Tipos de permisos #######'
    echo 'Ejecución (--x) = 1'
    echo 'Escritura (-w-) = 2'
    echo 'Escritura y Ejecución ('-wx') = 3'
    echo 'Lectura (r--) = 4'
    echo 'Lectura y Ejecución (r-x) = 5'
    echo 'Lectura y Escritura (rw-) = 6'
    echo 'Lectura, Escritura y Ejcución (rwx) = 7'
    echo 'Los permisos deben ser asignados bajo el formato:'
    echo 'Permisos del propietario | Permisos del grupo del propietario | Permisos para otros'
}

function existe(){
    if [ -a $1 ]; then
        echo 'e'
    else
        echo 'ne'
    fi
}

function validarPermisos(){
    if [[ $1 =~ ^[wrx]*$ ]]; then
        echo 'valid'
    else
        echo 'invalid'
    fi
}

function permit_letters(){
    repeat='s'
    while [ $repeat = 's' -o $repeat = 'S' ]; do

        read -p "Ingrese los permisos que se quieren otorgar (w=escribir, r=leer, x=ejecutar), sin espacios entre iniciales: " permiso
        verificar=$(validarPermisos $permiso)
        if [ $verificar = 'valid' ]; then

            while [ $repeat = 's' -o $repeat = 'S' ]; do
                read -p "Ingrese el nombre del archivo o directorio: " file_directory
                existe=$(existe $file_directory)
                if [ $existe = 'e' ]; then
                    repeat='n'
                    sudo chmod a+$permiso $file_directory
                    echo "======================================"
                    echo "Permisos modificados..."
                    echo "======================================"
                else
                    echo "Directorio o archivo no existe..."
                    read -p "Desea ingresar otro nombre de archivo o directorio (S/N): " repeat
                fi
            done
        else
            echo "Iniciales de permisos no válidos..."
            read -p "Desea ingresar otros permisos (S/N): " repeat
        fi

    done

}

function give_permissions_with_numbers() {
    local is_valid=0
    while [ $is_valid -ne 1 ]; do
        read -p '> Ingrese la ruta hacia archivo: ' file
        if [[ $file =~ ^[\\/a-zA-Z0-9_.-]*$ ]]; then
            if [ -a $file ]; then
                echo ''
                echo '####### Tipos de permisos #######'
                echo 'Ejecución (--x) = 1'
                echo 'Escritura (-w-) = 2'
                echo 'Escritura y Ejecución ('-wx') = 3'
                echo 'Lectura (r--) = 4'
                echo 'Lectura y Ejecución (r-x) = 5'
                echo 'Lectura y Escritura (rw-) = 6'
                echo 'Lectura, Escritura y Ejcución (rwx) = 7'
                echo 'Los permisos deben ser asignados bajo el formato:'
                echo 'Permisos del propietario | Permisos del grupo del propietario | Permisos para otros'
                read -p 'Ingrese los permisos para el propietario: ' p1
                read -p 'Ingrese los permisos para el grupo del propietario: ' p2
                read -p 'Ingrese los permisos para los otros: ' p3
                permissions=$p1$p2$p3
                echo ''
                echo '_____________________________________________________'
                echo 'Asignando permisos'
                sudo chmod $permissions $file
                echo '_____________________________________________________'
                echo 'Permisos asignados correctamente'
                ls -ll $file
                echo ''
                is_valid=1
            else
                echo 'El archivo no existe'
            fi
        else 
            echo 'Error: por favor ingrese un nombre de archivo válido.'
        fi
    done
}

function give_permissions() {
    echo '################### Menu de permisos ###################'
    echo '(1). Asignar permisos con letras.'
    echo '(2). Asignar permisos con numeros.'
    read -p '> Seleccione su opción: ' option

    case $option in 
        1) 
            echo 'Permisos con letras';;
        2)
            give_permissions_with_numbers;;
        *)
            echo 'Opcion incorrecta'
            echo 'Saliendo...';;
    esac
}

function kill_process() {
    local proc='n'
    echo '################### Matar un proceso ###################'
    while [ $proc != 's' ]; do
        read -p 'Ingrese el nombre del proceso: ' proc_name
        proc_search=`ps hf -opid -C $proc_name | awk '{ print $1; exit }'`
        if [ ! -z $proc_search ]; then
            ps aux | grep $proc_name
            echo -e "\nIngrese el pid del proceso que desea matar: "
            read -p '> ' proc_id
            echo -e "Proceso a matar: \n"
            ps -Flww -p $proc_id
            echo 'Esta seguro de matar el proceso $proc_name: (s)i (no)'
            read -p '> ' proc_option
            if [ $proc_option = 's' -o $proc_option = 'S' ]; then
                kill -9 $proc_id
                echo 'El proceso se mato correctamente'
                proc='s'
            else 
                proc='s'
            fi
        else
            echo -e "\nError: el proceso $proc_name no esta en ejecucion"
            echo -e "Por favor ingresar el nombre de un proceso en ejecucion\n"
            proc='n'
        fi
    done
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
