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

PATH=/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin

# if [ -f /etc/init.d/functions ];then
#   . /etc/init.d/functions
# fi


# /bin/bash -c "gerapy runserver 8001"
app_start(){
    isStart=`ps -ef|grep 'gerapy runserver' |grep -v grep|awk '{print $2}'`
    if [ "$isStart" == '' ];then
            echo -e "Starting gerapy... \c"

            mkdir -p /www/server/gerapy
            cd /www/server/gerapy
            echo "" > /www/server/gerapy/logs.pl
            echo "" > /www/server/gerapy/scrapyd.pl
            gerapy runserver > /www/server/gerapy/logs.pl 2>&1 &

            isStart=""
            while [[ "$isStart" == "" ]];
            do
                echo -e ".\c"
                sleep 0.5
                isStart=`ps -ef|grep 'gerapy runserver' |grep -v grep|awk '{print $2}'`
                let n+=1
                if [ $n -gt 15 ];then
                    break;
                fi
            done
            if [ "$isStart" == '' ];then
                    echo -e "\033[31mfailed\033[0m"
                    echo '------------------------------------------------------'
                    tail -n 20 /www/server/gerapy/logs.pl
                    echo '------------------------------------------------------'
                    echo -e "\033[31mError: gerapy service startup failed.\033[0m"
                    return;
            fi
            echo -e "\033[32mdone\033[0m"
    else
            echo "Starting gerapy... gerapy(pid $(echo $isStart)) already running"
    fi
}


app_stop(){
    echo -e "Stopping gerapy... \c"
    arr=`ps -ef | grep "gerapy runserver" | grep -v grep | awk '{print $2}'`
    for p in ${arr[@]}
    do
            kill -9 $p &>/dev/null
    done
    echo -e "\033[32mdone\033[0m"
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
