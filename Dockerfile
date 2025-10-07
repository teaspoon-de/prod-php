# --- Basisimage ---
FROM php:8.2-fpm-alpine

# --- Systempakete & PHP-Extensions ---
RUN apk add --no-cache \
        bash \
        git \
        zip \
        unzip \
        libpng-dev \
        libjpeg-turbo-dev \
        freetype-dev \
        oniguruma-dev \
    && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        mysqli \
        pdo \
        pdo_mysql \
        gd \
        zip

# --- Composer installieren ---
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# --- Arbeitsverzeichnis ---
WORKDIR /var/www/html

# --- Projektdaten einfuegen ---
COPY --chown=www:www . /var/www/html

# --- Non-root User (Sicherheit) ---
RUN addgroup -g 1000 www && adduser -G www -g www -s /bin/sh -D www
USER www

# --- Finaler Startbefehl ---
CMD ["php-fpm"]