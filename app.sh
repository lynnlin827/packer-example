#!/bin/bash
sudo apt-get -y update
sudo apt-get -y install curl nginx php7.0 php7.0-fpm php7.0-mysql php7.0-sqlite3 php7.0-mbstring php-xml php7.0-zip
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
git clone https://github.com/lynn80827/demo-laravel-todo.git laravel
cd laravel
composer install --quiet
cat > .env <<EOF
APP_NAME=Laravel
APP_ENV=dev
APP_KEY=
APP_DEBUG=true
APP_LOG_LEVEL=error
APP_URL=http://localhost
EOF
sudo chown -R www-data:www-data /home/ubuntu/laravel
sudo chmod -R 755 /home/ubuntu/laravel/storage
sudo chmod -R 755 /home/ubuntu/laravel/public
sudo tee /etc/nginx/sites-available/default <<EOF
server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /home/ubuntu/laravel/public;
        index index.html index.htm index.nginx-debian.html index.php;
        server_name localhost;

        location / {
                try_files \$uri \$uri/ /index.php?\$query_string;
        }

        location ~ \.php\$ {
                include snippets/fastcgi-php.conf;

                fastcgi_pass unix:/run/php/php7.0-fpm.sock;
        }
}
EOF
sudo -u www-data php artisan key:generate
sudo nginx -s reload
