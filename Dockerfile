# Utilisation de PHP 8.2 avec FPM
FROM php:8.2-fpm

# Installer les dépendances système et extensions PHP
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    curl \
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

# Copier uniquement les fichiers nécessaires pour installer les dépendances
COPY ./back/composer.json ./back/composer.lock ./

# Installer les dépendances via Composer
RUN composer install --no-dev --optimize-autoloader

# Copier le reste des fichiers du projet
COPY ./back /app/back

# Vérifier que le fichier artisan est présent
RUN ls -la /app/back

# Exposer le port 8000 pour Laravel
EXPOSE 8000

# Démarrer Laravel après avoir exécuté les migrations
CMD ["sh", "-c", "php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000"]
