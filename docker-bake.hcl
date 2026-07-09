// docker-bake.hcl for metadata-editor-fastapi (data-processing API - Python/FastAPI).
// REGISTRY_PREFIX + IMAGE_TAG are injected by manaakiwhenua/github-workflows docker-build.yml.
variable "REGISTRY_PREFIX" {}
variable "IMAGE_TAG" {}
variable "GIT_ORIGIN"   { default = "" }
variable "GIT_REVISION" { default = "" }

group "default" { targets = ["metadata-editor-fastapi"] }

target "_common" {
  platforms = ["linux/amd64"]
  labels = {
    "org.opencontainers.image.source"   = "${GIT_ORIGIN}"
    "org.opencontainers.image.revision" = "${GIT_REVISION}"
    "org.opencontainers.image.vendor"   = "Manaaki Whenua - Landcare Research"
    "org.opencontainers.image.title"    = "Metadata Editor FastAPI"
  }
}

target "metadata-editor-fastapi" {
  inherits   = ["_common"]
  context    = "."
  dockerfile = "Dockerfile"
  tags       = ["${REGISTRY_PREFIX}:${IMAGE_TAG}"]
}
