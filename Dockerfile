FROM centos:centos7

MAINTAINER Michael Lotkowski <michael@compsci.ninja>

RUN yum -y update &&\
    yum clean all

RUN yum -y install httpd php php-mysql php-gd openssl psmisc tar mariadb-server git &&\
    yum clean all

EXPOSE 80
EXPOSE 443

ADD scripts/run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

CMD ["/run-httpd.sh"]