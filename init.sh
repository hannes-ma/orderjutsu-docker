#!/bin/bash

cd /var/www

# wait for db service to be up
sleep 10

php artisan migrate --force --seed

# Run the original CMD from the parent image
exec "/start.sh"
