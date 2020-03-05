#!/bin/bash

# To verify auth, we need to write a token into a file accessible at the webserver root.

POD_NAME=`oc get pods --selector=deploymentconfig=$OPENSHIFT_WEBSERVER_DC -o jsonpath='{.items[0].metadata.name}'`
oc exec $POD_NAME -it -- "sh" "-c" "mkdir -p /app/.well-known/acme-challenge && echo $CERTBOT_VALIDATION >> /app/.well-known/acme-challenge/$CERTBOT_TOKEN"
