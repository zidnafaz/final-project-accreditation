# Gunakan PHP 8.2 dengan FPM
FROM php:8.2-fpm

# Install dependensi sistem dan ekstensi PHP yang dibutuhkan Laravel & PhpSpreadsheet
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libjpeg-dev libfreetype6-dev libzip-dev libonig-dev libxml2-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip pdo pdo_mysql mbstring exif pcntl bcmath dom

# Install Composer dari image resmi
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Atur direktori kerja
WORKDIR /var/www/html

# Copy file composer.json dan composer.lock (agar caching build lebih efisien)
COPY composer.json composer.lock ./

# Install dependensi PHP tanpa dev (untuk production)
RUN composer install --no-dev --optimize-autoloader --no-interaction --ignore-platform-req=ext-gd

# Copy seluruh source code Laravel
COPY . .

# Generate APP_KEY otomatis kalau belum ada
RUN php artisan key:generate --ansi || true

# Ganti permission supaya storage & bootstrap bisa ditulis Laravel
RUN chown -R www-data:www-data storage bootstrap/cache && chmod -R 775 storage bootstrap/cache

# Optimasi konfigurasi Laravel untuk production
RUN php artisan config:cache && php artisan route:cache && php artisan view:cache

# Expose port default (8080 agar cocok dengan Railway)
EXPOSE 8080

# Jalankan Laravel menggunakan built-in server
CMD php artisan serve --host=0.0.0.0 --port=8080
