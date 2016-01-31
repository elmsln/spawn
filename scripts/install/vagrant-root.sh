#!/bin/bash
# a script to install server dependencies

# provide messaging colors for output to console
txtbld=$(tput bold)             # Bold
bldgrn=$(tput setaf 2) #  green
bldred=${txtbld}$(tput setaf 1) #  red
txtreset=$(tput sgr0)
spawnecho(){
  echo "${bldgrn}$1${txtreset}"
}
spawnwarn(){
  echo "${bldred}$1${txtreset}"
}
# Define seconds timestamp
timestamp(){
  date +"%s"
}
start="$(timestamp)"

# make sure we're up to date
yes | yum update

# using yum to install the main packages
yes | yum -y install curl uuid patch git nano gcc make httpd

# get some repos
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
rpm -Uvh remi-release-7.rpm

# get latest mysql
yum install -y http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm 
yum install -y mysql mysql-server
systemctl enable mysqld.service
/bin/systemctl start  mysqld.service
yum update -y

# Install PHP from REMI
yum install -y --enablerepo=remi-php56 php php-apcu php-fpm php-opcache php-cli php-common php-gd php-mbstring php-mcrypt php-pdo php-xml php-mysqlnd

pecl channel-update pecl.php.net

# set httpd_can_sendmail so drupal mails go out
setsebool -P httpd_can_sendmail on

# remove default apc file that might exist
yes | rm /etc/php-5.6.d/apc.ini
yes | rm /etc/php.d/apc.ini

# add a user group of spawn
/usr/sbin/groupadd spawn
# add the system user and put them in the above group
/usr/sbin/useradd -g spawn spawn -m -d /home/spawn -s /bin/bash -c "Spawn task runner"

# create a new file inside sudoers.d
touch /etc/sudoers.d/spawn

# this user can do anything basically since it has to create so much stuff
echo "spawn ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/spawn
chmod 440 /etc/sudoers.d/spawn

# PHP
# The first pool
cat /vagrant/php/www.conf > /etc/php-fpm.d/www.conf

# OPCACHE settings
cat /vagrant/php/opcache.ini > /etc/php.d/10-opcache.ini

# Disable mod_php
cat /vagrant/php/php.conf > /etc/httpd/conf.d/php.conf

# Disable some un-needed apache modules.
cat /vagrant/modules/00-base.conf > /etc/httpd/conf.modules.d/00-base.conf
cat /vagrant/modules/00-dav.conf > /etc/httpd/conf.modules.d/00-dav.conf
cat /vagrant/modules/00-lua.conf > /etc/httpd/conf.modules.d/00-lua.conf
cat /vagrant/modules/00-mpm.conf > /etc/httpd/conf.modules.d/00-mpm.conf
cat /vagrant/modules/00-proxy.conf > /etc/httpd/conf.modules.d/00-proxy.conf
cat /vagrant/modules/01-cgi.conf > /etc/httpd/conf.modules.d/01-cgi.conf

# BASIC PERFORMANCE SETTINGS
mkdir /etc/httpd/conf.performance.d/
cat /vagrant/performance/compression.conf > /etc/httpd/conf.performance.d/compression.conf
cat /vagrant/performance/content_transformation.conf > /etc/httpd/conf.performance.d/content_transformation.conf
cat /vagrant/performance/etags.conf > /etc/httpd/conf.performance.d/etags.conf
cat /vagrant/performance/expires_headers.conf > /etc/httpd/conf.performance.d/expires_headers.conf
cat /vagrant/performance/file_concatenation.conf > /etc/httpd/conf.performance.d/file_concatenation.conf
cat /vagrant/performance/filename-based_cache_busting.conf > /etc/httpd/conf.performance.d/filename-based_cache_busting.conf

# BASIC SECURITY SETTINGS
mkdir /etc/httpd/conf.security.d/
cat /vagrant/security/apache_default.conf > /etc/httpd/conf.security.d/apache_default.conf

# BASIC DOMAIN 
mkdir /etc/httpd/conf.sites.d
echo IncludeOptional conf.sites.d/*.conf >> /etc/httpd/conf/httpd.conf
cat /vagrant/domains/80-domain.conf > /etc/httpd/conf.sites.d/test.conf

# Performance
echo IncludeOptional conf.performance.d/*.conf >> /etc/httpd/conf/httpd.conf

# APC optimize
echo "" >> /etc/php.d/40-apcu.ini
echo "apc.rfc1867=1" >> /etc/php.d/40-apcu.ini
echo "apc.rfc1867_prefix=upload_" >> /etc/php.d/40-apcu.ini
echo "apc.rfc1867_name=APC_UPLOAD_PROGRESS" >> /etc/php.d/40-apcu.ini
echo "apc.rfc1867_freq=0" >> /etc/php.d/40-apcu.ini
echo "apc.rfc1867_ttl=3600" >> /etc/php.d/40-apcu.ini

# Minor Security config
echo IncludeOptional conf.security.d/*.conf >> /etc/httpd/conf/httpd.conf

# Fix date timezone errors
sed -i 's#;date.timezone =#date.timezone = "America/New_York"#g' /etc/php.ini

# Make sue services stay on after reboot
systemctl enable httpd.service
systemctl enable mysqld.service
systemctl enable php-fpm.service

# This is moslty for DEV
sudo systemctl stop firewalld.service

# Start all the services we use.
systemctl start php-fpm.service
systemctl start  mysqld.service
systemctl start httpd.service

# Install Drush globally.
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
ln -s /usr/local/bin/composer /usr/bin/composer

# TODO need to optimize
#ln -s /var/www/spawn/scripts/spawn-job /usr/local/bin/spawn-job

cd $HOME
source .bashrc
end="$(timestamp)"
spawnecho "This took $(expr $end - $start) seconds to complete the whole thing!"
