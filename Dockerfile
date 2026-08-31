# syntax=docker/dockerfile:1
# Args to centralise versions.
ARG NGINX_VERSION=1.30.4
ARG NGINX_DIGEST=sha256:09cc2702709e6388d979d8030e3ab4eb1ceb699b2dced26d7543e872a822e823
ARG SIGSCI_AGENT_VERSION=4.80.1
FROM nginx:${NGINX_VERSION}@${NGINX_DIGEST}
# Arg scope: re-declare bare args inside the build stage.
ARG NGINX_VERSION
ARG SIGSCI_AGENT_VERSION

# Image metadata
LABEL org.opencontainers.image.title="nginx-sigsci" \
  org.opencontainers.image.version="${NGINX_VERSION}" \
  org.opencontainers.image.description="Nginx with Signal Sciences (Fastly) WAF agent" \
  org.opencontainers.image.vendor="DBCA" \
  org.opencontainers.image.authors="asi@dbca.wa.gov.au" \
  org.opencontainers.image.source="https://github.com/dbca-wa/nginx-sigsci"

# Install the Next-Gen WAF agent and the Nginx dynamic module for the version of Nginx used.
# Add the Signal Sciences package repository.
# Reference: https://docs.fastly.com/en/ngwaf/installing-the-agent-on-debian#debian-11---bullseye
# Install the agent package and the Nginx module for the stable release of Nginx.
# Reference: https://docs.fastly.com/en/ngwaf/installing-the-nginx-dynamic-module#installing-the-nginx-dynamic-module-for-nginx-open-source

RUN <<EOF
set -euxo pipefail
apt-get update
apt-get install -y --no-install-recommends \
  wget gnupg lsb-release
wget -qO - https://apt.security.fastly.com/release/gpgkey | gpg --dearmor -o /usr/share/keyrings/sigsci.gpg
echo "deb [signed-by=/usr/share/keyrings/sigsci.gpg] https://apt.security.fastly.com/release/debian/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/sigsci-release.list
apt-get update
apt-get -y install --no-install-recommends sigsci-agent=${SIGSCI_AGENT_VERSION} "nginx-module-fastly-nxs=${NGINX_VERSION}*"
rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*
apt-get purge -y wget gnupg lsb-release
EOF
