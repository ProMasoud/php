FROM composer:2.7.7 AS composer
ARG VERSION
FROM php:${VERSION}-fpm

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    zip \
    unzip \
    mariadb-client \
    nano \
    nginx \
    supervisor && \
    curl -sSLf \
        -o /usr/local/bin/install-php-extensions \
        https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions

# ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd gmp imap zip soap intl mysqli exif sockets \
    pdo_mysql pcntl bcmath pdo_pgsql opcache imagick  mcrypt redis mongodb memcached;

ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="0" \
    PHP_OPCACHE_MAX_ACCELERATED_FILES="20000" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="384" \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE="10" \
    PHP_CONFIG="production"

# Install composer
COPY --from=composer /usr/bin/composer /usr/local/bin/composer
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apt-get clean ; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

CMD ["php-fpm"]
