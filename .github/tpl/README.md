
# `app` · [![Build status](https://badge.buildkite.com/37fb020fa2e6272825a6cf3a7eb3065ba6247b26905956eedc.svg)](https://buildkite.com/cookies/typescript-sample-app)

- App Version: `{VERSION}`
- Bazel Version: `{BAZEL_VERSION}`

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
{MAKE_HELP}
```

To get the current version info for the codebase, simply run `make status`:
```
> make status

{MAKE_STATUS}
```


### Re-rendering sources

To update the dynamic portions of this README and other codebase sources (for instance, after bumping a version or changing dependencies like Bazel), you should run:

```bash
make sources
```


---

🍪 Copyright © Cookies Creative Consulting & Promotions, Inc.

This repository contains private computer source code owned by Cookies (heretofore Cookies Creative Consulting & Promotions, a California Company). Use of this code in source or object form requires prior written permission from a duly-authorized member of Cookies Engineering. All rights reserved.
