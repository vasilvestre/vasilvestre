FROM php:7.4.12-fpm-buster


ARG user=dev
ARG uid=1000

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

RUN pecl install redis-5.1.1 apcu-5.1.19 && \
    pecl clear-cache && \
	docker-php-ext-enable apcu opcache redis && \
#	pecl install xdebug-2.8.1 && \
#	docker-php-ext-enable redis xdebug && \
	docker-php-ext-install mbstring bcmath

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN useradd -G www-data,root -u $uid -d /home/$user $user &&\
    mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

WORKDIR /var/www

USER $user