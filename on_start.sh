#!/bin/bash

sudo hostnamectl set-hostname `cat ./fqdn.txt`

sudo service cloudera-scm-agent restart
