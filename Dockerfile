FROM wyveo/nginx-php-fpm:php71

ARG ORDERJUTSU_LINK
ARG DB_HOST
ARG DB_DATABASE
ARG DB_USER
ARG DB_PASSWORD

# Check env vars and install requirements
RUN test -n "$ORDERJUTSU_LINK" \
    && test -n "$DB_HOST" \
    && test -n "$DB_DATABASE" \
    && test -n "$DB_USER" \
    && test -n "$DB_PASSWORD" \
    && apt-get update \
    && apt-get -y install curl \
    && apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/*
        
# Overwrite nginx configuration
COPY ./nginx.conf /etc/nginx/conf.d/default.conf 
COPY ./php-fpm.conf /etc/php/7.1/fpm/pool.d/

# Copy init script to migrate database at startup
COPY ./init.sh /init.sh   

# Download and extract orderjutsu zip file
RUN curl -sS $ORDERJUTSU_LINK -o orderjutsu.zip && \
    unzip orderjutsu.zip && \
    cp -r orderjutsu-* /var/www && \ 
    chown -R nginx:nginx /var/www/ && \   
    rm -r orderjutsu-* orderjutsu.zip
    
# Setup 
RUN cd /var/www && \
    cp .env.example .env && \
    sed -i "s/.*DB_HOST=.*/DB_HOST=$DB_HOST/g" .env && \
    sed -i "s/.*DB_DATABASE=.*/DB_DATABASE=$DB_DATABASE/g" .env && \
    sed -i "s/.*DB_USERNAME=.*/DB_USERNAME=$DB_USER/g" .env && \ 
    sed -i "s/.*DB_PASSWORD=.*/DB_PASSWORD=$DB_PASSWORD/g" .env && \
    chmod +x update.sh && \
    chmod +x /init.sh

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    cd /var/www/ && \
    composer install && \
    php artisan key:generate && \
    php artisan config:clear
    
ENTRYPOINT /init.sh
