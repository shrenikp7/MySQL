#!/bin/sh
# Check MySQL InnoDB cluster status from router cron

usr=`cat /mysql/.usr.txt`
pwd=`cat /mysql/.pwd.txt`
port=6446
host=localhost
errfile=/mysql/logs/log.txt

stat1=`mysqlsh --js --port=$port --host=$host --dbuser=$usr --dbpassword=$pwd --execute='dba.getCluster().status()' --interactive --classic`

stat2=`echo $stat1|grep -o ONLINE|wc -l`

if [ $stat2 -lt 4 ]
then
stat=`echo $stat1|grep -oe OFFLINE -oe MISSING -oe RECOVERING|wc -l`
        if [ $stat3 -gt 0 ]
        then
        echo -e "Innodb cluster is in inconsistent state, manual intervention required\n \nInnoDB Cluster Details\n\n"$stat1 > $errfile
        mail -s "Cluster is in inconsistent state"  Shrenik.Parekh@icanexplore.com <  $errfile
        fi
else
echo -e "All the nodes are online. The cluster is fault tolerant\n \nInnoDB Cluster Details\n\n" $stat1 > $errfile
exit 0
mail -s "Alert from Cluster"  shrenik.parekh@icanexplore.com <  $errfile
fi
