#!/bin/sh

vms=$(vagrant status | grep virtualbox | egrep -v controller)

echo "${vms}" | cut -d" " -f1 | xargs -I {} -n 1 -P $(echo "${vms}"|wc -l) vagrant destroy -f {}
