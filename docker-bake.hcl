# docker-bake.hcl — reproducible, multi-arch build config for nginx-sigsci.
# Build (local single-platform): docker buildx bake
# Build + push (multi-arch):      docker buildx bake --push
# Override at runtime:            TAG=v2 REGISTRY=ghcr.io/me docker buildx bake
# Override a Dockerfile ARG:      docker buildx bake --set app.args.NGINX_VERSION=1.31.0

variable "TAG" {
  default = "latest"
}

variable "REGISTRY" {
  default = "ghcr.io/dbca-wa"
}

variable "PLATFORMS" {
  default = "linux/amd64,linux/arm64"
}

group "default" {
  targets = ["app"]
}

target "app" {
  context    = "."
  dockerfile = "Dockerfile"
  tags       = ["${REGISTRY}/nginx-sigsci:${TAG}"]
  platforms  = split(",", PLATFORMS)
}
