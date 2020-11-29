#!/bin/bash

#variables globales
current=`pwd`
date=`date '+%Y-%m-%d'`
hour=`date '+%H-%M'`
date_hour=`date '+%Y-%m-%d-%H-%M'`
date_hour_letter=`date '+%a-%b-%Y %H:%M'`
backups_dir="$HOME/backups"
log_file="$backups_dir/logbackup.log"

#validar si existe un archivo o directorio
exist(){
    if [ -a $1 ]; then 
        echo 'e'
    else 
        echo 'ne'
    fi
}

add_log(){
    action=$1
    msg=$2
    echo "$action, $msg, $date_hour" >> $log_file
}

# Si el log no existe, crear archivo log en $HOME/backups
check_log_file(){
    check=$(exist "$log_file")
    if [ $check = 'ne' ]; then
        touch $log_file
        add_log "Create" "Se creo el archivo de logs"
    fi
}

# crear el directorio para los backups si no existe
check_backups_dir(){
    check=$(exist "$backups_dir")
    if [ $check = 'ne' ]; then
        mkdir $backups_dir
        add_log "Create" "Se creo el directorio backups en $backups_dir"
    fi
}

#Obtener los nombre de los archivos cuyas extenciones coincidan con la busqueda
#Retorna un string con cada nombre separado por un espacio
get_files(){
    # Obtengo todos los archivos con las extensiones requeridas
    local files=`ls $HOME | awk '/^.*\.(odt|odp|sh|txt)$/{print $0}'`
    # Separar los archivos por un espacio, esto ayudara a convertir el
    # output en un files
    local files=`echo "$files" | awk '{printf "%s%s",sep,$0; sep=" "} END{print ""}'`
    echo "$files"
}

# Verificar si los archivos retornados por get_files existan en un directorio determinado
# Si existen, preguntar al usuario si los desea reescribir; si el usuario decide reescribirlo, 
# guardar el nombre en un files. Aquellos archivos que no existan dentro de $HOME/backups seran
# almacenados por defecto dentro del files.
check_files(){
    #Se convierte a files el string
    local files=($1)
    selected_files=()
    i=0
    sf_i=0
    for file in "${files[@]}"
    do  
        file_route="$backups_dir/$file"
        existe=$(exist "$file_route")
        if [ $existe = 'e' ]; then
            read -p "Desea sobreescribir el archivo $file ? s(i) n(o): " rewrite
            if [ $rewrite = 's' ]; then
                selected_files[$sf_i]="${files[$i]}"
                sf_i=$sf_i+1
                add_log "Update" "Se actualizo en el backup el archivo $file"
            fi
        else 
            selected_files[$sf_i]="${files[$i]}"
            sf_i=$sf_i+1
            add_log "Add" "Se agrego al backup el archivo $file"
        fi
        i=$i+1
    done
    echo "${selected_files[@]}"
}

# Recibe la lista de los nombres de los archivos que fueron seleccionados para hacer el
# respectivo backup
copy_files(){
    local files=($1)
    add_log "Copy" "Se copiaron los archivos dentro de backups: $files"
    for file in "${files[@]}"
    do
        file="$HOME/$file"
        cp "$file" "$backups_dir"
    done
}

# crear el backup bajo el formato: backup-year-month-day-hour
do_backup(){
    local files=($1)
    for i in ${!files[@]}; do
        files[$i]="../${files[$i]}"
    done
    backup_file="backup-$date_hour.tar.bz2"
    cd $backups_dir && tar -cvzf $backup_file ${files[@]} && cd $current
    add_log "Create" "Se creo el backup: $backup_file"
}


option=$1
case $option in
    mail)
        # send log to mail
        subject="Logfile: backup-$date_hour"
        receiver='rauleduardovigil@gmail.com'
        echo "Archivo log." | mutt -a "$log_file" -s "$subject" -- $receiver 
        add_log "Mail" "Se envio el mail al logfile"
        # clean files
        find $backups_dir/backup* -mtime +3 -exec rm {} \;
        add_log "Clean" "Se limpiaron los backups con 3 dias de antiguedad"
        ;;
    backup)
        # verificar si el log existe, si no, crearlo
        check_log_file
        # verificar si el directorio backups existe
        check_backups_dir
        # get files from $HOME
        files=$(get_files)
        # Verificar que archivos se van a copiar/reescribir en backups
        files=$(check_files "$files")
        # echo "$files"
        # Copiar en backups los archivos que fueron seleccionados
        copy_files "$files"
        # Realizar el backup
        do_backup "$files"
        ;;
esac
