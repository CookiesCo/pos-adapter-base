workspace(
    name = "adapter_base",
    managed_directories = {"@npm": ["node_modules"]},
)

load(
    "@bazel_tools//tools/build_defs/repo:http.bzl",
    "http_archive",
)

http_archive(
    name = "opencannabis",
    sha256 = "f2801527d3b15351158eb5273e93df64b93557f6023df082e199daab09d99426",
    strip_prefix = "OpenCannabis-bcbd3b9f628b7931a48cb5adf8ea6ed61632c221",
    urls = ["https://github.com/CookiesCo/OpenCannabis/archive/bcbd3b9f628b7931a48cb5adf8ea6ed61632c221.tar.gz"],
)

load("//:defs.bzl", "adapter_repositories")
adapter_repositories()

### --- Setup --- ###
load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")
protobuf_deps()

load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")
rules_proto_dependencies()
rules_proto_toolchains()

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")
go_rules_dependencies()
go_register_toolchains(version = "1.17.1")
gazelle_dependencies()

load("@io_bazel_rules_docker//go:image.bzl", go_image_repos = "repositories")
load("@io_bazel_rules_docker//java:image.bzl", java_image_repos = "repositories")
load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")

## Kotlin
load("@io_bazel_rules_kotlin//kotlin:repositories.bzl", "kotlin_repositories")
kotlin_repositories()

load("@io_bazel_rules_kotlin//kotlin:core.bzl", "kt_register_toolchains")
kt_register_toolchains()

## Graal
load("@rules_graal//graal:graal_bindist.bzl", "graal_bindist_repository")

graal_bindist_repository(
    name = "graal",
    java_version = "11",
    version = "21.3.0",
)

## `rules_cc`
load("@rules_cc//cc:repositories.bzl", "rules_cc_dependencies", "rules_cc_toolchains")
rules_cc_dependencies()
rules_cc_toolchains()


### --- Base-only --- ###

## Stardoc
load("@io_bazel_stardoc//:setup.bzl", "stardoc_repositories")
stardoc_repositories()

## Docker
load("@io_bazel_rules_docker//repositories:repositories.bzl", container_repositories = "repositories")
container_repositories()
container_deps()
go_image_repos()
java_image_repos()

load("@rules_jvm_external//:defs.bzl", "maven_install")

maven_install(
    artifacts = [
        "info.picocli:picocli:4.6.1",
    ],
    repositories = [
        "https://maven.google.com",
        "https://repo1.maven.org/maven2",
    ],
)
