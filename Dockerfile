# --- Basisimage ---
FROM php:8.2-fpm-alpine

# --- Buildtools & PHP-Extensions ---
RUN apk add --no-cache --virtual .build-deps \
        autoconf g++ make bash git \
    && apk add --no-cache \
        libpng-dev libjpeg-turbo-dev freetype-dev libwebp-dev zlib-dev oniguruma-dev \
        zip unzip \
    \
    && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
        --with-webp \
    && docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql gd zip mbstring \
    \
    && apk del .build-deps

# --- Composer installieren ---
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# --- Arbeitsverzeichnis ---
WORKDIR /var/www/html

# --- Projektdateien kopieren (für Production) ---
COPY --chown=www:www . /var/www/html

# --- Non-root User für Sicherheit ---
RUN addgroup -g 1000 www && adduser -G www -g www -s /bin/sh -D www
USER www

# --- Startbefehl ---
CMD ["php-fpm"]
