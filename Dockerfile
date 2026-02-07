FROM php:8.2-apache

# Pakete installieren
RUN apt-get update && apt-get install -y \
    git zip unzip curl \
    libjpeg-dev libpng-dev libfreetype6-dev libzip-dev \
    && docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install gd zip \
    && a2enmod rewrite headers \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Apache Konfiguration
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

WORKDIR /var/www/html

# Yellow CMS während des Builds herunterladen und entpacken
RUN curl -L https://github.com/datenstrom/yellow/archive/refs/heads/master.zip -o /tmp/yellow.zip \
    && unzip /tmp/yellow.zip -d /tmp/ \
    && cp -a /tmp/yellow-*/. /var/www/html/ \
    && rm -rf /tmp/yellow.zip /tmp/yellow-* \
    && chown -R www-data:www-data /var/www/html

# Standard Apache Port
EXPOSE 80

CMD ["apache2-foreground"]
