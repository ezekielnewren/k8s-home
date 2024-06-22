#!/bin/bash

# --cap-add SYS_ADMIN
docker run --name samba --device /dev/fuse --cap-add SYS_ADMIN -e SAMBA_PASSWORD=$SAMBA_PASSWORD --rm -it -v /tmp/$USER/keyring:/etc/ceph/keyring ceph_to_samba


