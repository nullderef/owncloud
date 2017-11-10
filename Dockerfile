FROM phusion/baseimage:0.9.22

ENV OWNCLOUD_FILE=owncloud-10.0.3.tar.bz2

# Use baseimage-docker's init system.
CMD [ "/sbin/my_init" ]

RUN apt-get update -y

RUN apt-get install -y apache2 mariadb-server libapache2-mod-php7.0 \
    php7.0-gd php7.0-json php7.0-mysql php7.0-curl \
    php7.0-intl php7.0-mcrypt php-imagick \
    php7.0-zip php7.0-xml php7.0-mbstring \ 
    php-apcu php-redis redis-server \ 
    php7.0-ldap php-smbclient \
    wget bzip2

COPY data/default.conf /etc/apache2/sites-available/

RUN a2dissite 000-default && a2enmod rewrite && a2ensite default

RUN mkdir -p /owncloud/owncloud && \
    mkdir -p /owncloud/logs && \ 
    mkdir -p /owncloud/data && \ 
    mkdir -p /owncloud/config

RUN wget https://download.owncloud.org/community/$OWNCLOUD_FILE -P /root && \ 
    tar -xjf /root/$OWNCLOUD_FILE -C /owncloud 

RUN rm -rf /owncloud/owncloud/config

RUN ln -s /owncloud/config /owncloud/owncloud/config

RUN chown -R www-data:www-data /owncloud && \ 
    chmod 777 /owncloud/config

USER www-data

VOLUME [ "/owncloud/config" ]

VOLUME [ "/owncloud/data" ]

VOLUME [ "/owncloud/logs" ]

USER root

RUN mkdir -p /etc/my_init.d
COPY data/docker-startup.sh /etc/my_init.d/docker-startup.sh
RUN chmod +x /etc/my_init.d/docker-startup.sh

EXPOSE 80/tcp

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/*