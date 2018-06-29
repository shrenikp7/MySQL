#!/bin/bash
### VARIABLES ###
HOST=localhost
USER=bkusr
PASSWORD=code

SOCK=/mysql/db_name/db_name.sock
SERVER=`hostname`
SECONDS_BEHIND_MASTER=`mysql -h$HOST -u$USER -p$PASSWORD -S$SOCK -e "SHOW SLAVE STATUS\G"| grep "Seconds_Behind_Master" | awk -F": " {' print $2 '}`
SENTFILE_BROKEN=/tmp/mysql_slaverep_broken.sent
SENTFILE_BEHIND=/tmp/mysql_slaverep_behind.sent
LOGFILE=/mysql/scripts/repstatus.log

### CHECK FOR REPLICATION BREAK ###
if [ "$SECONDS_BEHIND_MASTER" == "NULL" ]; then
        # Slave replication is broken

        if [ ! -f $SENTFILE_BROKEN ]; then
                # This has not been reported before
                echo "Slave replication broken on M SERVER" > $LOGFILE
                touch $SENTFILE_BROKEN
        mysql -h$HOST -u$USER -p$PASSWORD -S$SOCK -e 'show slave status\G' >> $LOGFILE
        mail -s "Slave encountered error on  $SERVER" dba@shrenikp.blogspot.com < $LOGFILE
        fi
else
        # Slave replication is not broken

        if [ -f $SENTFILE_BROKEN ]; then
                # It was broken before which was reported. Clear that state
                echo "Slave replication has been restored on  $SERVER" > $LOGFILE
                mail -s "Slave running fine on  $SERVER" dba@shrenikp.blogspot.com < $LOGFILE
                rm $SENTFILE_BROKEN
        fi

        ### CHECK FOR REPLICATION DELAY ###
        if [ "$SECONDS_BEHIND_MASTER" -gt "600" ]; then
                # Slave replication is delayed

                if [ ! -f $SENTFILE_BEHIND ]; then
                        # This has not been reported before
                        echo "Slave replication is $SECONDS_BEHIND_MASTER seconds behind master on  $SERVER"  > $LOGFILE
                        mysql -h$HOST -u$USER -p$PASSWORD -S$SOCK -e 'show slave status\G' >> $LOGFILE
                        mail -s "Slave running behind on  $SERVER" dba@shrenikp.blogspot.com < $LOGFILE
                        touch $SENTFILE_BEHIND
                fi
        else
                # Slave replication is not delayed

                if [ -f $SENTFILE_BEHIND ]; then
                        # It was delayed before which was reported. Clear that state
                        echo "Slave replication delay has been recovered and is now $SECONDS_BEHIND_MASTER seconds behind master on  $SERVER"
                        rm $SENTFILE_BEHIND
                fi
        fi

fi
