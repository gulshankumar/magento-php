FROM php:8.1-fpm

LABEL maintainer="Gulshan Kumar Maurya <gulshan.4dream@gmail.com>"

ARG APP_ID=1000

# Create app user and group
RUN groupadd -g "$APP_ID" app \
    && useradd -m -u "$APP_ID" -g app -s /bin/bash app \
    && mkdir -p /var/www/html \
    && chown -R app:app /var/www

# Install system dependencies & PHP extensions in one layer
RUN apt-get update && apt-get install -y --no-install-recommends \
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
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) \
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
    zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy PHP-FPM configs (ensure these files exist)
COPY conf/php-fpm.conf /usr/local/etc/
COPY conf/www.conf /usr/local/etc/php-fpm.d/
