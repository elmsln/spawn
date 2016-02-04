composer global require drush/drush:7.*
echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >> $HOME/.bashrc
echo 'alias sync="sudo rsync -zavr --delete --exclude sites/default/* /var/www/html/drupal-7/ /vagrant/drupal-7/"' >> $HOME/.bashrc
