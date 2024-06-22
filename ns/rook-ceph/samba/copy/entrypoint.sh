#!/bin/bash

alias ll='ls -alF'

# mount -t ceph pm1,pm2,pm3:6789:/transfer /mnt/transfer -o name=samba,fs=ssdfs
# mount -t ceph pm1,pm2,pm3:6789:/media /mnt/media -o name=samba,fs=hddfs

# ceph-fuse --name client.samba -m pm1:6789,pm2:6789,pm3:6789 --keyring /etc/ceph/keyring --client_fs=hddfs --client-mountpoint=/media /mnt/media
# ceph-fuse --name client.samba -m pm1:6789,pm2:6789,pm3:6789 --keyring /etc/ceph/keyring --client_fs=ssdfs --client-mountpoint=/transfer /mnt/transfer

common="--name client.samba -m pm1:6789,pm2:6789,pm3:6789 --keyring /etc/ceph/keyring"

ceph-fuse $common --client_fs=hddfs --client-mountpoint=/media /mnt/media
ceph-fuse $common --client_fs=ssdfs --client-mountpoint=/transfer /mnt/transfer

USERID=1000
useradd -u $USERID -s /bin/bash samba
echo -e "$SAMBA_PASSWORD\n$SAMBA_PASSWORD" | smbpasswd -a samba

mkdir -p /var/log/samba
chown -R $USERID:$USERID /var/log/samba

mkdir -p /var/lib/samba
chown -R $USERID:$USERID /var/lib/samba

mkdir -p /run/samba
chown -R $USERID:$USERID /run  ## the entire run directory needs to be read-writable for /run/smbd.pid


exec dumb-init bash
# exec dumb-init su - samba -c bash -c "smbd --foreground --debug-stdout --debuglevel 3"
# exec dumb-init su - samba -c bash -c "smbd --interactive --debug-stdout --debuglevel 3"

