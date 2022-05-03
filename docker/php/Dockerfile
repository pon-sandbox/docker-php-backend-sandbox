FROM php:7.4-fpm-alpine

ADD ./docker/php/php.ini /usr/local/etc/php/conf.d/php.ini

RUN apk update \
    && apk --update-cache --no-cache add libmemcached-dev autoconf zlib-dev build-base libzip-dev unzip git bash oniguruma-dev \
    && pecl channel-update pecl.php.net \
    && pecl install xdebug apcu \
    && docker-php-ext-install zip pdo_mysql mysqli \
    && docker-php-ext-enable xdebug apcu opcache \
    && rm -rf /var/cache/apk/*

# .bashrc settings
RUN echo '# default:cyan / root:red' >> ~/.bashrc \
    && echo 'if [ $UID -eq 0 ]; then' >> ~/.bashrc \
    && echo '    PS1="\[\033[31m\]\u@\h\[\033[00m\]:\[\033[01m\]\w\[\033[00m\]\\$ "' >> ~/.bashrc \
    && echo 'else' >> ~/.bashrc \
    && echo '    PS1="\[\033[36m\]\u@\h\[\033[00m\]:\[\033[01m\]\w\[\033[00m\]\\$ "' >> ~/.bashrc \
    && echo 'fi' >> ~/.bashrc \
    && echo '# "-F":ディレクトリに"/"を表示 / "-G"でディレクトリを色表示' >> ~/.bashrc

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ENV COMPOSER_ALLOW_SUPERUSER 1

# set path for composer
RUN echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >> ~/.bashrc

RUN composer self-update