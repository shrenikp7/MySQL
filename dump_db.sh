#!/bin/bash
date=`date +%Y%m%d%H%M`
user=`cat /mysql/admin/scripts/.usr.txt`
pwd=`cat /mysql/admin/scripts/.pwd.txt`
DBA=`cat /mysql/admin/scripts/DBAMAIL`
LOG_FILE=/mysql/bkup/dump/db_name/bkuplog/db_name_$date.log
ERR_FILE=/mysql/backup/dump/db_name/bkuplog/db_name_$date.err

mysqldump --single-transaction --user=$usr --password=$pwd --socket='/mysql/db_name/db_name.sock' --databases db_name > \
/mysql/backup/dump/db_name/db_name_$date.sql 2>$ERR_FILE

if [ $? -eq 0 ]
then
/usr/bin/gzip /mysql/backup/dump/db_name/db_name_$date.sql
echo "$date2:db_name dump (Logical Backup) is successful" > $LOG_FILE
echo "========================================================================================" >> $LOG_FILE
       echo "" >> $LOG_FILE
       echo "Thanks," >> $LOG_FILE
       echo "MySQL DBA " >> $LOG_FILE
       echo "This is an automated generated mail" >> $LOG_FILE
/bin/mail -s "db_name dump is successful on `hostname`" $DBA < $LOG_FILE
gzip db_name_$date.sql
else
echo "db_name dump failed, Below is the error:" > $LOG_FILE
tail $ERR_FILE | grep ERROR >> $LOG_FILE
echo "========================================================================================" >> $LOG_FILE
       echo "" >> $LOG_FILE
       echo "Thanks," >> $LOG_FILE
       echo "MySQL DBA" >> $LOG_FILE
       echo "This is an automated generated mail" >> $LOG_FILE
mail -s "db_name dumpfailed  on `hostname` " $DBA < $LOG_FILE
fi
