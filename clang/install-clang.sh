#!/usr/bin/env bash
# Adapted from https://github.com/silkeh/docker-clang/blob/master/install.sh.
set -eou pipefail

VERSION=$1


fetch_clang () {
    apt install -y software-properties-common
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|apt-key add -
    apt-add-repository "deb http://apt.llvm.org/unstable/ llvm-toolchain-$VERSION main"
    apt-add-repository "deb-src http://apt.llvm.org/unstable/ llvm-toolchain-$VERSION main"
    apt update
    apt install -y clang-$VERSION libc++-$VERSION-dev libc++abi-${VERSION}-dev
}

apt install -y clang-${VERSION} || fetch_clang clang-${VERSION}
