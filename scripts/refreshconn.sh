#!/bin/bash

#download the key from S3
aws s3 cp s3://$S3_BUNDLE_NAME/admin-key-pairs/ghe-admin-non-production-private-key ~/.ssh/ghe-admin-non-production-private-key.pem
chmod 400 ~/.ssh/ghe-admin-non-production-private-key.pem

#get the current host ip using http://instance-data
HOST_IP=$(curl http://instance-data/latest/meta-data/public-ipv4)

#ssh into host and run contrack
ssh -t -i ~/.ssh/ghe-admin-non-production-private-key.pem ec2-user@$HOST_IP   \
"sudo iptables --table raw --delete PREROUTING --protocol udp --source-port ${UDP_PORT} --destination-port ${UDP_PORT} --jump NOTRACK;sudo iptables --table raw --append PREROUTING --protocol udp --source-port ${UDP_PORT} --destination-port ${UDP_PORT} --jump NOTRACK"
