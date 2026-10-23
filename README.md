# Nginx with Signal Sciences (Fastly) Next-Gen WAF agent

This project comprises a Dockerfile consisting of Nginx with the `nginx-module-fastly-nxs` module installed,
plus the Fastly (formerly Signal Sciences) Next-Gen WAF agent.
It is intended to be run in the DBCA environment with additional configuration, such as `/var/nginx-etc/sigsci/agent.conf`.
The official Nginx Docker image runs Debian as the base OS (`root` user). Updates to the Dockerfile should reflect this.

References:

- <https://www.fastly.com/documentation/guides/next-gen-waf/agent-management/installing-the-agent/>
- <https://www.fastly.com/documentation/guides/next-gen-waf/deployment-types/module-agent-deployment/nginx-module/installing-the-nginx-dynamic-module/>

Build an image for testing:

```bash
docker image build --tag ghcr.io/dbca-wa/nginx-sigsci .
```

Start an interactive local session:

```bash
docker container run -it --rm --entrypoint /bin/sh ghcr.io/dbca-wa/nginx-sigsci
sigsci-agent --version
```

## Upgrading

- Edit `Dockerfile` (typically the just the `ARGS` values).
- Test build the image: `docker image build --tag ghcr.io/dbca-wa/nginx-sigsci .`
