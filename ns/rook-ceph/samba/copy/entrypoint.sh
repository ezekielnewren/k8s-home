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
    chown -R samba:samba /var/log/samba /var/lib/samba /run /mnt/media /mnt/transfer /etc/ceph/keyring
    chmod 600 /etc/ceph/keyring
    
    # bash
else
    # common="-f --name client.samba -m pm1:6789,pm2:6789,pm3:6789 --keyring /etc/ceph/keyring"
    common="--name client.samba"
    ceph-fuse $common --client_fs=hddfs --client-mountpoint=/media /mnt/media
    ceph-fuse $common --client_fs=ssdfs --client-mountpoint=/transfer /mnt/transfer
    :
    smbd --foreground --debug-stdout --debuglevel 3 --no-process-group
fi

