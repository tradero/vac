#!/bin/sh

#vms=$(vagrant status | grep virtualbox)
#echo "${vms}" | cut -d" " -f1 | xargs -I {} -n 1 -P $(echo "${vms}"|wc -l) vagrant provision {}

# it's crucial atm to keep VMs provisioning order since MASTER needs to be provisioned at the very end
# of the whole process - it requires /etc/hosts file set by vagrant with all IPs of all nodes
vagrant provision
