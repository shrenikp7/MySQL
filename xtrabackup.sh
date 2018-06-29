#!/bin/bash
date=`date +%Y%m%d%H%M`

DBA=`cat /mysql/scripts/DBAMAIL`
LOG_FILE=/mysql/backup/db_name/bkuplog/db_namebkupmail_$date.log
ERR_FILE=/mysql/backup/db_name/bkuplog/db_namebkup_$date.err

LOG_FILE1=/mysql/backup/db_name/bkuplog/db_namebkprepmail_$date.log
ERR_FILE1=/mysql/backup/db_name/bkuplog/db_nameprep_$date.err

xtrabackup --defaults-file=/etc/my.cnf --defaults-group=db_name --backup \
--user=bkusr -pcode --port 0000  --datadir=/mysql/db_name/data \
--server-id=0000 --socket=/mysql/db_name/data/db_name.sock \
--target-dir=/mysql/backup/db_name/db_namebkup_$date 2> $ERR_FILE

if [ $? -eq 0 ]
then
echo "$date2:db_name Full Backup successful" > $LOG_FILE
echo "========================================================================================" >> $LOG_FILE
       echo "" >> $LOG_FILE
       echo "Thanks," >> $LOG_FILE
       echo "MySQL DBA " >> $LOG_FILE
       echo "This is an automated generated mail" >> $LOG_FILE
#/bin/mail -s "db_name Full Backup successful on `hostname`" $DBA < $LOG_FILE
else
echo "db_name  Full Backup failed, Below is the error:" > $LOG_FILE
tail $ERR_FILE | grep ERROR >> $LOG_FILE
echo "========================================================================================" >> $LOG_FILE
       echo "" >> $LOG_FILE
       echo "Thanks," >> $LOG_FILE
       echo "MySQL DBA" >> $LOG_FILE
       echo "This is an automated generated mail" >> $LOG_FILE
mail -s "db_name   Full Backup failed  on `hostname` " $DBA < $LOG_FILE
fi

xtrabackup --defaults-file=/etc/my.cnf --port 0000 --server-id=0000 --socket=/mysql/db_name/data/db_name.sock \
--prepare --target-dir=/mysql/backup/db_name/db_namebkup_$date 2> $ERR_FILE1

if [ $? -eq 0 ]
then
echo "$date2:db_name Full Backup Prepare successful" > $LOG_FILE1
echo "========================================================================================" >> $LOG_FILE1
       echo "" >> $LOG_FILE1
       echo "Thanks," >> $LOG_FILE1
       echo "MySQL DBA Team" >> $LOG_FILE1
       echo "This is an automated generated mail" >> $LOG_FILE1
#/bin/mail -s "db_name Full Backup Prepare successful on `hostname`" $DBA < $LOG_FILE1
else
echo "db_name  Full Backup Preapare failed, Below is the error:" > $LOG_FILE1
tail $ERR_FILE1 | grep ERROR >> $LOG_FILE1
echo "========================================================================================" >> $LOG_FILE1
       echo "" >> $LOG_FILE1
       echo "Thanks," >> $LOG_FILE1
       echo "MySQL DBA Team" >> $LOG_FILE1
       echo "This is an automated generated mail" >> $LOG_FILE1
mail -s "db_name Full Backup Prepare failed  on `hostname` " $DBA < $LOG_FILE1
fi

/bin/tar -zcvf /mysql/backup/db_name/db_namebkup_$date.tar.gz /mysql/backup/db_name/db_namebkup_$date

rm -rf /mysql/backup/db_name/db_namebkup_$date
