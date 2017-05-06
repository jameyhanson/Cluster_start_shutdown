#!/bin/bash

# Cluster host startup in a password environment

filename=./hosts.txt
password=my_password
user=ec2_user

# set hostname
while read p; do
    sshpass -p "$password" ssh -t $user@$p \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        "sudo hostnamectl set-hostname `cat ./fqdn.txt`"
done < $filename

# restart cloudera-scm-agent
while read p; do
    sshpass -p "$password" ssh -t $user@$p \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        "sudo service cloudera-scm-agent restart"
done < $filename
