
# `echo` · [![Build status](https://badge.buildkite.com/37fb020fa2e6272825a6cf3a7eb3065ba6247b26905956eedc.svg)](https://buildkite.com/cookies/typescript-sample-app)

- App Version: `v1a`
- Bazel Version: `4.2.0`

Example application repo, with integration to the main Cookies Cloud.

### _Batteries included_

This codebase comes with a ton of built-in features, both on the backend and frontend, which can be stolen for downstream apps:

- Fully equipped project `Makefile`
  - Self-documenting via `make help`
  - Customizable via `tools/Tools.mak`
  - Local dev environment via `tools/Setup.mak`
  - Designed to be update-able from the central repo
- Support for all the best dev tooling
  - [Codespaces](https://github.com/features/codespaces) and [Gitpod](https://gitpod.io) (via [`pantheon`](https://github.com/CookiesCo/pantheon))
  - [`bazelisk`](https://github.com/bazelbuild/bazelisk), [`ibazel`](https://github.com/bazelbuild/bazel-watcher), [`buildifier`](https://github.com/bazelbuild/buildtools/tree/master/buildifier), [`buildozer`](https://github.com/bazelbuild/buildtools/tree/master/buildozer)
  - [SonarCloud](https://sonarcloud.com) linting and static analysis
  - [Prettier](https://prettier.io/) code formatting
  - [Buildkite](https://buildkite.com) with [dynamic change-driven builds](https://github.com/chronotc/monorepo-diff-buildkite-plugin), defined in-repo (see `infra/devops`)
  - Cross-platform coverage reporting to [Codecov](https://codecov.io)
  - Support for auto-installable [`git` hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)
  - Dynamically rendered sources (this `README.md` is dynamic! rebuild via `make sources`)
  - Single source of version truth (see `.version`)
  - Declarative GCP resource management (`infra/gcp`)
- Developer-driven production CD flow
  - In-repo control of K8S configs (see `infra/k8s`)
  - Support for [Kustomize](https://kustomize.io)-driven configuration rendering
  - Convention for `sandbox`, `staging`, and `prod` environments
  - Support for [CRDs](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) and [Helm charts](https://helm.sh/)
- Supporting runtime for easy application deployment
  - Auto-managed DNS records (see the hostname annotation in `infra/overlays/sandbox/service-ext.yaml`)
  - Auto-managed private SSL certs (see `infra/k8s/cert.yaml`)
  - Auto-configuration of [Cloudflare Origin Certificates](https://developers.cloudflare.com/ssl/origin-configuration/origin-ca) and [Cloudflare GSLB](https://www.cloudflare.com/load-balancing/)



## Getting Started

The application is built using Bazel, with the backend and frontend both written in Node. Bazel is driven by the project's `Makefile`.


To build the app:
```
> git clone git@github.com:CookiesCo/echo.git ./echo && cd echo && make
```

To run the tests:
```
make test
```

To deploy the app (by default, to the `sandbox`):
```
make deploy
```

To promote from `sandbox` to `staging`:
```
make promote FROM=sandbox TO=staging
```

To promote from `staging` to `prod`:
```
make promote FROM=staging TO=prod UNGATE=yes
```


### Using the `Makefile`

To get a list of commands supported by the `Makefile`, you can just run `make help`:
```
sample-app:
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
k8s-all                        Render all configs for all Kubernetes environments.
k8s                            Render all Kubernetes configurations for a single env, depositing them in `.k8s`.
k8s-seal                       Seal Kubernetes configs for a given namespace. Caution: this amends the previous Git commit with rendered manifests.
promote                        Promote changes to a new namespace.
push                           Build and push the latest app image.
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
ENABLE_NODE yes
ENABLE_JAVA yes
ENABLE_PYTHON yes

Tooling:
ENABLE_BAZEL yes
ENABLE_GCLOUD yes
ENABLE_DOCKER yes
ENABLE_SKAFFOLD yes

Deployment:
ENABLE_K8S yes
ENABLE_HELM yes

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

DOCKER_REGISTRY us.gcr.io/cookies-co
DOCKER_REPOSITORY dev/sample-app/node

-- Current status:
STABLE_DOCKER_REPO us.gcr.io/cookies-co
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
