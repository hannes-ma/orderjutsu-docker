FROM php:7.1-fpm-alpine

# See nginx Dockerfile to set same uid/gid
ARG NGINX_UID=101
ARG NGINX_GID=101

# Install requirements and native PHP extensions
RUN apk add --no-cache \
        curl \
        unzip \
        libxml2-dev \
        libmcrypt-dev \
        curl-dev \
        zlib-dev \
        freetype-dev \
        libjpeg-turbo-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install \
        mcrypt \
        mysqli \
        pdo  \
        pdo_mysql \
        soap \
        curl \
        zip \
        mbstring \
        gd
    
# Install composer 2.2 compatible with php 7.1
COPY --from=composer:2.2 /usr/bin/composer /usr/bin/composer

# Copy orderjutsu setup script
COPY ./setup.sh /docker-entrypoint-setup.sh

RUN set -x \
# create nginx user to be consistent with nginx container for file access
    && addgroup -g $NGINX_GID -S nginx || true \
    && adduser -S -D -H -u $NGINX_UID -h /tmp -s /sbin/nologin -G nginx -g nginx nginx || true \
    && mkdir -p /srv \
    && chown -R nginx:nginx /srv \
    && chmod 755 /docker-entrypoint-setup.sh
    
WORKDIR /srv
USER nginx

ENTRYPOINT /docker-entrypoint-setup.sh    
