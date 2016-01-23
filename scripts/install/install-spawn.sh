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
yes | yum -y install curl uuid patch git nano gcc make mysql mysql-server httpd
# amazon packages on 56
yes | yum -y install php56 php56-common php56-opcache php56-fpm php56-pecl-apcu php56-cli php56-pdo php56-mysqlnd php56-gd php56-mbstring php56-mcrypt php56-xml php56-devel php56-pecl-ssh2 --skip-broken

yes | yum groupinstall 'Development Tools'
pecl channel-update pecl.php.net

# set httpd_can_sendmail so drupal mails go out
setsebool -P httpd_can_sendmail on
# start mysql to ensure that it is running
/etc/init.d/mysqld restart

# optimize apc
echo "" >> /etc/php.d/40-apcu.ini
echo "apc.rfc1867=1" >> /etc/php.d/40-apcu.ini
echo "apc.rfc1867_prefix=upload_" >> /etc/php.d/40-apcu.ini
echo "apc.rfc1867_name=APC_UPLOAD_PROGRESS" >> /etc/php.d/40-apcu.ini
echo "apc.rfc1867_freq=0" >> /etc/php.d/40-apcu.ini
echo "apc.rfc1867_ttl=3600" >> /etc/php.d/40-apcu.ini
# optimize opcodecache for php 5.5
echo "opcache.enable=1" >> /etc/php.d/10-opcache.ini
echo "opcache.memory_consumption=256" >> /etc/php.d/10-opcache.ini
echo "opcache.max_accelerated_files=100000" >> /etc/php.d/10-opcache.ini
echo "opcache.max_wasted_percentage=10" >> /etc/php.d/10-opcache.ini
echo "opcache.revalidate_freq=2" >> /etc/php.d/10-opcache.ini
echo "opcache.validate_timestamps=1" >> /etc/php.d/10-opcache.ini
echo "opcache.fast_shutdown=1" >> /etc/php.d/10-opcache.ini
echo "opcache.interned_strings_buffer=8" >> /etc/php.d/10-opcache.ini
echo "opcache.enable_cli=1" >> /etc/php.d/10-opcache.ini
# remove default apc file that might exist
yes | rm /etc/php-5.6.d/apc.ini
yes | rm /etc/php.d/apc.ini

/etc/init.d/httpd restart
/etc/init.d/mysqld restart

# add a user group of spawn
/usr/sbin/groupadd spawn
# add the system user and put them in the above group
/usr/sbin/useradd -g spawn spawn -m -d /home/spawn -s /bin/bash -c "Spawn task runner"

# create a new file inside sudoers.d
touch /etc/sudoers.d/spawn

# this user can do anything basically since it has to create so much stuff
echo "spawn ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/spawn
chmod 440 /etc/sudoers.d/spawn
# replicate the .composer directory for this user since composer doesn't like sudo -i
cp -R $HOME/.composer /home/spawn/
chown -R spawn:spawn /home/spawn/
chmod -R 770 /home/spawn
# copy spawn cron job into scope
cat /var/www/spawn/scripts/server/crontab.txt >> /etc/crontab

# TODO need to optimize

ln -s /var/www/spawn/scripts/spawn-job /usr/local/bin/spawn-job

cd $HOME
source .bashrc
end="$(timestamp)"
spawnecho "This took $(expr $end - $start) seconds to complete the whole thing!"
