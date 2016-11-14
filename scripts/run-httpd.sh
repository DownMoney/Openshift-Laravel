#!/bin/bash

# Make sure we're not confused by old, incompletely-shutdown httpd
# context after restarting the container.  httpd won't start correctly
# if it thinks it is already running.
rm -rf /run/httpd/* /tmp/httpd*

mysql_install_db --user=mysql --basedir=/usr/ --ldata=/var/lib/mysql/

mysqld_safe &

sleep 5

mysql < create_database.sql

cd /var/www/html && php artisan migrate

exec /usr/sbin/apachectl -DFOREGROUND