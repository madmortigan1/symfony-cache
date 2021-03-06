# Compiling AMQP extension
# FROM php:8.1-fpm-alpine AS ext-amqp

# Web docker compilations
FROM php:8.1-fpm

LABEL maintainer="Ric Harvey <ric@ngd.io>"

ENV php_conf /usr/local/etc/php-fpm.conf
ENV fpm_conf /usr/local/etc/php-fpm.d/www.conf
ENV php_vars /usr/local/etc/php/conf.d/docker-vars.ini

ENV NGINX_VERSION 1.20.2
ENV LUA_MODULE_VERSION 2.0.4
ENV DEVEL_KIT_MODULE_VERSION 0.3.1
ENV GEOIP2_MODULE_VERSION 3.2
ENV LUAJIT_LIB=/usr/lib
ENV LUAJIT_INC=/usr/include/luajit-2.1

RUN  apt-get update -qq && \
     apt-get dist-upgrade -y && \
     apt upgrade -y

# Installing all related packages.
RUN apt-get install -y \
    nginx \
    software-properties-common \
    bash \
    patch \
    openssh-client \
    wget \
    supervisor \
    jpegoptim \
    pngquant  \
    procps \
    jq \
    zip \
    curl \
    libcurl4-openssl-dev \
    libzip-dev \
    libbz2-dev \
    git \
    python3 \
    python3-dev \
    python3-pip \
    cargo \
    augeas-tools \
    ca-certificates \
    dialog \
    autoconf \
    make \
    gcc \
    libpcre3  \
    libpcre3-dev \
    musl-dev \
    libmcrypt-dev \
    libpng-dev \
    libxslt-dev \
    libffi-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    sqlite3 \
    libc-client-dev \
    libkrb5-dev \
    libpq-dev \
    mlocate \
    nano \
    screen \
    telnet \
    net-tools \
    yarn \
    tzdata \
    re2c \
    libxml2 \
    libldap2-dev \
    librabbitmq-dev \
    libssh-dev \
    libc-dev \
    libargon2-0-dev \
    libedit-dev \
    libsqlite3-dev \
    libssl-dev \
    zlib1g-dev \
    libicu-dev \
    g++ \
    gnupg \
    libmaxminddb-dev \
    perlbrew \
    luajit \
    rpm

#RUN echo @testing http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
#    echo /etc/apk/respositories && \
#    apk update && apk upgrade &&\
#RUN apt-get -y install linux-headers-$(uname -r)
#RUN apt-get -y install linux-image-generic-lts-trusty \
#    linux-headers-generic-lts-trusty \
#    linux-headers-gke

RUN docker-php-ext-configure gd \
      --with-freetype \
      --with-jpeg

RUN docker-php-ext-install bz2

# Install Postgre PDO
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql

# Adding PHP extensions
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install -j$(nproc) imap

RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install gd
RUN docker-php-ext-install exif
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl
RUN docker-php-ext-install xsl
RUN docker-php-ext-install soap
RUN docker-php-ext-install zip
RUN docker-php-ext-install opcache

RUN pecl install xdebug-3.1.3
RUN pecl install -o -f redis
RUN echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini
RUN pecl install amqp \
    && docker-php-ext-enable amqp

RUN pecl install -o -f igbinary
RUN docker-php-ext-enable igbinary

RUN docker-php-ext-install gettext sockets
#RUN pecl install mcrypt-1.0.4
#RUN curl -o /root/mycrypt.rpm http://rpms.remirepo.net/enterprise/7/remi/x86_64/php-mcrypt-5.4.45-18.el7.remi.x86_64.rpm
#RUN rpm -i /root/mycrypt.rpm
#RUN docker-php-ext-enable mcrypt

RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/
RUN docker-php-ext-install ldap
RUN docker-php-source delete
RUN mkdir -p /etc/nginx
RUN mkdir -p /var/www/app
RUN mkdir -p /run/nginx
RUN mkdir -p /var/log/supervisor
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --quiet --install-dir=/usr/bin --filename=composer
RUN rm composer-setup.php
RUN pip3 install -U pip
RUN pip3 install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir cryptography==3.1.1
RUN mkdir -p /etc/letsencrypt/webrootauth

COPY conf/supervisord.conf /etc/supervisord.conf


#############################
##     NGINX INSTALL       ##
#############################
RUN GPG_KEYS=B0F4253373F8F6F510D42178520A9993A1C052F8 \
  && CONFIG="\
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --modules-path=/usr/lib/nginx/modules \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --user=nginx \
    --group=nginx \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-http_auth_request_module \
    --with-http_xslt_module=dynamic \
    --with-http_image_filter_module=dynamic \
#    --with-http_geoip_module=dynamic \
    --with-http_perl_module=dynamic \
    --with-threads \
    --with-stream \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --with-stream_realip_module \
#    --with-stream_geoip_module=dynamic \
    --with-http_slice_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-compat \
    --with-file-aio \
    --with-http_v2_module \
    --add-module=/usr/src/ngx_devel_kit-$DEVEL_KIT_MODULE_VERSION \
    --add-module=/usr/src/lua-nginx-module-$LUA_MODULE_VERSION \
#    --add-module=/usr/src/ngx_http_geoip2_module-$GEOIP2_MODULE_VERSION \
  "

