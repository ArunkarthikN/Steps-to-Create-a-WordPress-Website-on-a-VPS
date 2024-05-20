# Steps-to-Create-a-WordPress-Website-on-a-VPS
This repository provides a comprehensive guide to setting up a WordPress website on a Virtual Private Server (VPS) using a LAMP stack (Linux, Apache, MySQL, PHP). The guide covers system preparation, installation, configuration, and optimization steps to ensure your WordPress site runs smoothly and securely.

# Table of Contents
1. [System Preparation](#system-preparation)
2. [Setting Up Swap Space](#setting-up-swap-space)
3. [Installing LAMP Server](#installing-lamp-server)
4. [Configuring Apache for Your Domain](#configuring-apache-for-your-domain)
5. [Preparing MySQL Database](#preparing-mysql-database)
6. [Installing and Configuring PHP](#installing-and-configuring-php)
7. [Installing and Configuring WordPress](#installing-and-configuring-wordpress)
8. [Enabling SSL](#enabling-ssl)
9. [Scheduling SSL Certificate Renewal](#scheduling-ssl-certificate-renewal)
10. [Adjusting Permissions and .htaccess](#adjusting-permissions-and-htaccess)
11. [Tuning PHP Settings for WordPress](#tuning-php-settings-for-wordpress)
12. [Uploading the Project to GitHub](#uploading-the-project-to-github)

# System Preparation
Update the system and configure the /etc/hosts file to include your IP and domain names.

1. Open the hosts file:

```sh
sudo nano /etc/hosts
```
2. Add your IP and domain names:
```sh
your_ipaddress yourdomainname(example.com)
```

3. Update and Upgrade the System
Update and upgrade the package lists:

```sh
sudo apt update && sudo apt upgrade
```


# Setting Up Swap Space
Create an 2GB swap file to improve system performance.

1. Create an 2GB swap file:

```sh
sudo fallocate -l 2G /swapfile

```
2. Secure the swap file and set it up:

```sh
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

```
3. Add the swap file to the fstab file for automatic mounting:

 ```sh
sudo nano /etc/fstab
```
4. Add the following line to the end of the file:

```sh
 /swapfile swap swap defaults 0 0
```
5. Check if the swap is active:

```sh

htop


```
   

# Installing LAMP Server
Install and configure the LAMP stack, including Apache, MySQL, and PHP, along with additional PHP modules required for WordPress.

1. Install tasksel:

```sh

sudo apt install tasksel

```

2. Install LAMP server:

```sh

sudo tasksel install lamp-server


```

3. Install additional PHP modules:

```sh

sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc

```

# Configuring Apache for Your Domain
Set up Apache virtual hosts to serve your domain, and create the necessary directory structure for your site.

1. Navigate to Apache's sites-available directory:

```sh
cd /etc/apache2/sites-available/

```
2. Copy the default configuration file to a new file for your site:

```sh
sudo cp 000-default.conf example.com.conf

```

3. Edit the new configuration file:

```sh
sudo nano example.com.conf

```

4. Change the contents to:

```sh
<VirtualHost *:80>
    ServerName example.com
    ServerAlias www.example.com
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/example.com
    <Directory /var/www/example.com>
        Require all granted
    </Directory>
</VirtualHost>

```
5. Create the website directory and copy the index.html file:

```sh
sudo mkdir -p /var/www/example.com
sudo cp /var/www/html/index.html /var/www/example.com/index.html

```

6. Disable the default site and enable your site:

```sh
sudo a2dissite 000-default.conf
sudo a2ensite example.com.conf
```



# Preparing MySQL Database
Create a MySQL database and user for your WordPress installation, and configure the database for secure access.

1. Log in to MySQL:

```sh
   sudo mysql -u root
```

2. Create a new database and user:

```sh
CREATE DATABASE database_name;
CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON database_name.* TO 'username'@'localhost' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
```

Run the MySQL secure installation script to improve security:

```sh
sudo mysql_secure_installation
```
During the mysql_secure_installation process, you will be prompted to configure various settings:

**Set the root password:** Choose a secure password for the MySQL root user.<br>
**Remove anonymous users:** Yes<br>
**Disallow root login remotely:** Yes<br>
**Remove test database and access to it:** Yes<br>
**Reload privilege tables now:** Yes<br>


# Installing and Configuring PHP
Modify PHP settings to accommodate WordPress requirements, ensuring optimal performance and functionality.

1. Edit the php.ini file:

```sh
cd /etc/php/8.2/apache2
sudo nano php.ini
```

2. Search and Modify the following settings:

```sh
max_input_time = 30
upload_max_filesize = 30M
post_max_size = 21M
```

   

# Installing and Configuring WordPress
Download and install WordPress, configure database settings, and set up your site for initial use.

# Enabling SSL
Install and configure SSL certificates using Certbot to secure your website with HTTPS.

# Scheduling SSL Certificate Renewal
Set up a cron job to automatically renew SSL certificates, ensuring continuous security.

# Adjusting Permissions and .htaccess
Configure file and directory permissions for WordPress, and update the .htaccess file for URL rewriting and performance tuning.

# Tuning PHP Settings for WordPress
Adjust PHP settings in the .htaccess file to handle larger uploads and optimize execution times.
