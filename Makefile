
#
# Makefile: Sample App
#

MAKEFLAGS += --no-print-directory

# -- Configuration --

VERSION = $(shell cat ./.version)
BASE = v1a

APP ?= //:app
IMAGE ?= //app:image
TESTS ?= //tests/...
TARGETS ?= //:backend $(IMAGE)
K8S ?= //infra/k8s
NAMESPACE ?= sandbox

PULL ?= no
PUSH ?= no
CI ?= no
SEAL ?= yes
QUIET ?= no
VERBOSE ?= no
DEBUG ?= no
COLORS ?= yes
COVERAGE ?= yes
PROJECT_NAME ?= sample-app
DOCKER_REGISTRY ?= us.gcr.io/cookies-co
DOCKER_REPOSITORY ?= dev/sample-app/node
GITSTATE ?= $(shell git describe --tags --always)
IMAGE_VERSION ?= v$(shell date -u '+%Y%m%d')-$(GITSTATE)

## Namespace promotions config.
FROM ?=
TO ?=


# -- State --

CONFIG ?=

GITHOOKS ?= $(patsubst .hooks/%, .git/hooks/%, $(wildcard .hooks/*))
BAZEL_ARGS ?= $(CONFIG)

include tools/Setup.mak


# -- Targets --

all: setup build test  ## Build and test the sample application.

setup env: $(ENV)  ## Setup local development tooling.
	$(info Environment ready.)

resetup:  ## Clean the dev environment only, and re-initialize it. Automatically run after dep updates.
	$(info Re-initializing dev environment...)
	$(RULE)$(RM) -fr $(POSIX_FLAGS) $(ENV)
	$(RULE)$(MAKE) setup

ensure-deps:  ## Force-run dependency install routines (ideal for use in CI).
	$(info Ensuring dependencies...)
ifeq ($(ENABLE_NODE),yes)
	$(RULE)$(YARN)
endif
ifeq ($(ENABLE_PYTHON),yes)
	$(RULE)$(PYTHON) -m pip install --upgrade -r tools/requirements.txt
endif
ifeq ($(ENABLE_MAVEN),yes)
	$(RULE)$(MAKE) update-java
endif

status: show-features show-versions show-image  ## Display status of the local dev environment.
ifeq ($(QUIET),no)
	$(info -- Current status:)
endif
	$(RULE)$(BASH) tools/workspace.sh $(VERSION) $(BASE);


ifeq ($(PUSH),yes)
ci: resetup build push
else
ci: resetup build test
endif
	@echo "Setting metadata..."
	buildkite-agent meta-data set "app-version" "$(VERSION)"
	buildkite-agent meta-data set "image-version" "$(IMAGE_VERSION)"
	buildkite-agent meta-data set "image-target" "$(DOCKER_REGISTRY)/$(DOCKER_REPOSITORY):$(IMAGE_VERSION)"

build:  ## Build the sample application via Bazel.
	$(info Building app...)
	$(RULE)$(BAZELISK) $(BAZELISK_ARGS) build $(BAZEL_ARGS) $(TARGETS)

image:   ## Build the app image via Bazel.
	$(info Building application image...)
	$(RULE)$(BAZELISK) $(BAZELISK_ARGS) build $(BAZEL_ARGS) $(IMAGE)

push:  ## Build and push the latest app image.
	$(info Pushing application image...)
	$(RULE)$(BAZELISK) $(BAZELISK_ARGS) run $(BAZEL_ARGS) $(IMAGE).push

test:  ## Run the testsuite for the sample application via Bazel.
	$(info Running tests...)
	$(RULE)$(BAZELISK) $(BAZELISK_ARGS) $(TEST_CMD) $(BAZEL_ARGS) $(TESTS)

test:
	@echo "Tests currently stubbed."

run:  ## Build and run the sample application via Bazel.
	$(info Building app...)
	$(RULE)$(BAZELISK) $(BAZELISK_ARGS) run $(BAZEL_ARGS) $(APP)

sources: $(ENV)  ## Re-render templated sources, like the README.
	$(info Re-rendering sources...)
	$(RULE)$(PYTHON) tools/sources.py
	@echo "Sources ready."

k8s:  ## Render all Kubernetes configurations for a single env, depositing them in `.k8s`.
	$(RULE)$(MKDIR) -p .k8s/base .k8s/policy/{sandbox,staging,prod} .k8s/overlays
	@echo "Inflating Kustomize overlays..."
	$(RULE)$(CP) -fr $(POSIX_FLAGS) infra/overlays/$(NAMESPACE) .k8s/overlays/
	@echo "Adding Kustomize config..."
	$(RULE)$(CP) -f $(POSIX_FLAGS) infra/kustomization.yaml .k8s/base/
	@echo "Rendering application config..."
	$(RULE)$(BAZELISK) $(BAZELISK_ARGS) run $(BAZEL_ARGS) $(K8S) > .k8s/base/rendered.k8s.yaml
	@echo "Cleaning current policy..."
	$(RULE)$(RM) -fr .k8s/policy/$(NAMESPACE)
	$(RULE)$(MKDIR) .k8s/policy/$(NAMESPACE)
	@echo "Building environment '$(NAMESPACE)'..."
	$(RULE)$(KUSTOMIZE) build .k8s/overlays/$(NAMESPACE) --output .k8s/policy/$(NAMESPACE)
	$(RULE)$(RM) -fr .k8s/base .k8s/overlays
	@echo "Environment '$(NAMESPACE)' ready."
ifeq ($(SEAL),yes)
	$(RULE)$(MAKE) k8s-seal NAMESPACE=$(NAMESPACE)
endif

k8s-seal:  ## Seal Kubernetes configs for a given namespace. Caution: this amends the previous Git commit with rendered manifests.
	@echo "Sealing K8S configs (env '$(NAMESPACE)')..."
	$(RULE)if ! $(GIT) diff-index --quiet HEAD --; then \
		$(GIT) add .k8s/policy/$(NAMESPACE) \
		&& $(GIT) commit --amend -s -S \
			--trailer "K8S-Update: $(NAMESPACE)-$(GITSTATE)" \
			--trailer "Image-Tag: $(DOCKER_REGISTRY)/$(DOCKER_REPOSITORY):$(IMAGE_VERSION)" \
		&& echo "Manifests re-sealed."; \
	else \
		echo "No change detected to K8S manifests."; fi

k8s-all:  ## Render all configs for all Kubernetes environments.
	$(info Rendering all manifests...)
	$(RULE)$(MAKE) k8s NAMESPACE=sandbox
	$(RULE)$(MAKE) k8s NAMESPACE=staging
	$(RULE)$(MAKE) k8s NAMESPACE=prod

deploy:  ## Re-render Kubernetes configurations to prep a deploy.
	$(info Rendering K8S manifests...)
	$(RULE)$(MAKE) push k8s SEAL=yes NAMESPACE=$(NAMESPACE)

promote:  ## Promote changes to a new namespace.
ifneq ($(FROM),)
	$(info Promoting '$(FROM)' to '$(TO)'...)
	$(RULE)$(MAKE) k8s SEAL=yes NAMESPACE=$(TO)
else
	$(error Please specify a FROM namespace and TO namespace)
endif

clean:  ## Clean ephemeral build targets. Always safe to run.
	$(info Cleaning...)
ifeq ($(ENABLE_BAZEL),yes)
	$(RULE)$(BAZELISK) clean
endif

distclean: clean  ## Clean any development state. Wipes `.dev`.
	$(info Cleaning dev environment...)
	$(RULE)$(RM) -fr $(POSIX_FLAGS) $(ENV)
	$(RULE)$(RM) -fr $(POSIX_FLAGS) $(NODE_MODULES)

expunge: distclean  ## Perform a distclean and expunge via Bazel.
	$(info Expunging...)
ifeq ($(ENABLE_BAZEL),yes)
	$(RULE)$(BAZELISK) clean --expunge
endif

reset: expunge  ## DANGEROUS: Reset any git state.
	$(info Resetting...)
	$(RULE)$(GIT) reset --hard

forceclean: reset  ## DANGEROUS: Perform all clean steps, force reset any git state, and drop untracked files.
	$(info Wiping changes...)
	$(RULE)$(GIT) clean -xdf

help:  ## Show this help text.
	$(info $(PROJECT_NAME):)
	$(RULE)$(GREP) -E '^[a-z1-9A-Z_-]+:.*?## .*$$' $(PWD)/Makefile | $(SORT) | $(AWK) 'BEGIN {FS = ":.*?## "}; {printf "$(BLUE)%-30s$(NC) %s\n", $$1, $$2}'


include tools/Tools.mak

.PHONY: all build test status setup env image sources deploy clean distclean expunge reset forceclean help ensure-deps