RUN addgroup nginx --gid 1001
RUN adduser --disabled-password --disabled-login --gid 1001 --gecos "" nginx

  # forward request and error logs to docker log collector
RUN   ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log


# Copy our nginx config
RUN rm -Rf /etc/nginx/nginx.conf
COPY conf/nginx.conf /etc/nginx/nginx.conf

# nginx site conf
RUN mkdir -p /etc/nginx/sites-available/ && \
  mkdir -p /etc/nginx/sites-enabled/ && \
  mkdir -p /etc/nginx/ssl/ && \
  rm -Rf /var/www/* && \
  mkdir /var/www/html/

COPY conf/nginx-site.conf /etc/nginx/sites-available/default.conf
COPY conf/nginx-site-ssl.conf /etc/nginx/sites-available/default-ssl.conf

#RUN ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

RUN sed -i \
        -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" \
       -e "s/pm.max_children = 5/pm.max_children = 4/g" \
        -e "s/pm.start_servers = 2/pm.start_servers = 3/g" \
       -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" \
        -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" \
        -e "s/;pm.max_requests = 500/pm.max_requests = 200/g" \
        -e "s/user = www-data/user = nginx/g" \
        -e "s/group = www-data/group = nginx/g" \
        -e "s/;listen.mode = 0660/listen.mode = 0666/g" \
        -e "s/;listen.owner = www-data/listen.owner = nginx/g" \
        -e "s/;listen.group = www-data/listen.group = nginx/g" \
        -e "s/listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm.sock/g" \
        -e "s/^;clear_env = no$/clear_env = no/" \
        ${fpm_conf}


###########################################################################################
###########################################################################################
##                           CUSTOMIZED                                                  ##
###########################################################################################
###########################################################################################
#RUN mkdir -p $HOME/php-amqp && \
#    cd $HOME/php-amqp && \
#    git clone https://github.com/pdezwart/php-amqp.git . && git checkout v1.10.2 && \
#    phpize --clean && phpize && ./configure && make install

# TODO: No amqp version available yet for PHP 8, so the compilation is from mater at the moment
#RUN pecl install amqp-1.11.0
#ENV EXT_AMQP_VERSION=master

#RUN docker-php-source extract \
#    && git clone --branch $EXT_AMQP_VERSION --depth 1 https://github.com/php-amqp/php-amqp.git /usr/src/php/ext/amqp \
#    && cd /usr/src/php/ext/amqp && git submodule update --init \
#    && docker-php-ext-install amqp

# RUN ls -al /usr/local/lib/php/extensions/



# Adding redis extension
#RUN pecl install -o -f redis \
#  &&  rm -rf /tmp/pear \
#  &&  docker-php-ext-enable redis

ENV TZ=Asia/Jerusalem
RUN echo $TZ > /etc/TZ
# ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Updating for command "locate"
RUN updatedb

# Copying configuration files.
COPY ./custom/conf/dev/nginx/nginx.conf /etc/nginx/
COPY ./custom/conf/dev/nginx/http-ssl.conf /etc/nginx/
COPY ./custom/conf/dev/nginx/certificate/ /etc/nginx/ssl
COPY ./custom/conf/dev/nginx/default.conf /etc/nginx/sites-enabled/
COPY ./custom/conf/dev/php/php.ini /usr/local/etc/php/

#COPY ./scripts/init.sh /root/scripts/init.sh
#RUN chmod 777 /root/scripts/init.sh
#RUN /bin/bash /root/scripts/init.sh

# Creating shel aliases
RUN echo 'alias ll="ls -l"' >> ~/.bashrc
RUN alias ll='ls -l'
RUN PS1='\w\$ '


# Add Scripts
COPY scripts/start.sh /start.sh
COPY scripts/pull /usr/bin/pull
COPY scripts/push /usr/bin/push
COPY scripts/letsencrypt-setup /usr/bin/letsencrypt-setup
COPY scripts/letsencrypt-renew /usr/bin/letsencrypt-renew
RUN chmod 755 /usr/bin/pull && chmod 755 /usr/bin/push && chmod 755 /usr/bin/letsencrypt-setup \
    && chmod 755 /usr/bin/letsencrypt-renew \
    && chmod 755 /start.sh

# copy in code
COPY src/ /var/www/html/
COPY errors/ /var/www/errors

EXPOSE 443 80

WORKDIR "/var/www/html"
CMD ["/start.sh"]
