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

```sh
sudo nano /etc/hosts
```sh


# Setting Up Swap Space
Create an 8GB swap file to improve system performance.

# Installing LAMP Server
Install and configure the LAMP stack, including Apache, MySQL, and PHP, along with additional PHP modules required for WordPress.

# Configuring Apache for Your Domain
Set up Apache virtual hosts to serve your domain, and create the necessary directory structure for your site.

# Preparing MySQL Database
Create a MySQL database and user for your WordPress installation, and configure the database for secure access.

# Installing and Configuring PHP
Modify PHP settings to accommodate WordPress requirements, ensuring optimal performance and functionality.

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
