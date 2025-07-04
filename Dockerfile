FROM php:8.1-fpm

LABEL maintainer="Gulshan Kumar Maurya <gulshan.4dream@gmail.com>"

RUN apt-get update && apt-get install -y \
    libicu-dev libonig-dev libzip-dev zip unzip git curl libxml2-dev \
    libpng-dev libjpeg-dev libfreetype6-dev libxslt1-dev libcurl4-openssl-dev \
    vim libmagickwand-dev libreadline-dev supervisor

# Install PHP extensions
RUN docker-php-ext-configure \
    gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install \
    bcmath \
    bz2 \
    calendar \
    exif \
    gd \
    gettext \
    intl \
    mbstring \
    mysqli \
    opcache \
    pcntl \
    pdo_mysql \
    soap \
    sockets \
    sodium \
    sysvmsg \
    sysvsem \
    sysvshm \
    xsl \
    zip 

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer