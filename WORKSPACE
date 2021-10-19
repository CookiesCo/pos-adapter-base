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

load(
    "@opencannabis//config:versions.bzl",
    "PROTOBUF_VERSION",
    "GRPC_VERSION",
    "NODE_VERSION",
    "YARN_VERSION",
)

http_archive(
    name = "com_google_protobuf",
    sha256 = "b10bf4e2d1a7586f54e64a5d9e7837e5188fc75ae69e36f215eb01def4f9721b",
    strip_prefix = "protobuf-%s" % PROTOBUF_VERSION,
    urls = ["https://github.com/protocolbuffers/protobuf/archive/v%s.tar.gz" % PROTOBUF_VERSION],
)

http_archive(
    name = "com_google_googleapis",
    sha256 = "0424d63c6718183a06f0219e09de7d400a2bd5ca570e1822be4f73f59f9b5a56",
    strip_prefix = "googleapis-882e6d69a30e4bde445dd33c710f1235b81270c7",
    urls = ["https://github.com/googleapis/googleapis/archive/882e6d69a30e4bde445dd33c710f1235b81270c7.tar.gz"],
)

http_archive(
    name = "com_github_grpc_grpc",
    strip_prefix = "grpc-%s" % GRPC_VERSION,
    sha256 = "df488fc6ecdc51bfa026fedb552f23b7cd31ce87d4aa38f676d814903f240062",
    urls = ["https://github.com/grpc/grpc/archive/v%s.zip" % GRPC_VERSION],
)

http_archive(
    name = "io_grpc_proto",
    sha256 = "f081eba5884bf09051d27664aede4fc22bbaa77da477735d745bcef17bd088f1",
    strip_prefix = "grpc-proto-ec886024c2f7b7f597ba89d5b7d60c3f94627b17",
    urls = ["https://github.com/grpc/grpc-proto/archive/ec886024c2f7b7f597ba89d5b7d60c3f94627b17.tar.gz"],
)

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "2b1641428dff9018f9e85c0384f03ec6c10660d935b750e3fa1492a281a53b0f",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.29.0/rules_go-v0.29.0.zip",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.29.0/rules_go-v0.29.0.zip",
    ],
)

http_archive(
    name = "bazel_gazelle",
    sha256 = "de69a09dc70417580aabf20a28619bb3ef60d038470c7cf8442fafcf627c21cb",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.24.0/bazel-gazelle-v0.24.0.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.24.0/bazel-gazelle-v0.24.0.tar.gz",
    ],
)

http_archive(
    name = "bazel_skylib",
    sha256 = "97e70364e9249702246c0e9444bccdc4b847bed1eb03c5a3ece4f83dfe6abc44",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.2/bazel-skylib-1.0.2.tar.gz",
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.2/bazel-skylib-1.0.2.tar.gz",
    ],
)

http_archive(
    name = "rules_cc",
    urls = ["https://github.com/bazelbuild/rules_cc/releases/download/0.0.1/rules_cc-0.0.1.tar.gz"],
    sha256 = "4dccbfd22c0def164c8f47458bd50e0c7148f3d92002cdb459c2a96a68498241",
)

http_archive(
    name = "rules_java",
    sha256 = "7c4bbe11e41c61212a5cf16d9aafaddade3f5b1b6c8bf94270d78215fafd4007",
    strip_prefix = "rules_java-c13e3ead84afb95f81fbddfade2749d8ba7cb77f",
    url = "https://github.com/bazelbuild/rules_java/archive/c13e3ead84afb95f81fbddfade2749d8ba7cb77f.tar.gz",
)

http_archive(
    name = "rules_graal",
    sha256 = "596bea60d32ffef720cd79e4adb7847bdadbb594cfb3e79187357c4a49f850f4",
    strip_prefix = "rules_graal-97eb49e8de6f81c9f325362a9eec1672dab4196a",
    url = "https://github.com/sgammon/rules_graal/archive/97eb49e8de6f81c9f325362a9eec1672dab4196a.tar.gz",
)

http_archive(
    name = "io_bazel_rules_kotlin",
    sha256 = "6cbd4e5768bdfae1598662e40272729ec9ece8b7bded8f0d2c81c8ff96dc139d",
    url = "https://github.com/bazelbuild/rules_kotlin/releases/download/v1.5.0-beta-4/rules_kotlin_release.tgz",
)

