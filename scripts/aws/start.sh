#!/bin/sh

# You will want to make sure that you have pip installed before doing anything 
# Run as root
curl -O https://bootstrap.pypa.io/get-pip.py

# Install pip as root
python get-pip.py

# Install AWS
pip install awscli

# Now we can configure... but we will need keys and stuff. 
aws configure

#! /bin/bash
######### NOT TESTED THIS IS JUST SCAFFOLDING #########################

# basic config variables needed to run an aws ec2 instance setup
keyname=input1
mySecurityGroup=input2
securityDescription=input3
sgId="$(aws ec2 create-security-group --group-name $mySecurityGroup --description "$securityDescription" --query 'GroupId')"
amiId=input4
count=input5
iType=input6

# Create key pair and capture the output for the .pem file 
aws ec2 create-key-pair --key-name $key-name --query 'KeyMaterial' > $key-name.pem

# change permissions to read only for user
chmod 400 $key-name.pem

# Create First Security Group and Catch Id you will need it to create an instance. The variable is set in basic config and will be
# used when spawing the instance.
aws ec2 create-security-group --group-name $mySecurityGroup --description "$securityDescription" --query 'GroupId' 

# Create a new instance to run stuff on
aws ec2 run-instances --image-id amiId --count $count --instance-type type --key-name keyname --security-group-ids $sgId
