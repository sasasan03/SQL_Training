# PHP 8.3 + Apache
FROM php:8.3-apache

# ----------------------------------------
# ドキュメントルートを /var/www/public に変更
# ----------------------------------------
ENV APACHE_DOCUMENT_ROOT /var/www/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# ----------------------------------------
# 基本パッケージと開発ツール
# ----------------------------------------
RUN apt-get update && apt-get install -y \
    zip unzip vim curl gnupg git locales \
    libicu-dev libonig-dev libzip-dev zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ----------------------------------------
# PHP拡張モジュール
# ----------------------------------------
# PHP拡張モジュール
RUN docker-php-ext-install \
    intl \
    pdo_mysql \
    zip

# ----------------------------------------
# Composer
# ----------------------------------------
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# ----------------------------------------
# Node.js 22 + npm (Laravel Vite用)
# ----------------------------------------
RUN apt-get update && apt-get install -y ca-certificates curl gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -y nodejs \
    && npm install -g npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ----------------------------------------
# Apache rewrite module
# ----------------------------------------
RUN a2enmod rewrite

# ----------------------------------------
# 作業ディレクトリ
# ----------------------------------------
WORKDIR /var/www

CMD ["apache2-foreground"]
