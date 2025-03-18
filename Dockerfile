# Utiliser une image PHP officielle avec FPM (version 8.2)
FROM php:8.2-fpm

# Ajouter un utilisateur non-root
RUN useradd -m -s /bin/bash laraveluser

# Passer à l'utilisateur non-root
USER laraveluser

# Installer les dépendances nécessaires (comme curl, git, unzip)
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    curl \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    && rm -rf /var/lib/apt/lists/*

# Installer les extensions PHP nécessaires pour Laravel
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Installer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Définir le répertoire de travail dans le dossier back (adapte si nécessaire)
WORKDIR /app/back

# Copier les fichiers composer.json et composer.lock pour installer les dépendances
COPY ./back/composer.json ./back/composer.lock ./

# Installer les dépendances via Composer
RUN composer install --no-dev --optimize-autoloader

# Copier le reste de l'application après l'installation des dépendances
COPY ./back /app/back

# Exposer le port 8000 pour Laravel
EXPOSE 8000

# Lancer Laravel avec le serveur intégré
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
