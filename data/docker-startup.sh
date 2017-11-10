#!/bin/sh

chown -R www-data:www-data /owncloud/config && chmod -R 777 /owncloud/config

service apache2 start