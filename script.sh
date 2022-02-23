#!/bin/bash
CLUSTER_ADMIN_USER=$1
OCP_API=$2
PATH_TO_USERS_FILE=$3
TMP_FILE=.users.tmp
COUNT_REGEX='^[^#]'

echo "Admin user: $CLUSTER_ADMIN_USER"
echo "OCP: $OCP_API"

echo "--> OCP login"
oc login -u $CLUSTER_ADMIN_USER $OCP_API

echo "--> Retrieving existing users"
oc get secret htpasswd -n openshift-config -o json | jq -r '.data["htpasswd"]' | base64 -d > $TMP_FILE

echo "--> Recuperados $(grep -c $COUNT_REGEX $TMP_FILE)"

echo "--> Users to create: $(cat $PATH_TO_USERS_FILE | wc -l)"
cat $PATH_TO_USERS_FILE | while read line ;
do
    user=`echo $line | awk -F# '{print $1}'`
    pass=`echo $line | awk -F# '{print $2}'`
    # add user to htpasswd file
    htpasswd -nbm $user $pass  >> $TMP_FILE
done

echo "--> Users created: $(grep -c $COUNT_REGEX $TMP_FILE)"

echo "--> Creating OCP secret"
oc create secret generic htpasswd \
   --from-file=htpasswd=$TMP_FILE \
   --dry-run=client \
   -o yaml \
   -n openshift-config | oc replace -f -

echo "--> Deleting temporal data"
rm $TMP_FILE
