# syntax=docker/dockerfile:1
# Args to centralise versions.
ARG NGINX_VERSION=1.30.6
ARG NGINX_DIGEST=sha256:a7675fcee220f59b4a99f7098c06a0d5d999c2c0ee37c0211efb780536e5cb20
ARG WAF_AGENT_VERSION=4.83.1
FROM nginx:${NGINX_VERSION}-trixie@${NGINX_DIGEST}
# Arg scope: re-declare bare args inside the build stage.
ARG NGINX_VERSION
ARG NGINX_DIGEST
ARG WAF_AGENT_VERSION
ARG DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Image metadata
LABEL org.opencontainers.image.title="nginx-sigsci" \
  org.opencontainers.image.version="${NGINX_VERSION}" \
  org.opencontainers.image.description="Nginx with Signal Sciences (Fastly) WAF agent" \
  org.opencontainers.image.vendor="DBCA" \
  org.opencontainers.image.authors="asi@dbca.wa.gov.au" \
  org.opencontainers.image.source="https://github.com/dbca-wa/nginx-sigsci" \
  org.opencontainers.image.base.name="docker.io/library/nginx:${NGINX_VERSION}-trixie" \
  org.opencontainers.image.base.digest="${NGINX_DIGEST}" \
  com.fastly.sigsci-agent.version="${WAF_AGENT_VERSION}"

# Install the Next-Gen WAF agent and the Nginx dynamic module for the version of Nginx used.
# Reference: https://www.fastly.com/documentation/guides/next-gen-waf/agent-management/installing-the-agent/#debian
# Reference: https://www.fastly.com/documentation/guides/next-gen-waf/deployment-types/module-agent-deployment/nginx-module/installing-the-nginx-dynamic-module/#installing-the-nginx-dynamic-module-for-nginx-open-source
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  <<EOF
set -euxo pipefail
. /etc/os-release
curl --retry 3 --retry-all-errors -fsSL \
  https://apt.security.fastly.com/release/fastly.apt.asc \
  -o /usr/share/keyrings/sigsci.asc
echo "deb [signed-by=/usr/share/keyrings/sigsci.asc] https://apt.security.fastly.com/release/debian/ ${VERSION_CODENAME} main" \
  > /etc/apt/sources.list.d/sigsci-release.list
apt-get update -o Acquire::Retries=3
apt-get install -y --no-install-recommends \
  sigsci-agent=${WAF_AGENT_VERSION} \
  "nginx-module-fastly-nxs=${NGINX_VERSION}*"
EOF
