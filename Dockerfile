FROM php:8.2-apache

# Installation der benötigten Pakete ohne spezifische Versions-Suffixe bei den Libs
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    curl \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libzip-dev \
    && docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install gd zip \
    && a2enmod rewrite headers \
    # Cleanup: Wir löschen nur die Listen, um Platz zu sparen
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Apache Konfiguration für Yellow CMS
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

WORKDIR /var/www/html
