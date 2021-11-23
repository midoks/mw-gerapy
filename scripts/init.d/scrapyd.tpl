#!/bin/sh
# chkconfig: 2345 55 25
# description: scrapyd Service

### BEGIN INIT INFO
# Provides:          scrapyd
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts scrapyd
# Description:       starts the MDW-Web
### END INIT INFO


app_start(){
    mkdir -p /www/server/gerapy
    nohup scrapyd > /www/server/gerapy/scrapyd.pl 2>&1 &
    echo "scrapyd started"
}
app_stop(){
    echo "Stopping ..."
    ps -ef | grep "python scrapyd" | grep -v grep | awk '{print $2}' | xargs kill
    echo "scrapyd stopped"
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
