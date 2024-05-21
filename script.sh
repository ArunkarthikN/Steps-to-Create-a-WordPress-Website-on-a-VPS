#!/bin/bash

# Function to prompt the user for input
prompt_for_input() {
    read -p "$1" input
    echo $input
}

# Prompt the user for necessary inputs
IP_ADDRESS=$(prompt_for_input "Enter your server IP address: ")
DOMAIN_NAME=$(prompt_for_input "Enter your domain name (e.g., example.com): ")
DB_NAME=$(prompt_for_input "Enter the name for your MySQL database: ")
DB_USER=$(prompt_for_input "Enter the MySQL database username: ")
DB_PASSWORD=$(prompt_for_input "Enter the MySQL database password: ")
EMAIL=$(prompt_for_input "Enter your email address for SSL certificate: ")

# System Preparation
echo "Updating system and configuring /etc/hosts..."
sudo apt update && sudo apt upgrade -y
echo "$IP_ADDRESS $DOMAIN_NAME" | sudo tee -a /etc/hosts

# Setting Up Swap Space
echo "Setting up 2GB swap space..."
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile swap swap defaults 0 0' | sudo tee -a /etc/fstab

# Installing LAMP Server
echo "Installing LAMP server..."
sudo apt install -y tasksel
sudo tasksel install lamp-server
sudo apt install -y php php-curl php-gd php-mbstring php-xml php-xmlrpc

# Configuring Apache for Your Domain
echo "Configuring Apache for your domain..."
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$DOMAIN_NAME.conf
sudo sed -i "s|DocumentRoot /var/www/html|DocumentRoot /var/www/$DOMAIN_NAME|" /etc/apache2/sites-available/$DOMAIN_NAME.conf
sudo sed -i "s|#ServerName www.example.com|ServerName $DOMAIN_NAME\nServerAlias www.$DOMAIN_NAME|" /etc/apache2/sites-available/$DOMAIN_NAME.conf

sudo mkdir -p /var/www/$DOMAIN_NAME
echo "<html><body><h1>$DOMAIN_NAME</h1></body></html>" | sudo tee /var/www/$DOMAIN_NAME/index.html

sudo a2dissite 000-default.conf
sudo a2ensite $DOMAIN_NAME.conf
sudo systemctl reload apache2

# Preparing MySQL Database
echo "Setting up MySQL database..."
sudo mysql -e "CREATE DATABASE $DB_NAME;"
sudo mysql -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
sudo mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"
sudo mysql_secure_installation

# Installing and Configuring PHP
echo "Configuring PHP..."
sudo sed -i "s/upload_max_filesize = .*/upload_max_filesize = 30M/" /etc/php/8.2/apache2/php.ini
sudo sed -i "s/post_max_size = .*/post_max_size = 21M/" /etc/php/8.2/apache2/php.ini
sudo sed -i "s/max_input_time = .*/max_input_time = 30/" /etc/php/8.2/apache2/php.ini

# Installing and Configuring WordPress
echo "Installing WordPress..."
cd /var/www/$DOMAIN_NAME
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzvf latest.tar.gz --strip-components=1
sudo rm latest.tar.gz

sudo cp wp-config-sample.php wp-config.php
sudo sed -i "s/database_name_here/$DB_NAME/" wp-config.php
sudo sed -i "s/username_here/$DB_USER/" wp-config.php
sudo sed -i "s/password_here/$DB_PASSWORD/" wp-config.php

# Configure Apache for Performance
echo "Configuring Apache for performance..."
sudo tee /etc/apache2/mods-enabled/mpm_prefork.conf <<EOF
<IfModule mpm_prefork_module>
 StartServers            5
 MinSpareServers         5
 MaxSpareServers         10
 ServerLimit             20
 MaxClients              20
 MaxRequestWorkers       20
 MaxConnectionsPerChild  3000
</IfModule>
EOF
sudo systemctl restart apache2

# Enabling SSL
echo "Enabling SSL with Certbot..."
sudo apt-get install -y python3-certbot-apache
sudo certbot --apache -m $EMAIL -d $DOMAIN_NAME -d www.$DOMAIN_NAME

sudo tee -a wp-config.php <<EOF
define('WP_HOME', 'https://$DOMAIN_NAME');
define('WP_SITEURL', 'https://$DOMAIN_NAME');
define('FORCE_SSL_ADMIN', true);
EOF

# Scheduling SSL Certificate Renewal
echo "Scheduling SSL certificate renewal..."
(crontab -l 2>/dev/null; echo "0 1 * * * /usr/bin/certbot renew > /dev/null") | sudo crontab -

# Adjusting Permissions and .htaccess
echo "Adjusting permissions and .htaccess..."
sudo chown -R www-data:www-data /var/www/$DOMAIN_NAME

sudo tee /var/www/$DOMAIN_NAME/.htaccess <<EOF
# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress

php_value upload_max_filesize 256M
php_value post_max_size 128M
php_value memory_limit 256M
php_value max_execution_time 300
php_value max_input_time 300
EOF

echo "WordPress installation and configuration complete. Please visit https://$DOMAIN_NAME to finish the setup through the WordPress web interface."
