#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_US.UTF-8


startTime=`date +%s`


pip3 install gerapy
pip3 install scrapyd


rm -rf /www/server/mdserver-web/plugins/gerapy

# if [ ! -d /www/server/mdserver-web/plugins/gerapy ];then
wget -O /tmp/master.zip https://codeload.github.com/midoks/mw-gerapy/zip/main
cd /tmp && unzip /tmp/master.zip
mv /tmp/mw-gerapy-main /www/server/mdserver-web/plugins/gerapy
rm -rf /tmp/master.zip
rm -rf /tmp/mw-gerapy-main
# fi



mkdir -p /www/server/gerapy
rm -rf /www/server/gerapy/init.d
echo "0.9.7" > /www/server/gerapy/version.pl
echo "" > /www/server/gerapy/logs.pl
echo "" > /www/server/gerapy/scrapyd.pl


cd /www/server/gerapy

if [ ! -d /www/server/gerapy/dbs ];then
	gerapy init
	gerapy migrate
fi

echo "[scrapyd] 
eggs_dir    = eggs
logs_dir    = logs
items_dir   =
jobs_to_keep = 5  
dbs_dir     = dbs
max_proc    = 0
max_proc_per_cpu = 10  
finished_to_keep = 100
poll_interval = 5.0
bind_address = 0.0.0.0
http_port   = 6888
debug       = off
runner      = scrapyd.runner
application = scrapyd.app.application   
launcher    = scrapyd.launcher.Launcher
webroot     = scrapyd.website.Root

[services]
schedule.json     = scrapyd.webservice.Schedule
cancel.json       = scrapyd.webservice.Cancel
addversion.json   = scrapyd.webservice.AddVersion
listprojects.json = scrapyd.webservice.ListProjects
listversions.json = scrapyd.webservice.ListVersions
listspiders.json  = scrapyd.webservice.ListSpiders  
delproject.json   = scrapyd.webservice.DeleteProject   
delversion.json   = scrapyd.webservice.DeleteVersion
listjobs.json     = scrapyd.webservice.ListJobs
daemonstatus.json = scrapyd.webservice.DaemonStatus
" > /www/server/gerapy/scrapyd.conf 

# gerapy createsuperuser

cd /www/server/mdserver-web/ && python3 /www/server/mdserver-web/plugins/gerapy/index.py start

endTime=`date +%s`

((outTime=($endTime-$startTime)/60))
echo -e "Time consumed:\033[32m $outTime \033[0mMinute!"

