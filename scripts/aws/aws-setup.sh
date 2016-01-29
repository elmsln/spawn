#!/bin/bash
# This is the code needed to setup your environment to be able to connect to your AWS Account and use the AWS CLI. 
# This is not specific to the EC2 instances that will be built, rather it is what connects the user running the commands
# to the entire console and suite of AWS services.

# You will want to make sure that you have pip installed before doing anything 
# Run as root
curl -O https://bootstrap.pypa.io/get-pip.py

# Install pip as root
python get-pip.py

# Install AWS
pip install awscli

