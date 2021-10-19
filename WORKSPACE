workspace(
    name = "app",
    managed_directories = {"@npm": ["node_modules"]},
)

load(
    "@bazel_tools//tools/build_defs/repo:http.bzl",
    "http_archive",
)
load(
    "//tools/config:app.bzl",
    "GO_VERSION",
    "NODE_VERSION",
    "YARN_VERSION",
)

http_archive(
    name = "build_bazel_rules_nodejs",
    sha256 = "8a7c981217239085f78acc9898a1f7ba99af887c1996ceb3b4504655383a2c3c",
    urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/4.0.0/rules_nodejs-4.0.0.tar.gz"],
)

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "8e968b5fcea1d2d64071872b12737bbb5514524ee5f0a4f54f5920266c261acb",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.28.0/rules_go-v0.28.0.zip",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.28.0/rules_go-v0.28.0.zip",
    ],
)

http_archive(
    name = "bazel_gazelle",
    sha256 = "62ca106be173579c0a167deb23358fdfe71ffa1e4cfdddf5582af26520f1c66f",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.23.0/bazel-gazelle-v0.23.0.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.23.0/bazel-gazelle-v0.23.0.tar.gz",
    ],
)

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "5d31ad261b9582515ff52126bf53b954526547a3e26f6c25a9d64c48a31e45ac",
    strip_prefix = "rules_docker-0.18.0",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.18.0/rules_docker-v0.18.0.tar.gz"],
)

http_archive(
    name = "io_bazel_rules_k8s",
    sha256 = "51f0977294699cd547e139ceff2396c32588575588678d2054da167691a227ef",
    strip_prefix = "rules_k8s-0.6",
    urls = ["https://github.com/bazelbuild/rules_k8s/archive/v0.6.tar.gz"],
)

http_archive(
    name = "com_adobe_rules_gitops",
    sha256 = "5caec21e273f6f01279d426d80abd0f6cbaedf8827e7e8018b048f61e0c4867d",
    strip_prefix = "rules_gitops-27441d69b9312d40bfa841266441532cb1363364",
    urls = ["https://github.com/adobe/rules_gitops/archive/27441d69b9312d40bfa841266441532cb1363364.tar.gz"],
)

load(
    "@build_bazel_rules_nodejs//:index.bzl",
    "node_repositories",
    "yarn_install",
)

node_repositories(
    node_version = NODE_VERSION,
    package_json = ["//:package.json"],
    yarn_version = YARN_VERSION,
)

yarn_install(
    name = "npm",
    package_json = "//:package.json",
    yarn_lock = "//:yarn.lock",
)

## Node
load(
    "@npm//@bazel/labs:package.bzl",
    "npm_bazel_labs_dependencies",
)

npm_bazel_labs_dependencies()

load("@build_bazel_rules_nodejs//toolchains/esbuild:esbuild_repositories.bzl", "esbuild_repositories")

esbuild_repositories(npm_repository = "npm")

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

## Go
load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

go_rules_dependencies()

go_register_toolchains(version = GO_VERSION)

gazelle_dependencies()

load("@io_bazel_rules_docker//go:image.bzl", go_image_repos = "repositories")
load("@io_bazel_rules_docker//java:image.bzl", java_image_repos = "repositories")
load("@io_bazel_rules_docker//nodejs:image.bzl", nodejs_image_repos = "repositories")
load("@io_bazel_rules_docker//python:image.bzl", py_image_repos = "repositories")
load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")

## Docker
load("@io_bazel_rules_docker//repositories:repositories.bzl", container_repositories = "repositories")

container_repositories()

container_deps()

py_image_repos()

go_image_repos()

java_image_repos()

nodejs_image_repos()

load("@io_bazel_rules_k8s//k8s:k8s_go_deps.bzl", k8s_go_deps = "deps")

k8s_go_deps()
