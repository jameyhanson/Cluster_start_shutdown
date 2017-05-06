#!/bin/bash

# Cluster host startup in a password environment

# set hostname
while read p; do
    sshpass -p "$password" ssh -t ec2-user@$p \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        "sudo hostnamectl set-hostname `cat ./fqdn.txt`"
done < $filename

# restart cloudera-scm-agent
while read p; do
    sshpass -p "$password" ssh -t ec2-user@$p \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        "sudo service cloudera-scm-agent restart"
done < $filename
