FROM php:8.1-fpm

LABEL maintainer="Gulshan Kumar Maurya <gulshan.4dream@gmail.com>"

ARG APP_ID=1000
RUN groupadd -g "$APP_ID" app \
    && useradd -g "$APP_ID" -u "$APP_ID" -d /var/www -s /bin/bash app

RUN mkdir -p /var/www/html \
    && chown -R app:app /var/www

RUN apt-get update && apt-get install -y \
    cron \
    gnupg \
    gzip \
    libbz2-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libonig-dev \
    libpng-dev \
    libsodium-dev \
    libssh2-1-dev \
    libwebp-dev \
    libxslt1-dev \
    libzip-dev \
    zip \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*


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

COPY conf/php-fpm.conf /usr/local/etc/
COPY conf/www.conf /usr/local/etc/php-fpm.d/

USER app:app
WORKDIR /var/www/html