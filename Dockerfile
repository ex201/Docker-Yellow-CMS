# Nutzen des schlanken FPM Images
FROM php:8.2-fpm-alpine

# Installation von Abhängigkeiten und PHP-Extensions
RUN apk add --no-local-cache \
    icu-dev \
    libpng-dev \
    libzip-dev \
    zip \
    unzip \
    curl \
    && docker-php-ext-install intl gd zip

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
