#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")/.."

mkdir -p './build'

rm -f ./build/*

function compile() {
    os="$1" arch="$2"
    echo "COMPILING BINARY FOR ${os}-${arch}"

    GOOS="$os" GOARCH="$arch" make build > /dev/null
    mv ./pushprox-proxy "./build/prometheus-proxy-${os}-${arch}"
    mv ./pushprox-client "./build/prometheus-proxy-client-${os}-${arch}"
    tar -czf "./build/prometheus-proxy-${os}-${arch}.tar.gz" "./build/prometheus-proxy-${os}-${arch}"
    tar -czf "./build/prometheus-proxy-client-${os}-${arch}.tar.gz" "./build/prometheus-proxy-client-${os}-${arch}"

    GOOS="$os" GOARCH="$arch" CGO_ENABLED=0 make build > /dev/null
    mv ./pushprox-proxy "./build/prometheus-proxy-${os}-${arch}-CGO0"
    mv ./pushprox-client "./build/prometheus-proxy-client-${os}-${arch}-CGO0"
    tar -czf "./build/prometheus-proxy-${os}-${arch}-CGO0.tar.gz" "./build/prometheus-proxy-${os}-${arch}-CGO0"
    tar -czf "./build/prometheus-proxy-client-${os}-${arch}-CGO0.tar.gz" "./build/prometheus-proxy-client-${os}-${arch}-CGO0"
}

compile "linux" "386"
compile "linux" "amd64"
compile "linux" "arm"
compile "linux" "arm64"

compile "freebsd" "386"
compile "freebsd" "amd64"
compile "freebsd" "arm"

compile "openbsd" "386"
compile "openbsd" "amd64"
compile "openbsd" "arm"

compile "darwin" "amd64"
compile "darwin" "arm64"

