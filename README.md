# SPAWN
A distribution to manage multiple applications and package deployments in Amazon EC2 using a pre-configured AMI as a baseline.

## It shall be named SPAWN.

It will have all the common repeatable packages that we currently spin up on each install routine. Since we are assuming a certain level of responsibility for items like php, apache, mysql, patch, git, wget, etc... it doesn't make sense to run those every time we spin up an instance.

Scripts will be kicked off after the initialization of the IAM user and the EC2 system is in place. These scripts shall be organized into application specific zones.

For instance:

- ELMSLN
- NITTANY DRUPAL
- VANILLA DRUPAL
- WORDPRESS
- NODE JS CHAT
- ETC...

One thing to note is that SPAWN can be run from anywhere. Essentially if you can install a Drupal site you can install SPAWN.
