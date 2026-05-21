# syntax=docker/dockerfile:1
FROM nginx:1.31.0

# Image metadata
LABEL org.opencontainers.image.title="nginx-sigsci" \
  org.opencontainers.image.tags="nginx-sigsci" \
  org.opencontainers.image.description="Nginx with Signal Sciences (Fastly) WAF agent" \
  org.opencontainers.image.vendor="DBCA" \
  org.opencontainers.image.authors="asi@dbca.wa.gov.au" \
  org.opencontainers.image.source="https://github.com/dbca-wa/nginx-sigsci"

# Install the Next-Gen WAF agent and the Nginx dynamic module for the version of Nginx used.
#
# Add the Signal Sciences package repository.
# https://docs.fastly.com/en/ngwaf/installing-the-agent-on-debian#debian-11---bullseye
RUN apt-get update && apt-get install -y --no-install-recommends \
  apt-transport-https \
  wget \
  gnupg \
  lsb-release \
  && wget -qO - https://apt.security.fastly.com/release/gpgkey | gpg --dearmor -o /usr/share/keyrings/sigsci.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/sigsci.gpg] https://apt.security.fastly.com/release/debian/ `lsb_release -cs` main" | tee /etc/apt/sources.list.d/sigsci-release.list \
  && apt-get update

# Install the agent package and the Nginx module for the stable release of Nginx.
# https://docs.fastly.com/en/ngwaf/installing-the-nginx-dynamic-module#installing-the-nginx-dynamic-module-for-nginx-open-source
RUN apt-get -y install sigsci-agent nginx-module-fastly-nxs=1.30.1\* \
  && rm -rf /var/lib/apt/lists
