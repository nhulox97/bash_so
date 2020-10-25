#!/bin/sh

### BEGIN INIT INFO
# Provides: scriptdaemon
# Required-Start: $local_fs $network $syslog $ $remote_fs
# Required-Stop:
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Description: My little daemon
### END INIT INFO
 
NAME=scriptdaemon
DESC="Demonio de servicio"
PIDFILE="/var/run/${NAME}.pid"
LOGFILE="/var/log/${NAME}.log"

#indicamos que vamos a ejecutar un archivo Python
DAEMON="/bin/sh"
#Ruta del archivo
DAEMON_OPTS="/home/ismaelo/Documents/UNIVO/Ciclo_8/SO/tareas/LAB/script.sh" # esta ruta debe cambiar segun lo hayan guardado
 
START_OPTS="--start --background --make-pidfile --pidfile ${PIDFILE} --exec ${DAEMON} ${DAEMON_OPTS}"
STOP_OPTS="--stop --pidfile ${PIDFILE}"
 
test -x $DAEMON || exit 0
 
set -e
 
case "$1" in
    start)
        echo -n "Starting ${DESC}: "
        start-stop-daemon $START_OPTS >> $LOGFILE
        echo "$NAME."
        ;;
    stop)
        echo -n "Stopping $DESC: "
        start-stop-daemon $STOP_OPTS
        echo "$NAME."
        rm -f $PIDFILE
        ;;
    restart|force-reload)
        echo -n "Restarting $DESC: "
        start-stop-daemon $STOP_OPTS
        sleep 1
        start-stop-daemon $START_OPTS >> $LOGFILE
        echo "$NAME."
        ;;
    *)
        N=/etc/init.d/$NAME
        echo "Usage: $N {start|stop|restart|force-reload}" >&2
        exit 1
        ;;
esac
 
exit 0


