FROM php:7.0.33-fpm-alpine

# intl, zip, soap
RUN apk add --update --no-cache libintl icu icu-dev libxml2-dev \
    && docker-php-ext-install intl zip soap

# mysqli, pdo, pdo_mysql
RUN docker-php-ext-install mysqli pdo pdo_mysql

# mcrypt, gd, iconv
RUN apk add --update --no-cache \
        freetype-dev \
        libjpeg-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
    && docker-php-ext-install -j"$(getconf _NPROCESSORS_ONLN)" iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j"$(getconf _NPROCESSORS_ONLN)" gd

# imagick
RUN apk add --update --no-cache autoconf g++ imagemagick-dev libtool make pcre-dev \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && apk del autoconf g++ libtool make pcre-dev

# ftp
RUN apk add --no-cache openssl-dev \
    && docker-php-ext-install ftp

# Install PHP extensions
RUN docker-php-ext-install \
		ctype \
		exif \
		fileinfo \
		calendar \
		json \
		mbstring \
		posix \
		shmop \
		sockets \
		sysvmsg \
		sysvsem \
		sysvshm \
		tokenizer \
		dom \
		simplexml \
		xml \
		xmlwriter \
		wddx \
		bcmath \
		pcntl \ 
		opcache

# Composer
ENV COMPOSER_HOME /var/www/.composer
RUN curl -sS https://getcomposer.org/installer | php -- \
	    --install-dir=/usr/bin \
	    --filename=composer

# Bash
RUN apk add --update --no-cache bash

USER www-data
VOLUME /var/www/site
WORKDIR /var/www/site