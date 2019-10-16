FROM php:7.0.33-fpm

# disable interactive functions
ENV DEBIAN_FRONTEND noninteractive

#For fixed: Failed to fetch Debian Jessie-updates
RUN sed -i '/jessie-updates/d' /etc/apt/sources.list

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		equivs \
		fakeroot \
		gdb \
		gnupg \
		imagemagick \
		libmagickwand-dev \
		sudo \
		curl \
		libz-dev \
		libpq-dev \
		libjpeg-dev \
		libpng-dev \
		libfreetype6-dev \
		libssl-dev \
		libmcrypt-dev \
		libxml2-dev \
		locales \
	&& rm -rf /var/lib/apt/lists/*

# Reconfigure locales
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
		&& echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen \
		&& locale-gen \
        && rm /etc/localtime \
	    && ln -s /usr/share/zoneinfo/Europe/Kiev /etc/localtime \
	    && date

# Install PHP extensions
RUN docker-php-ext-configure gd \
    	--enable-gd-native-ttf \
    	--with-jpeg-dir=/usr/lib \
    	--with-freetype-dir=/usr/include/freetype2 \
	&& pecl install imagick && docker-php-ext-enable imagick \
    && docker-php-ext-install \
		gd \
		ctype \
		dom \
		exif \
		fileinfo \
		calendar \
		ftp \
		gettext \
		iconv \
		json \
		mbstring \
		mcrypt \
		pdo \
		posix \
		shmop \
		simplexml \
		sockets \
		sysvmsg \
		sysvsem \
		sysvshm \
		tokenizer \
		xml \
		xmlwriter \
		zip \
		mysqli \
		pdo_mysql \
		wddx \
		bcmath \
		pcntl \ 
		opcache \
	&& docker-php-ext-enable \
		gd \
		ctype \
		dom \
		exif \
		fileinfo \
		ftp \
		gettext \
		iconv \
		json \
		mbstring \
		mcrypt \
		pdo \
		posix \
		shmop \
		simplexml \
		sockets \
		sysvmsg \
		sysvsem \
		sysvshm \
		tokenizer \
		xml \
		xmlwriter \
		zip \
		mysqli \
		pdo_mysql \
		wddx \
		bcmath \
		pcntl \ 
		opcache

# Composer
ENV COMPOSER_HOME /var/www/.composer
RUN curl -sS https://getcomposer.org/installer | php -- \
	    --install-dir=/usr/bin \
	    --filename=composer

# Clear
RUN apt-get autoremove -y \
	&& apt-get clean -y \
	&& rm -rf /tmp/* /var/tmp/* \
	&& find /var/cache/apt/archives /var/lib/apt/lists -not -name lock -type f -delete \
	&& find /var/cache -type f -delete

RUN mkdir -p /var/www/api-html && chown www-data:www-data /var/www/api-html && chmod 777 /var/www/api-html

USER www-data
VOLUME /var/www/api-html
WORKDIR /var/www/api-html