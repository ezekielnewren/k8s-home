#!/bin/bash

if [ "$SAMBA_UID" == "" ]; then
    SAMBA_UID=1000
fi

if [ "$SAMBA_GID" == "" ]; then
    SAMBA_GID=1000
fi

if [ $(id -u) -eq 0 ]; then
    groupadd -g $SAMBA_GID samba
    useradd -u $SAMBA_UID -g $SAMBA_GID -s /bin/bash samba
    usermod -aG users samba
    echo -e "$SAMBA_PASSWORD\n$SAMBA_PASSWORD" | smbpasswd -a samba
    echo -e "[client.samba]\n    key = $SAMBA_PASSWORD" > /etc/ceph/keyring

    mkdir -p /var/log/samba /var/lib/samba /run/samba
    chown -R samba:samba /var/log/samba /var/lib/samba /run /mnt/media /mnt/transfer /etc/ceph/keyring /etc/supervisord.conf
    chmod 600 /etc/ceph/keyring
fi

