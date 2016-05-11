FROM quay.io/hellofresh/hf-baseimage

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

# UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

CMD ["/sbin/my_init"]

#
# Essentials
#
RUN apt-get update
RUN apt-get install -y \
        software-properties-common \
        python-software-properties \
        wget \
        curl \
        vim \
        htop \
        git

#
# nginx
#
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y nginx

ADD ./files/config/nginx.conf /etc/nginx/nginx.conf
ADD ./files/config/default.conf   /etc/nginx/sites-available/default

#
# php
#
RUN \
    apt-get install -y language-pack-en-base && \
    LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y \
        libapache2-mod-php7.0 \
        php7.0 \
        php7.0-fpm \
        php7.0-cli \
        php7.0-common \
        libpcre3-dev \
        php7.0-dev \
        php7.0-gd \
        php7.0-curl \
        php7.0-mcrypt \
        php7.0-intl \
        php7.0-mysql \
        php7.0-pgsql \
        php7.0-mbstring \
        php7.0-json \
        php7.0-opcache \
        php7.0-xml \
        php7.0-odbc \
        php7.0-zip \
        php7.0-bcmath \ # Required by php-amqplib
        php-pear \
        libsasl2-dev

RUN mkdir -p /usr/local/openssl/include/openssl/ && \
    ln -s /usr/include/openssl/evp.h /usr/local/openssl/include/openssl/evp.h && \
    mkdir -p /usr/local/openssl/lib/ && \
    ln -s /usr/lib/x86_64-linux-gnu/libssl.a /usr/local/openssl/lib/libssl.a && \
    ln -s /usr/lib/x86_64-linux-gnu/libssl.so /usr/local/openssl/lib/



RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/7.0/fpm/php.ini
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/7.0/cli/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini

ADD ./files/public/index.php /server/http/public/index.php

# Setup runit
RUN mkdir                       /etc/service/nginx
COPY ./files/runit/nginx.sh     /etc/service/nginx/run
RUN chmod +x                    /etc/service/nginx/run
RUN mkdir                       /etc/service/phpfpm
ADD ./files/runit/phpfpm.sh     /etc/service/phpfpm/run
RUN chmod +x                    /etc/service/phpfpm/run

# Install composer
RUN \
    php -r "readfile('https://getcomposer.org/installer');" | php && \
    mv composer.phar /usr/local/bin/composer


# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
