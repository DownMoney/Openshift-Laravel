FROM centos:centos7

MAINTAINER Michael Lotkowski <michael@compsci.ninja>

RUN yum -y update &&\
    yum clean all

RUN yum -y install wget epel-release
RUN wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN wget https://centos7.iuscommunity.org/ius-release.rpm
RUN rpm -Uvh ius-release*.rpm

RUN yum -y install httpd openssl psmisc tar mariadb-server php56u php56u-opcache php56u-xml php56u-mcrypt php56u-gd php56u-devel php56u-mysql php56u-intl php56u-mbstring php56u-bcmath git &&\
    yum clean all

RUN php -r "readfile('https://getcomposer.org/installer');" | php
RUN mv composer.phar /usr/local/bin/composer

EXPOSE 80
EXPOSE 443

ADD scripts/run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

ADD . /var/www/html

RUN cd /var/www/html && composer install

RUN chown -R apache:apache /var/www/

COPY scripts/fix-permissions.sh ./
RUN chmod -v +x /fix-permissions.sh

RUN ./fix-permissions.sh /var/lib/mysql/   && \
    ./fix-permissions.sh /var/log/mariadb/ && \
    ./fix-permissions.sh /var/run/

# Define mountable directories.
VOLUME ["/etc/mysql", "/var/lib/mysql"]

ADD scripts/create_database.sql /create_database.sql

CMD ["/run-httpd.sh"]