# OCP User configuration
> :warning: **Be very careful** This repository is used to create a new user provider **only for testing**.

The motivation is to create a project for each user and became itself admin.

# Prerequisites
* OC cli
* htpasswd utility

# Configuration
## User lists
A list of users, separating each user in a line and username and password by '#'.

```bash
❯ cat users.list 
dborrego@redhat.com#change1234
``` 

# Script
1. Login as admin 
2. Reads user list
3. Retrieves existing htpasswd file
4. Append new users to htpasswd
5. Apply the temporal file
6. Creates a new OAuth provider

## Example
```bash
./script.sh admin https://api.my-cluster.com:6443 users.list     
Admin user: admin
OCP: https://api.my-cluster.com:6443
--> OCP login
Logged into "https://api.my-cluster.com:6443" as "admin" using existing credentials.

You have access to 65 projects, the list has been suppressed. You can list all projects with 'oc projects'

Using project "default".
--> Retrieving existing users
--> Recuperados 2
--> Users to create: 1
--> Users created: 3
--> Creating OCP secret
secret/htpasswd replaced
--> Deleting temporal data
```

# References
* https://docs.openshift.com/container-platform/4.8/authentication/identity_providers/configuring-htpasswd-identity-provider.html