#!/bin/bash

VOLUME_HOME="/var/lib/mysql"

# Possibly invoke the inherited script to create the admin user.
if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
    echo "=> Installing MySQL ..."
    mysql_install_db > /dev/null 2>&1
    echo "=> Done!"
    /create_mysql_admin_user.sh
else
    echo "=> Using an existing volume of MySQL"
fi

# Create the magento database if it doesn't exist. 
if [[ ! -d $VOLUME_HOME/magento ]]; then

    # Start MySQL
    /usr/bin/mysqld_safe > /dev/null 2>&1 &

    RET=1
    while [[ RET -ne 0 ]]; do
        echo "=> Waiting for confirmation of MySQL service startup"
        sleep 5
        mysql -uroot -e "status" > /dev/null 2>&1
        RET=$?
    done

    # Generate a random password for the magento MySQL user.
    MAGENTO_PASSWORD=`pwgen -c -n -1 12`

    echo "========================================================================"
    echo
    echo "MySQL magento user password:" $MAGENTO_PASSWORD
    echo
    echo "========================================================================"

    # Create the database
    mysql -uroot -e \
        "CREATE DATABASE magento; \
         GRANT ALL PRIVILEGES ON magento.* TO 'magento'@'localhost' \
         IDENTIFIED BY '$MAGENTO_PASSWORD'; \
         FLUSH PRIVILEGES;"

    mysqladmin -uroot shutdown
    sleep 5
fi

# If the application directory is empty, copy the site.
APPLICATION_HOME="/var/www/html"

if [ ! "$(ls -A $APPLICATION_HOME)" ]; then
    # Copy the application folder.
    cp -r /app/* $APPLICATION_HOME

    # Configure permissions.
    chmod -R o+w $APPLICATION_HOME/media $APPLICATION_HOME/var
    chmod o+w $APPLICATION_HOME$APPLICATION_HOME/etc
    cd $APPLICATION_HOME && chown -R www-data .
fi

exec supervisord -n
