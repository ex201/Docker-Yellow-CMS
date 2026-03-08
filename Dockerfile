FROM php:8.2-apache

# System-Abhängigkeiten installieren
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

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Arbeitsverzeichnis festlegen
WORKDIR /var/www/html

# Yellow CMS von GitHub laden
RUN curl -L https://github.com/datenstrom/yellow/archive/refs/heads/main.zip -o yellow.zip \
    && unzip yellow.zip \
    && cp -R yellow-main/* . \
    && rm -rf yellow-main yellow.zip \
    && chown -R www-data:www-data /var/www/html

# Backup-Verzeichnis für Volume-Initialisierung erstellen
RUN mkdir -p /usr/src/yellow && cp -R /var/www/html/. /usr/src/yellow/

# Entrypoint-Skript erstellen
RUN echo '#!/bin/sh' > /usr/local/bin/docker-entrypoint.sh && \
    echo 'if [ ! -f /var/www/html/system/config/config.ini ]; then' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '  cp -R /usr/src/yellow/. /var/www/html/' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'fi' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'chown -R www-data:www-data /var/www/html' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'exec "$@"' >> /usr/local/bin/docker-entrypoint.sh && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

COPY <<EOF /usr/local/bin/docker-entrypoint.sh
#!/bin/sh
if [ ! -f /var/www/html/system/config/config.ini ]; then
    cp -R /usr/src/yellow/. /var/www/html/
fi
chown -R www-data:www-data /var/www/html
exec "\$@"
EOF

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
