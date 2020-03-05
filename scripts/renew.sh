#!/bin/bash
set -e

oc login $OPENSHIFT_URL --token=$OPENSHIFT_TOKEN
oc project $OPENSHIFT_PROJECT

certbot certonly \
  -q \
  --register-unsafely-without-email \
  --manual-public-ip-logging-ok \
  --agree-tos \
  --manual \
  -d $CERTBOT_DOMAIN_TO_RENEW \
  --manual-auth-hook /opt/manual-auth-hook.sh \
  --manual-cleanup-hook /opt/manual-cleanup-hook.sh \
  --cert-name generated \
  $([ "$CERTBOT_USE_STAGING" == "true" ] && echo "--staging" || echo "")

# Generate a JSON with all keys in it.
echo "{\"spec\": {\"tls\": {\"key\": \"`cat /etc/letsencrypt/live/generated/privkey.pem`\", \"certificate\": \"`cat /etc/letsencrypt/live/generated/cert.pem`\"}}}" >> /tmp/patch-tmp.json
# Replace the line breaks with \n.
awk -v ORS='\\n' '1' /tmp/patch-tmp.json >> /tmp/patch-tmp2.json
# Remove the two last characters (which are a \n).
truncate -s-2 /tmp/patch-tmp2.json
# And patch the route.
oc patch route $OPENSHIFT_ROUTE_NAME -p "$(cat /tmp/patch-tmp2.json)"
