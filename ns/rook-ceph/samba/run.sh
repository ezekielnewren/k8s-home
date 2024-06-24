#!/bin/bash

# --cap-add SYS_ADMIN
docker run --name samba --device /dev/fuse --cap-add SYS_ADMIN -e SAMBA_UID -e SAMBA_GID -e SAMBA_PASSWORD -p 445:445 --rm -it ceph_to_samba


