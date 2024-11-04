#!/bin/bash

smbclient -L localhost -p 4445 -U samba%$SAMBA_PASSWORD -m SMB3 -W WORKGROUP &>/dev/null