http_archive(
    name = "io_grpc_java",
    sha256 = "85927f857e0b3ad5c4e51c2e6d29213d3e0319f20784aa2113552f71311ba74c",
    strip_prefix = "grpc-java-%s" % GRPC_VERSION,
    urls = ["https://github.com/grpc/grpc-java/archive/v%s.tar.gz" % GRPC_VERSION],
)

http_archive(
    name = "io_bazel_stardoc",
    sha256 = "9aec63241d323a28663ba99c1ce57bab6f28f1646390511ee48d4b42082f10f4",
    strip_prefix = "stardoc-8275ced1b6952f5ad17ec579a5dd16e102479b72",
    url = "https://github.com/bazelbuild/stardoc/archive/8275ced1b6952f5ad17ec579a5dd16e102479b72.tar.gz",
)

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "5d31ad261b9582515ff52126bf53b954526547a3e26f6c25a9d64c48a31e45ac",
    strip_prefix = "rules_docker-0.18.0",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.18.0/rules_docker-v0.18.0.tar.gz"],
)

# Python rules should go early in the dependencies list, otherwise a wrong
# version of the library will be selected as a transitive dependency of gRPC.
http_archive(
    name = "rules_python",
    url = "https://github.com/bazelbuild/rules_python/releases/download/0.3.0/rules_python-0.3.0.tar.gz",
    sha256 = "934c9ceb552e84577b0faf1e5a2f0450314985b4d8712b2b70717dc679fdc01b",
)

load(
    "@com_google_protobuf//:protobuf_deps.bzl",
    "protobuf_deps",
)

protobuf_deps()

http_archive(
    name = "rules_proto",
    sha256 = "602e7161d9195e50246177e7c55b2f39950a9cf7366f74ed5f22fd45750cd208",
    strip_prefix = "rules_proto-97d8af4dc474595af3900dd85cb3a29ad28cc313",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_proto/archive/97d8af4dc474595af3900dd85cb3a29ad28cc313.tar.gz",
        "https://github.com/bazelbuild/rules_proto/archive/97d8af4dc474595af3900dd85cb3a29ad28cc313.tar.gz",
    ],
)


load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")

rules_proto_dependencies()

rules_proto_toolchains()

RULES_JVM_EXTERNAL_TAG = "4.1"
RULES_JVM_EXTERNAL_SHA = "f36441aa876c4f6427bfb2d1f2d723b48e9d930b62662bf723ddfb8fc80f0140"

http_archive(
    name = "rules_jvm_external",
    strip_prefix = "rules_jvm_external-%s" % RULES_JVM_EXTERNAL_TAG,
    sha256 = RULES_JVM_EXTERNAL_SHA,
    url = "https://github.com/bazelbuild/rules_jvm_external/archive/%s.zip" % RULES_JVM_EXTERNAL_TAG,
)

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


#
# Buf
#

RULES_BUF_VERSION = "7e55fac95a13c2fd126201dc1aacc5a2af04c356"
RULES_BUF_FINGERPRINT = "736f446b4fcf929e4fffdc73779672fd25873ddaa2693f081ea35b1f342c1fd6"

http_archive(
    name = "rules_buf",
    urls = ["https://github.com/sgammon/rules_buf/archive/%s.tar.gz" % RULES_BUF_VERSION],
    strip_prefix = "rules_buf-%s" % RULES_BUF_VERSION,
    sha256 = RULES_BUF_FINGERPRINT,
)

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

## Go
load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

go_rules_dependencies()

go_register_toolchains(version = "1.17.1")

gazelle_dependencies()

load("@io_bazel_rules_docker//go:image.bzl", go_image_repos = "repositories")
load("@io_bazel_rules_docker//java:image.bzl", java_image_repos = "repositories")
load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")

## Docker
load("@io_bazel_rules_docker//repositories:repositories.bzl", container_repositories = "repositories")

container_repositories()

container_deps()

go_image_repos()

java_image_repos()

## Stardoc
load("@io_bazel_stardoc//:setup.bzl", "stardoc_repositories")
stardoc_repositories()

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
