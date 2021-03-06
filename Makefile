
#
# Makefile: POS Adapter Base
#

MAKEFLAGS += --no-print-directory

# -- Configuration --

VERSION = $(shell cat ./.version)
BASE = v1a

APP ?= //:adapter
IMAGE ?= //:image
TESTS ?= //tests/...
TARGETS ?= $(APP)
NAMESPACE ?= sandbox

PULL ?= no
PUSH ?= no
CI ?= no
SEAL ?= yes
QUIET ?= no
VERBOSE ?= no
DEBUG ?= no
COLORS ?= yes
COVERAGE ?= no
PROJECT_NAME ?= pos-adapter-base
DOCKER_REGISTRY ?= us.gcr.io/opencannabis-tools
DOCKER_REPOSITORY ?= adapter/base
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

build: $(ENV)  ## Build the sample application via Bazel.
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

run:  ## Build and run the sample application via Bazel.
	$(info Building app...)
	$(RULE)$(BAZELISK) $(BAZELISK_ARGS) run $(BAZEL_ARGS) $(APP)

sources: $(ENV)  ## Re-render templated sources, like the README.
	$(info Re-rendering sources...)
	$(RULE)$(PYTHON) tools/sources.py
	@echo "Sources ready."

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
