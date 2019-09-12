#!/bin/bash

Log_Path='/data/logs/nginx'
Log_Year=`date -d "yesterday" +"%Y"`
Log_Month=`date -d "yesterday" +"%m"`
Log_Time=`date -d "yesterday" +"%Y-%m-%d"`
Nginx_Pid=/usr/local/nginx-1.16/logs/nginx.pid

#if [ -f "/usr/local/nginx/logs/nginx.pid" ]
#then
#    Nginx_Pid=/usr/local/nginx/logs/nginx.pid
#else
#    Nginx_Pid=/usr/local/tengine/logs/nginx.pid
#fi

if [ ! -d ${Log_Path}/${Log_Year}/${Log_Month} ]
then
    mkdir ${Log_Path}/${Log_Year}/${Log_Month} -p
fi  

for loop in `ls ${Log_Path} | grep .log`
do
    if [ -s ${Log_Path}/${loop} ]
    then    
        mv ${Log_Path}/${loop} ${Log_Path}/${Log_Year}/${Log_Month}/${loop%.*}_${Log_Time}.log
    fi
done    

#mv ${Log_Path}/${Log_Name} ${Log_Path}/${Log_Year}/${Log_Month}/pic.artup.com_${Log_Time}_access.log

kill -USR1 `cat ${Nginx_Pid}`
