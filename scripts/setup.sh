#!/bin/sh

# vagrant-hostsupdater for host
# vagrant-hostmanager for guests

PLUGINS="vagrant-vbox-snapshot vagrant-hostsupdater vagrant-hostmanager vagrant-proxyconf"

for plugin in $PLUGINS; do

    echo "checking if vagrant plugin '${plugin}' is installed"
    
    found=$(vagrant plugin list | egrep "^${plugin} ")
    [ -z "${found}" ] && vagrant plugin install ${plugin}

done
