#!/bin/sh

if [ ! -d "/srv/www" ]; then
    echo "Setting up orderjutsu installation"
    
    set -ex
    
    # Orderjutsu gets installed here
    mkdir -p "/srv/www"
    
    # Download, extract and setup orderjutsu in /srv/www/
    curl -sS $ORDERJUTSU_LINK -o /tmp/orderjutsu.zip \
        && unzip /tmp/orderjutsu.zip -d /tmp \
        && cp -r /tmp/orderjutsu-*/. /srv/www/ \
        && rm -r /tmp/orderjutsu* \
        && cd /srv/www/
    
    # Setup .env file with the database credentials
    cp .env.example .env
    sed -i "s/.*DB_HOST=.*/DB_HOST=$DB_HOST/g" .env
    sed -i "s/.*DB_DATABASE=.*/DB_DATABASE=$DB_DATABASE/g" .env
    sed -i "s/.*DB_USERNAME=.*/DB_USERNAME=$DB_USER/g" .env
    sed -i "s/.*DB_PASSWORD=.*/DB_PASSWORD=$DB_PASSWORD/g" .env
    
    # Setup the framework 
    chmod +x update.sh \
        && composer install \
        && php artisan key:generate \
        && php artisan config:clear
        
    # wait for database to be up
    sleep 10
    php artisan migrate --force --seed
        
    echo "Setup done."
fi

# Run the original entrypoint
exec docker-php-entrypoint php-fpm
