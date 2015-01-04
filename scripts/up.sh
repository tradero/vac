#!/bin/sh

vms=$(vagrant status | grep virtualbox)

echo "${vms}" | cut -d" " -f1 | xargs -I {} -n 1 -P $(echo "${vms}"|wc -l) vagrant up --no-provision {}
