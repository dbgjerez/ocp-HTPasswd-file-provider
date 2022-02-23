#!/bin/bash
CLUSTER_ADMIN_USER=$1
OCP_API=$2
PATH_TO_USERS_FILE=$3
TMP_FILE=.users.tmp

echo "Admin user: $CLUSTER_ADMIN_USER"
echo "OCP: $OCP_API"

oc login -u $CLUSTER_ADMIN_USER $OCP_API
