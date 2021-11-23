#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_US.UTF-8


pip3 install gerapy
pip3 install scrapyd




endTime=`date +%s`
((outTime=($endTime-$startTime)/60))
echo -e "Time consumed:\033[32m $outTime \033[0mMinute!"