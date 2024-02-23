Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"
#!/bin/bash

#variables
nombreSitio=lana 
passsql=1234
hostdatabase=127.0.0.1
usuariosql=lana


#repsitorio e insalacion de php
sudo add-apt-repository ppa:ondrej/php
sudo apt update -y
sudo apt install php8.2 -y
sudo apt-get install -y php8.2-cli php8.2-common php8.2-fpm php8.2-mysql php8.2-zip php8.2-gd php8.2-mbstring php8.2-curl php8.2-xml php8.2-bcmath
sudo systemctl restart php8.2-fpm

#insalacion de mysql
sudo rm /var/lib/mysql/ -R
sudo rm /etc/mysql/ -R
sudo apt-get autoremove mysql* --purge
sudo apt-get remove apparmor
sudo wget https://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz
sudo groupadd mysql
sudo useradd -g mysql mysql
sudo tar -xvf mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz
sudo mv mysql-5.6.46-linux-glibc2.12-x86_64 /usr/local/mysql
sudo rm mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz
cd /usr/local/mysql
sudo chown -R mysql:mysql *
sudo apt-get install libaio1 libncurses5
sudo scripts/mysql_install_db --user=mysql
cd /usr/local
sudo chown -R root .
cd mysql
sudo chown -R mysql data
sudo cp support-files/my-default.cnf /etc/my.cnf
sudo bin/mysqld_safe --user=mysql &
sudo cp support-files/mysql.server /etc/init.d/mysql.server
sudo bin/mysqladmin -u root password $passsql
sudo ln -s /usr/local/mysql/bin/mysql /usr/local/bin/mysql
sudo /etc/init.d/mysql.server start
sudo update-rc.d -f mysql.server defaults

sudo apt update
sudo apt upgrade 
sudo apt install apt-file
sudo apt-file update
sudo apt-file find libncurses.so.5
sudo apt install libncurses5
sudo systemctl restart mysql

cd /home/ubuntu

#insalacion de nginx y wordpress
sudo systemctl stop apache2
sudo apt install nginx -y
sudo mkdir -p /var/www/html/$nombreSitio
sudo wget https://es-mx.wordpress.org/latest-es_MX.tar.gz
sudo tar xfvz latest-es_MX.tar.gz
sudo cp -r wordpress/* /var/www/html/$nombreSitio
sudo chown -R www-data /var/www/html/$nombreSitio
sudo chmod -R 755 /var/www/html/$nombreSitio
sudo rm latest-es_MX.tar.gz

#configuracines 
#construccion del servidor nginx
datos="server {\n
	listen 80;\n
	listen [::]:80;\n
	root /var/www/html/$nombreSitio;\n
	index index.php index.html index.htm;\n
	server_name $nombreSitio;\n

	location / { \n
	\t	try_files \$uri \$uri/ /index.php?\$query_string;\n
	}\n

	location ~ \.php$ {\n
	\t	fastcgi_split_path_info ^(.+\.php)(/.+)$;\n
	\t	fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;\n
	\t	fastcgi_index index.php;\n
	\t	fastcgi_param SCRIPT_FILENAME /var/www/html/$nombreSitio\$fastcgi_script_name;\n
	\t	include fastcgi_params;\n
	}\n
} "

#crear usuario base de datos
sudo echo "CREATE USER '$usuariosql'@'localhost' IDENTIFIED BY '$passsql'" | mysql -u root -h localhost
sudo echo "GRANT ALL PRIVILEGES ON * . * TO '$usuariosql'@'localhost'" | mysql -u root -h localhost
sudo echo "FLUSH PRIVILEGES" | mysql -u root -h localhost

sudo echo -e $datos >> /etc/nginx/sites-available/$nombreSitio

sudo systemctl restart nginx
sudo systemctl enable nginx

#creacion del wpconfig de wordpress
sudo cd /var/www/html/$nombreSitio

config="<?php\n
define( 'DB_NAME', 'mysql' );\n
define( 'DB_USER', '$usuariosql' );\n
define( 'DB_PASSWORD', '$passsql' );\n
define( 'DB_HOST', '$hostdatabase' );\n
define( 'DB_CHARSET', 'utf8' );\n
define( 'DB_COLLATE', '' );\n
define( 'AUTH_KEY',         'put your unique phrase here' );\n
define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );\n
define( 'LOGGED_IN_KEY',    'put your unique phrase here' );\n
define( 'NONCE_KEY',        'put your unique phrase here' );\n
define( 'AUTH_SALT',        'put your unique phrase here' );\n
define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );\n
define( 'LOGGED_IN_SALT',   'put your unique phrase here' );\n
define( 'NONCE_SALT',       'put your unique phrase here' );\n
\$table_prefix = 'wp_';\n
define( 'WP_DEBUG', false );\n
if ( ! defined( 'ABSPATH' ) ) {\n
        define( 'ABSPATH', __DIR__ . '/' );\n
}\n
require_once ABSPATH . 'wp-settings.php';\n
"

sudo rm wp-config.php
sudo echo -e $config >> /var/www/html/$nombreSitio/wp-config.php 
cd /etc/nginx/sites-available
sudo rm default 
sudo cp lana default
sudo systemctl restart nginx

