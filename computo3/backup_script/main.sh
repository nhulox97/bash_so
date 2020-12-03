#!/bin/bash

db_name="$1"
password='dosv2018'
user='nhulox97'
current_dir=`pwd`
date=`date '+%Y%m%d-%H%M'`
receiver='ludwin.hernandezsv@gmail.com'

backups_dir="$HOME/backups"
logfile="$backups_dir/db-backup.log"

if ! [[ -a $backups_dir ]]; then
    mkdir $backups_dir 
    if ! [[ -a $logfile ]]; then
        touch $logfile
        echo 'Se creo el archivo de logs' >> $logfile
    fi
    echo 'Se creo el directorio de los backups' >> $logfile  
fi

mysql=`ps awx | grep 'mysql' |grep -v grep|wc -l`
if [ $mysql == 0  ]; then
    if [[ "$(whoami)" != root ]]; then
        echo 'Mysql esta detenido, pero el usuario no tiene permisos para reiniciar el servicio'
        exit 1
    else
        service mysql restart
        echo 'Se reinicio el servicio.' >> $logfile
    fi
fi

find $backups_dir/[a-z]* -name \*.sql -mtime +3 -exec rm {} \;
find $backups_dir/[a-z]* -name \*.tar.bz2 -mtime +3 -exec rm {} \;
echo "Se eliminaron los archivos que tengas ms de tres días de haberse modificado" >> $logfile

mysqldump --user=$user --password=$password $db_name > $backups_dir/dump-$db_name-$date.sql
echo "Se creo el dump: dump-$db_name-$date.sql" >> $logfile

backup_file="backup-$db_name-$date.tar.bz2"
cd $backups_dir && tar -cvzf $backup_file *.sql db-backup.log && 
    echo "Se creo el backup: $backup_file" >> $logfile

echo "Database: $db_name. Date: $date" | mutt -a "$backup_file" -s "Backup: $db_name" -- $receiver
cd $current
exit 0
