composer global require drush/drush:7.*
echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >> $HOME/.bashrc
echo 'alias sync="sudo rsync -zavr --delete --exclude sites/default/* /var/www/html/drupal-7/ /vagrant/drupal-7/"' >> $HOME/.bashrc

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable
source /home/vagrant/.rvm/scripts/rvm
rvm get head
source $HOME/.bashrc

cd /var/www/html/drupal-7/sites/all/themes/spawn
npm install
gem install bundler
bundle install
grunt build
