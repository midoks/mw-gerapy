#!/bin/sh
# chkconfig: 2345 55 25
# description: gerapy Service

### BEGIN INIT INFO
# Provides:          gerapy
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts gerapy
# Description:       starts the MDW-Web
### END INIT INFO


app_start(){
    mkdir -p /www/server/gerapy
    echo "" > /www/server/gerapy/logs.pl
    echo "" > /www/server/gerapy/scrapyd.pl
    
    nohup gerapy runserver > /www/server/gerapy/logs.pl 2>&1 &
    echo "gerapy started"
}
app_stop(){
    echo "Stopping ..."
    arr=`ps -ef | grep "python gerapy" | grep -v grep | awk '{print $2}' | xargs kill`
    for p in ${arr[@]}
    do
            kill -9 $p &>/dev/null
    done
    echo "gerapy stopped"
}


case "$1" in
    start)
        app_start
        ;;
    stop)
        app_stop
        ;;
    restart|reload)
        app_stop
        sleep 0.3
        app_start
        ;;
    *)
        echo "Please use start or stop as first argument"
        ;;
esac
