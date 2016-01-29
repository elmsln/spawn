#! /bin/bash
######### NOT TESTED THIS IS JUST SCAFFOLDING #########################

# basic config variables needed to run an aws ec2 instance setup
NEW_UUID="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)"
keyName="spawn-$NEW_UUID"
defaultSecurityGroup="spawn-http"
securityDescription="baseline security group for allowing traffic on port 80, 3306 over TCP"
sgId="$(aws ec2 create-security-group --group-name $mySecurityGroup --description "$securityDescription" --query 'GroupId')"
amiId="ami-60b6c60a" # this is the default Amazon AMI image
count=1
iType="t2.micro" # defaults to free tier

# Create key pair and capture the output for the .pem file 
aws ec2 create-key-pair --key-name $keyName --query 'KeyMaterial' > $keyName.pem

# change permissions to read only for user
chmod 400 $key-name.pem

# Create First Security Group and Catch Id you will need it to create an instance. The variable is set in basic config and will be
# used when spawing the instance.
aws ec2 create-security-group --group-name $defaultSecurityGroup --description "$securityDescription" --query 'GroupId' 

# Create a new instance to run stuff on
aws ec2 run-instances --image-id amiId --count $count --instance-type $iType --key-name keyname --security-group-ids $sgId

#todo = figure out where to go next... but this is all very easy to use. ;)
