FROM php:8.2-apache

# Danach folgt dein restlicher Code:
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    curl \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    && docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install gd zip intl \
    && a2enmod rewrite headers \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
    
# Arbeitsverzeichnis festlegen
WORKDIR /var/www/html

# Yellow CMS von GitHub laden
RUN curl -L https://github.com/datenstrom/yellow/archive/refs/heads/main.zip -o yellow.zip \
    && unzip yellow.zip \
    && cp -R yellow-main/* . \
    && rm -rf yellow-main yellow.zip

# Entrypoint-Skript erstellen
RUN echo '#!/bin/sh' > /usr/local/bin/docker-entrypoint.sh && \
    echo 'if [ -z "$(ls -A /var/www/html)" ]; then' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '  cp -R /usr/src/yellow/. /var/www/html/' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'fi' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'chown -R www-data:www-data /var/www/html' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'exec "$@"' >> /usr/local/bin/docker-entrypoint.sh && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

# Dateien für das Backup zwischenspeichern (für das Volume-Mapping)
RUN mkdir -p /usr/src/yellow && cp -R /var/www/html/. /usr/src/yellow/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
