# Cluster_start_shutdown
Scripts to simplify CDH cluster startup and shutdown when running on PaaS  

These scripts are intended to simply preparing and starting CDH clusters that are hosted on AWS or other PaaS.  

NOTE:  Cloudera Director automates preparing hosts (plus many, many other tasks) but it does not help with  
restarting hosted clusters.

## setup
The scripts are intended to be run a CentOS/RHEL host, typically the CM server.  The scripts must be run by a user with  
no-password sudo.

The following three files are required in `~/`:
* `hosts.txt`      The fqdn of every other host in the cluster.  Analagous to a pssh hosts file.  
* `hosts_cluster`  These are `/etc/hosts` entries for the cluster that will be appended to each hosts `/etc/hosts`  
* `run_cmd_[pem|paswd].sh` the execution script, depending on if you are using a password or *.pem file
