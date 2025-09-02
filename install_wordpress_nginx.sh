#!/bin/bash
# اسکریپت نصب وردپرس روی Ubuntu 24 با امنیت و سرعت بالا

echo "==== راه‌اندازی وردپرس با امنیت و سرعت حداکثری ===="
read -p "دامنه اصلی (مثال: webcodex.ir): " DOMAIN
read -p "ایمیل مدیر (برای SSL): " EMAIL
read -p "نام دیتابیس وردپرس (مثال: wordpress): " DBNAME
read -p "یوزر دیتابیس وردپرس (مثال: wpuser): " DBUSER
read -s -p "پسورد دیتابیس وردپرس: " DBPASS; echo
read -s -p "پسورد root دیتابیس: " ROOTPASS; echo

sudo apt update && sudo apt upgrade -y
sudo apt install unzip nginx mariadb-server php-fpm php-mysql php-xml php-gd php-curl php-mbstring php-zip php-intl php-bcmath php-imagick redis-server php-redis ufw fail2ban certbot python3-certbot-nginx netdata -y

sudo systemctl enable nginx mariadb php8.3-fpm redis-server netdata
sudo systemctl start nginx mariadb php8.3-fpm redis-server netdata

sudo mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOTPASS}';
CREATE DATABASE IF NOT EXISTS ${DBNAME} DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${DBUSER}'@'%' IDENTIFIED BY '${DBPASS}';
GRANT ALL PRIVILEGES ON ${DBNAME}.* TO '${DBUSER}'@'%';
FLUSH PRIVILEGES;
EOF

sudo sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
sudo systemctl restart mariadb

sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw allow 3306/tcp
sudo ufw --force enable

sudo mkdir -p /var/www/${DOMAIN}
cd /tmp
sudo wget https://wordpress.org/latest.zip
sudo unzip latest.zip
sudo mv wordpress/* /var/www/${DOMAIN}/
sudo rm -rf wordpress latest.zip
sudo chown -R www-data:www-data /var/www/${DOMAIN}
sudo chmod -R 755 /var/www/${DOMAIN}

NGINX_CONF="/etc/nginx/sites-available/${DOMAIN}"
sudo tee ${NGINX_CONF} > /dev/null <<EOL
server {
    listen 80;
    server_name ${DOMAIN} www.${DOMAIN};
    root /var/www/${DOMAIN};
    index index.php index.html index.htm;
    client_max_body_size 64M;
    location / { try_files \$uri \$uri/ /index.php?\$args; }
    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg)\$ { expires 30d; access_log off; }
    location ~ /\.ht { deny all; }
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
}
EOL

sudo ln -sf ${NGINX_CONF} /etc/nginx/sites-enabled/${DOMAIN}
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t && sudo systemctl reload nginx

sudo certbot --nginx -d ${DOMAIN} -d www.${DOMAIN} --email ${EMAIL} --agree-tos --redirect --non-interactive

sudo sed -i 's/^#Port .*/Port 2222/' /etc/ssh/sshd_config
sudo sed -i 's/^PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl reload sshd

sudo systemctl enable fail2ban
sudo systemctl start fail2ban

sudo tee -a /etc/mysql/mariadb.conf.d/50-server.cnf > /dev/null <<EOL

innodb_buffer_pool_size = 512M
query_cache_type = 1
query_cache_size = 64M
EOL
sudo systemctl restart mariadb

echo "✅ نصب کامل شد! سایتت آماده است: https://${DOMAIN}"
echo "برای امنیت و سرعت بیشتر، افزونه‌های Wordfence و Redis Object Cache و UpdraftPlus را نصب کن."
echo "SSH روی پورت 2222 تنظیم شد، SFTP با همین پورت."
