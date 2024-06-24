#!/bin/bash

docker build --network host -t ceph_to_samba .
docker tag ceph_to_samba docker.ezekielnewren.com/ceph_to_samba:latest
echo docker push docker.ezekielnewren.com/ceph_to_samba:latest

