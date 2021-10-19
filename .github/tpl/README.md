
# `pos-adapter-base` · [![Build status](https://badge.buildkite.com/37fb020fa2e6272825a6cf3a7eb3065ba6247b26905956eedc.svg)](https://buildkite.com/cookies/pos-adapter-base)

- App Version: `{VERSION}`
- Bazel Version: `{BAZEL_VERSION}`

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
