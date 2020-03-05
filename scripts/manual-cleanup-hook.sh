#!/bin/bash

# Remove the file that was used for auth.

POD_NAME=`oc get pods --selector=deploymentconfig=$OPENSHIFT_WEBSERVER_DC -o jsonpath='{.items[0].metadata.name}'`
oc exec $POD_NAME -it -- "sh" "-c" "rm /app/.well-known/acme-challenge/$CERTBOT_TOKEN"
