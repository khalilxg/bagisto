FROM php:8.3-fpm-alpine

# Install system dependencies
RUN apk add --no-cache nginx supervisor mariadb-client libpng-dev libzip-dev zip unzip git curl oniguruma-dev icu-dev

# Install PHP extensions for Bagisto
RUN docker-php-ext-install pdo_mysql gd zip intl opcache bcmath

WORKDIR /var/www/html
COPY..

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader

# Set permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80

# Start command
CMD php artisan migrate --force && php artisan optimize && php artisan serve --host=0.0.0.0 --port=80
