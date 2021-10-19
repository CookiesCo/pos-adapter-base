
#
# Tooling: Sample App
#

ENABLE_NODE = no
ENABLE_JAVA = yes
ENABLE_GRCOV = yes
ENABLE_PYTHON = yes
ENABLE_GCLOUD = yes
ENABLE_DOCKER = yes
ENABLE_BAZEL = yes
ENABLE_SKAFFOLD = yes
ENABLE_K8S = no
ENABLE_HELM = no
ENABLE_MAVEN = no


# -- Tool Versions: Overrides --

BAZEL_VERSION ?= $(shell cat .bazelversion)
BAZELTOOLS_VERSION ?= $(LATEST_BAZELTOOLS_VERSION)
IBAZEL_VERSION ?= $(LATEST_IBAZEL_VERSION)
BAZELISK_VERSION ?= $(LATEST_BAZELISK_VERSION)
SKAFFOLD_VERSION ?= $(LATEST_SKAFFOLD_VERSION)
HELM_VERSION ?= $(LATEST_HELM_VERSION)

include tools/config/app.bzl
