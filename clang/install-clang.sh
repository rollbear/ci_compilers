#!/usr/bin/env bash
set -eou pipefail

VERSION=$1


fetch_clang () {
    source /etc/lsb-release
    apt install -y software-properties-common
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|apt-key add -
    apt-add-repository "deb http://apt.llvm.org/${DISTRIB_CODENAME}/ llvm-toolchain-${DISTRIB_CODENAME}-$VERSION main"
    apt-add-repository "deb-src http://apt.llvm.org/${DISTRIB_CODENAME}/ llvm-toolchain-${DISTRIB_CODENAME}-$VERSION main"
    apt update
    apt install -y clang-$VERSION libc++-$VERSION-dev libc++abi-${VERSION}-dev libfuzzer-$VERSION-dev
}

apt install -y clang-${VERSION} || fetch_clang clang-${VERSION}
for f in /usr/bin/llvm*-${VERSION}
do
  ln -s $f `echo $f | sed "s/-${VERSION}//"`
done
