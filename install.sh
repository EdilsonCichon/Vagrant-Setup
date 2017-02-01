#!/usr/bin/env bash

echo "--- Good morning, master. Let's get to work. Installing now. ---"

echo "--- Updating packages list ---"
sudo apt-get update

echo "--- Installing base packages ---"
sudo apt-get install -y vim curl python-software-properties

echo "--- We want the bleeding edge of PHP, right master? ---"
sudo add-apt-repository -y ppa:ondrej/php

echo "--- Add repository the Git new releases ---"
sudo add-apt-repository -y ppa:git-core/ppa

echo "--- Installing Git ---"
sudo apt-get install -y git

#+============================================+
#|             Packages Server WEB            |
#+============================================+

echo "--- Updating packages list ---"
sudo apt-get update

echo "--- Installing MySQL package ---"
# No Prompt:
export DEBIAN_FRONTEND="noninteractive"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"
sudo apt-get install -y mysql-server

echo "--- Installing Apache2 package ---"
sudo apt-get install -y apache2

echo "--- Installing PHP-specific packages ---"
sudo apt-get install -y php7.1 php7.1-fpm libapache2-mod-php7.1 php7.1-curl php7.1-gd php7.1-mcrypt php7.1-xml php7.1-soap php7.1-zip php7.1-mysql git-core

echo "--- Installing Composer. ---"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

echo "--- Installing and configuring Xdebug ---"
# sudo apt-get install -y php5-xdebug
# cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
# xdebug.scream=1
# xdebug.cli_color=1
# xdebug.show_local_vars=1
# EOF
echo "--- Xdebug NOT configured yet! ---"

echo "--- Clean instalation apt-get ---"
apt-get --purge autoremove -y

echo "--- Enabling mod-rewrite ---"
sudo a2enmod rewrite
echo "--- Enabling PHP mcrypt ---"
sudo phpenmod mcrypt

echo "--- Setting document root ---"
sudo rm -rf /var/www/html/*
sudo ln -fs /vagrant/ /var/www/html/
#sudo mkdir /var/www/html/cichon
#sudo mkdir /var/www/html/cichon


echo "--- Enable reporting/display errors PHP ---"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php7.1/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php7.1/apache2/php.ini

sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

echo "--- Configuring Command 'vhost' VirtualHost do Apache ---"
sudo a2enmod rewrite
wget https://gist.github.com/fideloper/2710970/raw/vhost.sh
sudo chmod guo+x vhost.sh
sudo mv vhost.sh /usr/local/bin/vhost

echo "--- Setting VirtualHost project ---"
VHOST=$(cat <<EOF
<VirtualHost *:80>
  ServerName cichon.dev
  DocumentRoot "/var/www/html/cichon"
  <Directory />
    Options FollowSymlinks
    AllowOverride None
  </Directory>
  <Directory "/var/www/html/cichon">
    AllowOverride All
  </Directory>

  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
)

#echo "$VHOST" > /etc/apache2/sites-available/cichon.conf

echo "--- Enabling VirtualHost created ---"
#sudo a2ensite cichon.conf

echo "--- Restarting Apache ---"
sudo service apache2 restart

# Laravel stuff here, if you want

echo "--- All set to go! Would you like to play a game? ---"
