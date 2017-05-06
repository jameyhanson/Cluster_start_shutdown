#!/bin/bash

filename=./hosts.txt

# copy ./hosts_cluster file
while read p; do
   scp -i ~/.ssh/jph-aws.pem \
     -o StrictHostKeyChecking=no \
     -o UserKnownHostsFile=/dev/null \
     ./hosts_cluster ec2-user@$p:~/.
done < $filename

# append /etc/hosts with hosts_cluster 
while read p; do
    ssh -t -i ~/.ssh/jph-aws.pem ec2-user@$p \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        "sudo  bash -c 'cat ./hosts_cluster >> /etc/hosts'"
done < $filename

# change /sys/selinux/config
while read p; do
    ssh -t -i ~/.ssh/jph-aws.pem ec2-user@$p \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        "sudo sed -i 's/=enforcing/=disabled/g' /etc/selinux/config"
done < $filename

# create fqdn.txt
while read p; do
    ssh -t -i ~/.ssh/jph-aws.pem ec2-user@$p \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        "echo $p > ./fqdn.txt"
done < $filename

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
