#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_US.UTF-8


startTime=`date +%s`


pip3 install gerapy
pip3 install scrapyd


if [ ! -d /www/server/mdserver-web ];then
	wget -O /tmp/master.zip https://codeload.github.com/midoks/mw-gerapy/zip/main
	cd /tmp && unzip /tmp/master.zip
	mv /tmp/mw-gerapy-main /www/server/mdserver-web/plugins/mw-gerapy
	rm -rf /tmp/master.zip
	rm -rf /tmp/mw-gerapy-master
fi


endTime=`date +%s`

((outTime=($endTime-$startTime)/60))
echo -e "Time consumed:\033[32m $outTime \033[0mMinute!"

