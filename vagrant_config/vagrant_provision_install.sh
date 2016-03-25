#!/usr/bin/env bash

echo "---------------------------------------------------------------"
echo " "
echo " "
echo "      VAGRANT PROVISION INSTALLS"
echo " "
echo " "
echo "---------------------------------------------------------------"


echo "---------------------------------------------------------------"
echo "UPDATING APT-GET"
echo "---------------------------------------------------------------"
apt-get update
apt-get install libxrender1
apt-get install libfontconfig1
apt-get install unzip

echo "---------------------------------------------------------------"
echo "INSTALLING GIT"
echo "---------------------------------------------------------------"
apt-get install -y git


echo "----------------------------------------------------------------"
echo "INSTALLING NGINX"
echo "----------------------------------------------------------------"
apt-get install -y nginx
service nginx stop

cp /home/vagrant/config/nginx.conf /etc/nginx/nginx.conf
sudo rm -f /etc/nginx/sites-available/default.conf
cp /home/vagrant/config/site.conf.template /etc/nginx/sites-available/default.conf
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/

service nginx start

echo "---------------------------------------------------------------"
echo "INSTALLING PHP"
echo "---------------------------------------------------------------"
apt-get install python-software-properties build-essential -y
add-apt-repository ppa:ondrej/php5 -y
apt-get update
apt-get install php5-common php5-dev php5-cli php5-fpm -y
echo "Installing PHP extensions"
apt-get install curl php5-curl php5-gd php5-mcrypt php5-mysql php5-sybase -y

echo "---------------------------------------------------------------"
echo "INSTALLING MYSQL"
echo "---------------------------------------------------------------"
apt-get install debconf-utils -y
debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"
apt-get install mysql-server -y
mysql -proot --execute="grant all privileges on *.* to 'root'@'%' identified by '1234';"
cp /home/vagrant/config/my.cnf /etc/mysql/my.cnf
service mysql restart

echo "---------------------------------------------------------------"
echo "INSTALLING COMPOSER"
echo "---------------------------------------------------------------"
php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php
php composer-setup.php --install-dir=/bin --filename=composer


echo "---------------------------------------------------------------"
echo "INSTALLING REDIS"
echo "---------------------------------------------------------------"
apt-get install -y redis-server

echo "---------------------------------------------------------------"
echo "INSTALLING NODEJS"
echo "---------------------------------------------------------------"
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "---------------------------------------------------------------"
echo "INSTALLING RUBY"
echo "---------------------------------------------------------------"
apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev -y
apt-get install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev -y
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable
apt-get install ruby2.0 ruby2.0-dev -y
rvm use --default 2.0
echo "---------------------------------------------------------------"
echo "USING RUBY VERSION"
echo "---------------------------------------------------------------"
ruby -v
echo "---------------------------------------------------------------"
echo "INSTALLING MAILHOG"
echo "---------------------------------------------------------------"
wget https://github.com/mailhog/MailHog/releases/download/v0.2.0/MailHog_linux_amd64
sudo mv MailHog_linux_amd64 /usr/bin/mailhog
sudo chmod 755 /usr/bin/mailhog

echo "---------------------------------------------------------------"
echo "INSTALLING ELASTCSEARCH"
echo "---------------------------------------------------------------"
apt-get install openjdk-7-jre -y
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
sudo apt-get update && sudo apt-get install elasticsearch
sudo update-rc.d elasticsearch defaults 95 10

echo "---------------------------------------------------------------"
echo "GENERATE LOCALE"
echo "---------------------------------------------------------------"
sudo locale-gen en_US.utf8
sudo locale-gen es_ES.utf8
sudo locale-gen es_CO.utf8
sudo locale-gen es_VE.utf8

echo "---------------------------------------------------------------"
echo "INSTALLING KIBANA"
echo "---------------------------------------------------------------"
sudo wget --directory=/opt https://download.elastic.co/kibana/kibana/kibana-4.4.2-linux-x64.tar.gz && sudo tar xvzf /opt/kibana-4.4.2-linux-x64.tar.gz -C /opt && rm /opt/kibana-4.4.2-linux-x64.tar.gz
sudo cp -f /home/vagrant/config/kibana.yml /opt/kibana-4.4.2-linux-x64/config/

echo "---------------------------------------------------------------"
echo "INSTALLING SENSE"
echo "---------------------------------------------------------------"
sudo /opt/kibana-4.4.2-linux-x64/bin/kibana plugin --install elastic/sense

