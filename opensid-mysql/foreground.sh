#!/bin/bash

chown -R www-data:www-data /var/www/html

read pid cmd state ppid pgrp session tty_nr tpgid rest < /proc/self/stat
trap "kill -TERM -$pgrp; exit" EXIT TERM KILL SIGKILL SIGTERM SIGQUIT

source /etc/apache2/envvars
tail -F /var/log/apache2/* &
exec /usr/sbin/mysqld && apache2 -D FOREGROUND 
