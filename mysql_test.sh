#!/bin/sh -x
INTERVAL=10
PASSWORD='-uroot -p123'
PREFIX=$INTERVAL-sec-status
RUNFILE=/home/tatarinov/mysql/running
mysql -e 'SHOW GLOBAL VARIABLES' $PASSWORD >> mysql-variables
while test -e $RUNFILE; do
   file=$(date +%F_%I)
sleep=$(date +%s.%N | awk "{print $INTERVAL - (\$1 % $INTERVAL)}")
   sleep $sleep
   ts="$(date +"TS %s.%N %F %T")"
   loadavg="$(uptime)"
   echo "$ts $loadavg" >> $PREFIX-${file}-status
   mysql -e 'SHOW GLOBAL STATUS' $PASSWORD >> $PREFIX-${file}-status &
   echo "$ts $loadavg" >> $PREFIX-${file}-innodbstatus
   mysql -e 'SHOW ENGINE INNODB STATUS\G' $PASSWORD  >> $PREFIX-${file}-innodbstatus  &
   echo "$ts $loadavg" >> $PREFIX-${file}-processlist
   mysql -e 'SHOW FULL PROCESSLIST\G' $PASSWORD >> $PREFIX-${file}-processlist & echo $ts
done
echo Exiting because $RUNFILE does not exist.
