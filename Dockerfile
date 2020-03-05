FROM debian:latest

ARG OPENSHIFT_CLI_DOWNLOAD=https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
ARG OPENSHIFT_CLI_FOLDER=openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit

ENV OPENSHIFT_URL=
ENV OPENSHIFT_TOKEN=
ENV OPENSHIFT_PROJECT=
ENV OPENSHIFT_ROUTE_NAME=
ENV OPENSHIFT_WEBSERVER_DC=
ENV CERTBOT_DOMAIN_TO_RENEW=
ENV CERTBOT_USE_STAGING=

WORKDIR /tmp

RUN apt-get update \
  && apt-get install -yqq --no-install-recommends certbot curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/list/*

RUN curl -L --output /tmp/oc.tar.gz $OPENSHIFT_CLI_DOWNLOAD \
  && tar xvf /tmp/oc.tar.gz \
  && mv /tmp/$OPENSHIFT_CLI_FOLDER/oc /usr/bin \
  && chmod +x /usr/bin/oc \
  && rm -R /tmp/oc.tar.gz $OPENSHIFT_CLI_FOLDER

COPY scripts /opt
RUN chmod +x /opt/*

ENTRYPOINT /opt/renew.sh
