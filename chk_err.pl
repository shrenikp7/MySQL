#!/bin/perl
use strict;
use warnings;

chkerrordb_name();

################### Check Error for db_name  ####################

sub chkerrordb_name
{
my @EXCLUDE="log_error_verbosity\|SSL library error\Can't read from messagefile";
my $hostname=`hostname`;
my $date=`date +%d%m%y_%H%M%S`;
my $MAIL_LIST="dba\@icanexplore.com dba1\@icanexplore.com";
my $cmd = `grep -E  "error|corrupt|ERROR" /mysql/db_name/logs/db_name.err | egrep -vc "@EXCLUDE"`;
my $status = $cmd;
print $status;
if ($status != 0)
        {
        my $send_mail=`mailx -s "There is an error in MySQL error log for db_name on $hostname !! " $MAIL_LIST < /mysql/db_name/logs/db_name.err`;
        my $rename=`mv /mysql/db_name/logs/db_name.err  /mysql/db_name/logs/db_name.err.$date`;
        my $file=`touch /mysql/db_name/logs/db_name.err`
               }
                }
