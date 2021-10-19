
# `pos-adapter-base` · [![Build status](https://badge.buildkite.com/37fb020fa2e6272825a6cf3a7eb3065ba6247b26905956eedc.svg)](https://buildkite.com/cookies/pos-adapter-base)

- App Version: `v1a`
- Bazel Version: `4.2.1`

Base point-of-sale adapter tooling. Provides adapter structure and central definitions for vendor implementation modules.


## Getting Started

The application is built using Bazel, with the backend and frontend both written in Node. Bazel is driven by the project's `Makefile`.


To build the app:
```
> git clone git@github.com:OpenCannabis/pos-adapter-base.git ./adapter-base && cd adapter-base && make
```

To run the tests:
```
make test
```


### Using the `Makefile`

To get a list of commands supported by the `Makefile`, you can just run `make help`:
```
pos-adapter-base:
all                            Build and test the sample application.
build                          Build the sample application via Bazel.
clean                          Clean ephemeral build targets. Always safe to run.
deploy                         Re-render Kubernetes configurations to prep a deploy.
distclean                      Clean any development state. Wipes `.dev`.
ensure-deps                    Force-run dependency install routines (ideal for use in CI).
expunge                        Perform a distclean and expunge via Bazel.
forceclean                     DANGEROUS: Perform all clean steps, force reset any git state, and drop untracked files.
help                           Show this help text.
image                          Build the app image via Bazel.
reset                          DANGEROUS: Reset any git state.
resetup                        Clean the dev environment only, and re-initialize it. Automatically run after dep updates.
run                            Build and run the sample application via Bazel.
sources                        Re-render templated sources, like the README.
status                         Display status of the local dev environment.
test                           Run the testsuite for the sample application via Bazel.
```

To get the current version info for the codebase, simply run `make status`:
```
> make status

-- Active features:
Languages:
ENABLE_NODE no
ENABLE_JAVA yes
ENABLE_PYTHON yes

Tooling:
ENABLE_BAZEL yes
ENABLE_GCLOUD yes
ENABLE_DOCKER yes
ENABLE_SKAFFOLD no

Deployment:
ENABLE_K8S no
ENABLE_HELM no

-- Pinned versions:
Versions:
IBAZEL_VERSION v0.15.10
BAZELISK_VERSION v1.10.1
SKAFFOLD_VERSION latest
HELM_VERSION v3.6.3
BAZEL_VERSION 4.2.0
NODE_VERSION 16.6.2
YARN_VERSION 1.22.10
GO_VERSION 1.16.5

-- Docker image:

DOCKER_REGISTRY us.gcr.io/opencannabis-tools
DOCKER_REPOSITORY adapter/base

-- Current status:
STABLE_DOCKER_REPO us.gcr.io/opencannabis-tools
STABLE_BUILD_GIT_COMMIT 79e2748-dirty
STABLE_DOCKER_TAG v20210831-79e2748
DOCKER_TAG v20210831-79e2748-dirty
VERSION v1a
BASE v1a
```


### Re-rendering sources

To update the dynamic portions of this README and other codebase sources (for instance, after bumping a version or changing dependencies like Bazel), you should run:

```bash
make sources
```


---

🍪 Copyright © Cookies Creative Consulting & Promotions, Inc.

This repository contains private computer source code owned by Cookies (heretofore Cookies Creative Consulting & Promotions, a California Company). Use of this code in source or object form requires prior written permission from a duly-authorized member of Cookies Engineering. All rights reserved.
