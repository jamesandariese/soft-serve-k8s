#!/bin/bash

set -e

cd "$(dirname "$0")"

if [ -e admin_ed25519 ];then
    1>&2 echo "admin_ed25519 already exists"
    exit 1
fi

if [ -e admin_ed25519.pub ];then
    1>&2 echo "admin_ed25519.pub already exists"
    exit 1
fi
if [ -e admin.yaml ];then
    1>&2 echo "admin.yaml already exists"
    exit 1
fi

NAMESPACE="$(kubectl create -k . --dry-run=client -o json | jq -r 'select(.kind == "Namespace").metadata.name')"

ssh-keygen -f admin_ed25519 -t ed25519 -N ""
kubectl create secret generic -n "$NAMESPACE" softserve-admin --from-file=id_ed25519=admin_ed25519 --from-file=id_ed25519.pub=admin_ed25519.pub
rm -v admin_ed25519 admin_ed25519.pub
rm admin.yaml

./extract-admin-ssh
