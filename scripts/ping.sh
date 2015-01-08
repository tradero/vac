#!/bin/sh

for vm in $(cat /etc/hosts | grep vac | awk '{ print $1 }'); do

    ping -c 1 -t 2 $vm;

done
