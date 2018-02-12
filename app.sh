#!/bin/bash
curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get -y update
sudo apt-get -y install unzip curl nginx
sudo apt-get -y install yarn nodejs
sudo apt-get -y install php7.0 php7.0-fpm php7.0-mysql php7.0-sqlite3 php7.0-mbstring php-xml php7.0-zip
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
wget https://github.com/lynn80827/demo-laravel-todo/archive/rest-api.zip
unzip rest-api.zip
mv demo-laravel-todo-rest-api laravel
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
cd f2e
yarn install --pure-lockfile
yarn run build
cd ..
cp -R f2e/build/* public
sudo chown -R www-data:www-data /home/ubuntu/laravel
sudo chmod -R 755 /home/ubuntu/laravel/storage
sudo chmod -R 755 /home/ubuntu/laravel/public
sudo tee /etc/nginx/sites-available/default <<EOF
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /home/ubuntu/laravel/public;
        server_name localhost;

        location /api {
                index index.php;
                try_files \$uri \$uri/ /index.php?\$query_string;
        }

        location / {
                index index.html;
        }

        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php7.0-fpm.sock;
        }
}
EOF
sudo -u www-data php artisan key:generate
sudo nginx -s reload
