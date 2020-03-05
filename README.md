# Certbot OpenShift

Easily generate Let's Encrypt certificates thanks to certbot, but on OpenShift.

- Starts the certificates generation
- Connects to an OpenShift pod to generate the file for the HTTP auth
- Finishes the generation
- Cleanup the file
- Patch the route with the certificates

## Usage

### Build

```
docker build --build-arg http_proxy --build-arg https_proxy -t certbot-openshift .
```

### Run

```
docker run -it --rm \
  -e OPENSHIFT_URL=https://master.myopenshiftcluster.io \
  -e OPENSHIFT_TOKEN=<user-token-or-service-account> \
  -e OPENSHIFT_PROJECT=<openshift-namespace> \
  -e CERTBOT_DOMAIN_TO_RENEW=mydomain.example.com \
  -e https_proxy \
  -e http_proxy \
  -e OPENSHIFT_ROUTE_NAME=my-exposed-route \
  -e OPENSHIFT_WEBSERVER_DC=name-of-the-dc-where-to-put-the-auth-file \
  -e CERTBOT_USE_STAGING=false
  certbot-openshift
```

aaaand that's it.
