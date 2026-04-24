# Nginx with Signal Sciences (Fastly) Next-Gen WAF agent

This project comprises a Dockerfile consisting of Nginx with the `nginx-module-fastly-nxs` module installed,
plus the Signal Sciences Next-Gen WAF agent.
It is intended to be run in the DBCA environment with additional configuration, such as `/var/nginx-etc/sigsci/agent.conf`.

References:

- <https://docs.fastly.com/en/ngwaf/installing-the-agent-on-debian>
- <https://docs.fastly.com/en/ngwaf/installing-the-nginx-dynamic-module>

Build an image for testing:

```bash
docker image build --tag ghcr.io/dbca-wa/nginx-sigsci .
```

Start an interactive local session:

```bash
docker container run -it --rm --entrypoint /bin/sh ghcr.io/dbca-wa/nginx-sigsci
sigsci-agent --help
```

## Upgrading

- Edit `Dockerfile` (typically the lines `FROM nginx:1.*` and the `RUN apt-get -y install nginx-module-fastly-nxs=<VERSION>`).
- Test build the image: `docker image build --tag ghcr.io/dbca-wa/nginx-sigsci .`
