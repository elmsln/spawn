# spawn
A distribution for helping managing multiple drupal, distribution, elmsln and other package deployments in EC2

Basically we need to start organizing scripts to run application specific routines.
For now and possibly forever, we will create an AMI to be used as our baseline.

## It shall be named SPAWN.

It will have all the common repeatable packages that we currently spin up on each install routine. Since we are assuming a certain level of responsibility for items like php, apache, mysql, patch, git, wget, etc... it doesn't make sense to run those every time we spin up an instance.

1 liners will be kicked off after the initialization of the IAM user and the EC2 system is in place. These 1 liners should be organized into application specific zones.

For instance:

- ELMSLN
- NITTANY DRUPAL
- VANILLA DRUPAL
- WORDPRESS
- NODE JS CHAT
- ETC...
One thing to note is that SPAWN can be run from anywhere. Essentially if you can install a Drupal site you can install SPAWN.
