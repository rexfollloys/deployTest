# Utilisation de PHP 8.2 avec FPM comme base
FROM php:8.2-fpm

# Installer les dépendances système et extensions PHP
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    curl \
    mariadb-server \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql \
    && rm -rf /var/lib/apt/lists/*

# Installer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Définir le répertoire de travail
WORKDIR /app/back

# 🔹 Copier tout le projet avant d'exécuter Composer
COPY ./back /app/back

# 🔹 Vérifier que le fichier artisan est bien présent
RUN ls -la /app/back

# 🔹 Installer les dépendances via Composer (évite les erreurs de permissions et root)
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-progress

# Exposer le port 8000 pour Laravel
EXPOSE 8000

# Démarrer MySQL et Laravel ensemble
CMD service mysql start && \
    echo "Waiting for MySQL to be ready..." && \
    until mysqladmin ping --silent; do sleep 2; done && \
    mysql -e "CREATE DATABASE IF NOT EXISTS laravel;" && \
    php artisan migrate --force && \
    php artisan serve --host=0.0.0.0 --port=8000
