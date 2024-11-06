#!/bin/bash

date > /tmp/alive.txt
smbclient //localhost/media -U samba%$SAMBA_PASSWORD -p 4445 -W WORKGROUP -c "put /tmp/alive.txt alive.txt" || exit $?
smbclient //localhost/transfer -U samba%$SAMBA_PASSWORD -p 4445 -W WORKGROUP -c "put /tmp/alive.txt alive.txt" || exit $?

