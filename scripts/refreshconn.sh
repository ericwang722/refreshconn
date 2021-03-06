#!/bin/bash

#download the key from S3
aws s3 cp s3://$S3_BUNDLE_NAME/ghe-admin-private-key ~/.ssh/ghe-admin-private-key.pem
chmod 400 ~/.ssh/ghe-admin-private-key.pem

#get the current host ip using http://instance-data
HOST_IP=$(curl http://instance-data/latest/meta-data/public-ipv4)

#ssh into host and run contrack
ssh -tt -i ~/.ssh/ghe-admin-private-key.pem ec2-user@$HOST_IP   \
"sudo yum install conntrack-tools.x86_64 -y;sudo conntrack -D -p udp;sudo conntrack -F"
