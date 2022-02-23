#!/bin/bash
CLUSTER_ADMIN_USER=$1
OCP_API=$2
PATH_TO_USERS_FILE=$3
TMP_FILE=.users.tmp

echo "Admin user: $CLUSTER_ADMIN_USER"
echo "OCP: $OCP_API"

echo "--> OCP login"
oc login -u $CLUSTER_ADMIN_USER $OCP_API

echo "--> Users to create: $(cat $PATH_TO_USERS_FILE | wc -l)"
cat $PATH_TO_USERS_FILE | while read line ;
do
    user=`echo $line | awk -F# '{print $1}'`
    pass=`echo $line | awk -F# '{print $2}'`
    # add user to htpasswd file
    htpasswd -nbm $user $pass  >> $TMP_FILE
done

echo "--> Users created: $(grep -c '^$' $TMP_FILE)"

echo "--> Creating OCP secret"
oc create secret generic htpass-secret --from-file=htpasswd=$TMP_FILE -n openshift-config

echo "--> Deleting temporal data"
rm $TMP_FILE


