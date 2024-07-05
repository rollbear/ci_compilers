#!/usr/bin/env bash
set -eou pipefail

VERSION=$1

MAJOR=${VERSION%%.*}

if [ $MAJOR -ge 6 ]
then
    FUZZER="libfuzzer-${VERSION}-dev"
else
    FUZZER=""
fi

if [ -z "$LIBCXX" -a $MAJOR -ge 18 ]
then
  LIBCXX="libc++-${VERSION}-dev"
fi

fetch_clang () {
    source /etc/lsb-release
    apt install -y software-properties-common
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|apt-key add -
    apt-add-repository "deb http://apt.llvm.org/${DISTRIB_CODENAME}/ llvm-toolchain-${DISTRIB_CODENAME}-$VERSION main"
    apt-add-repository "deb-src http://apt.llvm.org/${DISTRIB_CODENAME}/ llvm-toolchain-${DISTRIB_CODENAME}-$VERSION main"
    apt update
    apt install -y clang-$VERSION libc++-$VERSION-dev libc++abi-${VERSION}-dev ${FUZZER}
    apt install -y clang-format-$VERSION || true

}


apt install -y clang-${VERSION} ${LIBCXX} ${FUZZER}|| fetch_clang clang-${VERSION}
apt install -y clang-format-${VERSION} || true
for f in /usr/bin/llvm*-${VERSION}
do
  ln -s $f `echo $f | sed "s/-${VERSION}//"`
done
