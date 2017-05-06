#!/bin/bash

# Prep cluster hosts for restart in pem environment

# set hostname
while read p; do
    ssh -t -i ~/.ssh/jph-aws.pem ec2-user@$p \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        "sudo hostnamectl set-hostname `cat ./fqdn.txt`"
done < $filename

# restart cloudera-scm-agent
while read p; do
    ssh -t -i ~/.ssh/jph-aws.pem ec2-user@$p \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        "sudo service cloudera-scm-agent restart"
done < $filename
