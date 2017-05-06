#!/bin/bash

 sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
 sudo yum -y install sshpass



filename=./hosts.txt
password=my_password

# copy ./hosts_cluster file
while read p; do
   sshpass -p "$password" scp \
     -o StrictHostKeyChecking=no \
     -o UserKnownHostsFile=/dev/null \
     ./hosts_cluster ec2-user@$p:~/.
done < $filename

# append /etc/hosts with hosts_cluster 
while read p; do
    sshpass -p "$password" ssh -t ec2-user@$p \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        "sudo  bash -c 'cat ./hosts_cluster >> /etc/hosts'"
done < $filename

# change /sys/selinux/config
while read p; do
    sshpass -p "$password" ssh -t ec2-user@$p \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        "sudo sed -i 's/=enforcing/=disabled/g' /etc/selinux/config"
done < $filename

# create fqdn.txt
while read p; do
    sshpass -p "$password" ssh -t ec2-user@$p \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        "echo $p > ./fqdn.txt"
done < $filename

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
