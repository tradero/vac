#!/bin/sh

if [ ! -f /usr/local/bin/python ]; then 
    rm /var/db/pkg/*; 
    pkg update; 
    pkg upgrade -y; 
    pkg install -y python; 
fi

echo 'PermitRootLogin yes' > /etc/ssh/sshd_config;
echo 'Subsystem	sftp	/usr/libexec/sftp-server' >> /etc/ssh/sshd_config;
/etc/rc.d/sshd restart;

echo 'Copying local SSH Key to VM for provisioning...'
mkdir -p /root/.ssh
echo $1 > /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
