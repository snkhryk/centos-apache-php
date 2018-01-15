FROM centos:6.7

MAINTAINER Shinki_Hiroyuki

ENV TZ Asia/Tokyo

#
RUN yum -y install gcc make pcre pcre-devel wget tar perl openssl-devel libxml2-devel libcurl-devel libjpeg-devel libpng-devel libXpm-devel freetype-devel postgresql-devel

# ==== install apache2.4.18
#   install APR(Apache Portable Runtime)
WORKDIR /usr/local/src
RUN wget -q http://ftp.yz.yamagata-u.ac.jp/pub/network/apache//apr/apr-1.5.2.tar.gz \
    && tar -xzf apr-1.5.2.tar.gz
WORKDIR /usr/local/src/apr-1.5.2
RUN ./configure --prefix=/opt/apr/apr-1.5.2 \
    && make -s \
    && make -s install
WORKDIR /usr/local/src
RUN rm -rf /usr/local/src/apr-1.5.2.tar.gz \
    && rm -rf /usr/local/src/apr-1.5.2

#   install APR-Util
WORKDIR /usr/local/src
RUN wget -q http://ftp.meisei-u.ac.jp/mirror/apache/dist//apr/apr-util-1.5.4.tar.gz \
    && tar -xzf apr-util-1.5.4.tar.gz
WORKDIR /usr/local/src/apr-util-1.5.4
RUN ./configure --prefix=/opt/apr-util/apr-util-1.5.4 --with-apr=/opt/apr/apr-1.5.2 \
    && make -s \
    && make -s install
WORKDIR /usr/local/src
RUN rm -rf /usr/local/src/apr-util-1.5.4.tar.gz \
    && rm -rf /usr/local/src/apr-util-1.5.4


#   install OpenSSL
WORKDIR /usr/local/src
RUN wget -q https://www.openssl.org/source/old/1.0.1/openssl-1.0.1u.tar.gz \
    && tar -xzf openssl-1.0.1u.tar.gz
WORKDIR /usr/local/src/openssl-1.0.1u
RUN ./config -fPIC shared \
    && make -s \
    && make -s install
WORKDIR /usr/local/src
RUN rm -rf /usr/local/src/openssl-1.0.1u.tar.gz \
    && rm -rf /usr/local/src/openssl-1.0.1u

#   install Apache 2.4.18
WORKDIR /usr/local/src
RUN wget -q https://archive.apache.org/dist/httpd/httpd-2.4.18.tar.gz \
    && tar -xzf httpd-2.4.18.tar.gz
WORKDIR /usr/local/src/httpd-2.4.18
RUN ./configure --enable-proxy --enable-rewrite --enable-so --enable-ssl --enable-reqtimeout --enable-mpms-shared=all --with-apr=/opt/apr/apr-1.5.2 --with-apr-util=/opt/apr-util/apr-util-1.5.4 --prefix=/usr/local/httpd-2.4.18 \
    && make -s \
    && make -s install \
    && ln -s /usr/local/httpd-2.4.18 /usr/local/apache2
WORKDIR /usr/local/src
RUN rm -rf /usr/local/src/httpd-2.4.18.tar.gz \
    && rm -rf /usr/local/src/httpd-2.4.18


# ==== install mySql5.6.29
RUN yum -y install https://downloads.mysql.com/archives/get/file/MySQL-client-5.6.29-1.el6.x86_64.rpm


# ==== install php5.6.15

#   install php5.6.15
WORKDIR /usr/local/src
RUN wget -q http://jp2.php.net/get/php-5.6.15.tar.gz/from/this/mirror -O php-5.6.15.tar.gz \
    && tar -xzf php-5.6.15.tar.gz
WORKDIR /usr/local/src/php-5.6.15
RUN ./configure --enable-mbstring --enable-mbregex --with-apxs2=/usr/local/apache2/bin/apxs --with-zlib --with-gd --enable-gd-native-ttf --enable-gd-jis-conv --with-freetype-dir --with-mysql --with-iconv-dir --with-openssl --with-curl --with-mysqli --with-gettext --with-pdo-mysql --with-pgsql --with-xpm-dir --with-jpeg-dir --with-pgsql=/usr/local/pgsql --prefix=/usr/local/php-5.6.15 \
    && make -s \
    && make -s install \
    && ln -s /usr/local/php-5.6.15 /usr/local/php \
    && cp /usr/local/php/bin/* /usr/local/bin/
WORKDIR /usr/local/src
RUN rm -rf /usr/local/src/php-5.6.15.tar.gz \
    && rm -rf /usr/local/src/php-5.6.15

#   install xdebug
RUN pecl install xdebug
