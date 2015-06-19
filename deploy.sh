#!/bin/bash -e

cd $(dirname $0)

. utils

new_env MYSQL_ROOT_PASSWORD $(random)
new_env MYSQL_DATABASE monster
new_env MYSQL_USER monster
new_env MYSQL_PASSWORD $(random)

. ../../environment

osc create -f - <<EOF
kind: List
apiVersion: v1beta3
items:
- kind: Service
  apiVersion: v1beta3
  metadata:
    name: db
    labels:
      service: db
      function: backend
  spec:
    ports:
    - port: 3306

- kind: Endpoints
  apiVersion: v1beta3
  metadata:
    name: db
    labels:
      service: db
      function: backend
  subsets:
  - addresses:
    - IP: $IAAS_MYSQL_IP
    ports:
    - port: $IAAS_MYSQL_PORT
EOF
