FROM php:8.2-fpm

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    zip \
    mariadb-client \
    nano \
    nginx \
    supervisor


ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd gmp imap zip soap intl mysqli exif sockets \
    pdo_mysql pcntl bcmath pdo_pgsql opcache imagick  mcrypt redis mongodb memcached;

ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="0" \
    PHP_OPCACHE_MAX_ACCELERATED_FILES="20000" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="384" \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE="10" \
    PHP_CONFIG="production"



# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install postgres
RUN apt-get clean ; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

CMD ["php-fpm"]
