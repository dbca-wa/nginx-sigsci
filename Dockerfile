# syntax=docker/dockerfile:1
# Args to centralise versions.
ARG NGINX_VERSION=1.30.6
ARG WAF_AGENT_VERSION=4.83.1
FROM nginx:${NGINX_VERSION}
# Arg scope: re-declare bare args inside the build stage.
ARG NGINX_VERSION
ARG WAF_AGENT_VERSION

# Image metadata
LABEL org.opencontainers.image.title="nginx-sigsci" \
  org.opencontainers.image.version="${NGINX_VERSION}" \
  org.opencontainers.image.description="Nginx with Signal Sciences (Fastly) WAF agent" \
  org.opencontainers.image.vendor="DBCA" \
  org.opencontainers.image.authors="asi@dbca.wa.gov.au" \
  org.opencontainers.image.source="https://github.com/dbca-wa/nginx-sigsci"

# Install the Next-Gen WAF agent and the Nginx dynamic module for the version of Nginx used.
# Add the Signal Sciences package repository.
# Reference: https://www.fastly.com/documentation/guides/next-gen-waf/agent-management/installing-the-agent/#debian
# Install the agent package and the Nginx dynamic module for the stable (even-numbered) release of Nginx.
# Reference: https://www.fastly.com/documentation/guides/next-gen-waf/deployment-types/module-agent-deployment/nginx-module/installing-the-nginx-dynamic-module/#installing-the-nginx-dynamic-module-for-nginx-open-source

RUN <<EOF
set -euxo pipefail
apt-get update
apt-get install -y --no-install-recommends \
  wget \
  gnupg \
  lsb-release
wget -qO - https://apt.security.fastly.com/release/fastly.apt.asc | gpg --dearmor -o /usr/share/keyrings/sigsci.gpg
echo "deb [signed-by=/usr/share/keyrings/sigsci.gpg] https://apt.security.fastly.com/release/debian/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/sigsci-release.list
apt-get update
apt-get -y install --no-install-recommends sigsci-agent=${WAF_AGENT_VERSION} "nginx-module-fastly-nxs=${NGINX_VERSION}*"
rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*
apt-get purge -y wget gnupg lsb-release
EOF
