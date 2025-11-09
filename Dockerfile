# ============================================
# Stage 1 — Composer dependencies builder
# ============================================
FROM composer:2.6 AS vendor

WORKDIR /app

# Copy file composer saja agar caching efisien
COPY composer.json composer.lock ./

# Tambah timeout dan izinkan root
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer config --global process-timeout 2000

# Install dependencies tanpa dev (cepat, cacheable)
RUN composer install --no-dev --optimize-autoloader --no-interaction

# ============================================
# Stage 2 — PHP-FPM production image
# ============================================
FROM php:8.2-fpm

# Install sistem dependencies & PHP extensions
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libjpeg-dev libfreetype6-dev libzip-dev libonig-dev libxml2-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip pdo pdo_mysql mbstring exif pcntl bcmath dom \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Atur direktori kerja
WORKDIR /var/www/html

# Copy vendor dari stage pertama (lebih cepat & kecil)
COPY --from=vendor /app/vendor ./vendor

# Copy seluruh source code
COPY . .

# Generate APP_KEY otomatis (jika belum ada)
RUN php artisan key:generate --ansi || true

# Permission folder penting
RUN chmod -R 775 storage bootstrap/cache

# Ekspos port 8080
EXPOSE 8080

# Jalankan Laravel
CMD php artisan serve --host=0.0.0.0 --port=8080
