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

EXPOSE 80
EXPOSE 443

ADD scripts/run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

ADD scripts/install_php.sh /install_php.sh
RUN chmod -v +x /install_php.sh

ADD . /var/www/html

RUN chown -R apache:apache /var/www/

CMD ["/run-httpd.sh"]