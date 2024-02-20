# Use an official PHP runtime as a parent image
FROM php:7.4-fpm


# Set the working directory in the container
WORKDIR /var/www/html

# Copy the composer.lock and composer.json files into the container
COPY composer.lock composer.json /var/www/html/

# Install any needed packages specified in composer.json
RUN apt-get update && \
    apt-get install -y \
    git \
    unzip \
    libicu-dev \
    && docker-php-ext-install pdo pdo_mysql gettext intl

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install application dependencies
RUN composer install --no-scripts --no-autoloader

# Copy the application files into the container
COPY . /var/www/html

# Generate autoload files
RUN composer dump-autoload

# Set the correct permissions
RUN chown -R www-data:www-data /var/www/html/storage

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]