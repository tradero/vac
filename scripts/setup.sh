#!/bin/sh

PLUGINS="vagrant-vbox-snapshot vagrant-hostsupdater vagrant-proxyconf"

for plugin in $PLUGINS; do

    echo "checking if vagrant plugin '${plugin}' is installed"
    
    found=$(vagrant plugin list | egrep "^${plugin} ")
    [ -z "${found}" ] && vagrant plugin install ${plugin}

done
