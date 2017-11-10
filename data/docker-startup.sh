#!/bin/bash

chown -R www-data:www-data /owncloud/config && chmod -R 777 /owncloud/config

export HTTP_PORT=80
if [[ ! -z $HTTP_WEB_PORT ]]; then
    export HTTP_PORT=$HTTP_WEB_PORT
fi

sed -i "s/HTTP_PORT/$HTTP_PORT/g" "/etc/apache2/sites-available/default.conf"

service apache2 start