#!/bin/bash

connection=$1
file=$2

if [ "$connection" == "" ] || [ "$file" == "" ]; then
    echo "you must supply a connection string and file"
    exit 1
fi

live_cert=$(</dev/null openssl s_client -connect "$connection" -showcerts 2>/dev/null | awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/{print}' | openssl x509 -noout -sha256 -fingerprint)
disk_cert=$(cat /secret/mongodb.pem | openssl x509 -noout -sha256 -fingerprint)

if [ "$live_cert" == "$disk_cert" ]; then
    exit 0
else
    exit 1
fi

