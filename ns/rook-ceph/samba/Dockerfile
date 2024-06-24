FROM rockylinux:9.3

COPY copy/ceph.repo /etc/yum.repos.d/ceph.repo
RUN dnf install -y epel-release
RUN dnf install -y dumb-init supervisor ceph-common ceph-fuse samba tdb-tools

## nice to have
RUN dnf install -y procps-ng nano file which iputils iproute

COPY copy/smb.conf /etc/samba/smb.conf
COPY copy/ceph.conf /etc/ceph/ceph.conf
COPY copy/fuse.conf /etc/fuse.conf

RUN mkdir -p /mnt/media /mnt/transfer
RUN chmod 700 /mnt/media /mnt/transfer

COPY copy/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["bash", "-c", "/entrypoint.sh && exec dumb-init runuser -u samba /entrypoint.sh"]

