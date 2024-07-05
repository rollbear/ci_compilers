#!/usr/bin/env bash

set -e

VERSION=$2

MAJOR=$(echo $VERSION | sed 's/\..*//')
apt install make
echo "Fetching libc++/libc++abi version: ${VERSION}..."
if [ ${MAJOR} -ge 8 ]; then
    BASE_URL="https://github.com/llvm/llvm-project/releases/download/llvmorg-"
else
    BASE_URL="https://releases.llvm.org/"
fi
LLVM_URL="${BASE_URL}${VERSION}/llvm-${VERSION}.src.tar.xz"
LIBCXX_URL="${BASE_URL}${VERSION}/libcxx-${VERSION}.src.tar.xz"
LIBCXXABI_URL="${BASE_URL}${VERSION}/libcxxabi-${VERSION}.src.tar.xz"
#COMPILERRT_URL="${BASE_URL}${VERSION}/compiler-rt-${VERSION}.src.tar.xz"
CMAKE_URL="${BASE_URL}${VERSION}/cmake-${VERSION}.src.tar.xz"
echo wget $LLVM_URL
echo wget $LIBCXX_URL
echo wget $LIBCXXABI_URL
echo wget $CMAKE_URL

wget $LLVM_URL
wget $LIBCXX_URL
wget $LIBCXXABI_URL
wget $CMAKE_URL || true

mkdir llvm-source
mkdir llvm-source/projects
mkdir llvm-source/projects/libcxx
mkdir llvm-source/projects/libcxxabi

tar -xf llvm-${VERSION}.src.tar.xz -C llvm-source --strip-components=1
tar -xf libcxx-${VERSION}.src.tar.xz -C llvm-source/projects/libcxx --strip-components=1
tar -xf libcxxabi-${VERSION}.src.tar.xz -C llvm-source/projects/libcxxabi --strip-components=1
#tar -xf compiler-rt-${VERSION}.src.tar.xz -C llvm-source/projects/compiler-rt --strip-components=1
[ ! -e cmake-${VERSION}.src.tar.xz ] || tar xf cmake-${VERSION}.src.tar.xz -C llvm-source --strip-components=1

SOURCE=`pwd`/llvm-source
mkdir llvm-build

# - libc++ versions < 4.x do not have the install-cxxabi and install-cxx targets
# - only ASAN is enabled for clang/libc++ versions < 4.x
if [[ $VERSION == "3."* ]]; then
    cmake -B llvm-build \
          -DCMAKE_C_COMPILER=clang-$1 \
          -DCMAKE_CXX_COMPILER=clang++-$1 \
          -DLIBCXX_LIBCXXABI_INCLUDE_PATHS="${SOURCE}/projects/libcxxabi/include/" \
          -DLIBCXX_CXX_ABI_INCLUDE_PATH="${SOURCE}/projects/libcxxabi/include/" \
          -DCMAKE_BUILD_TYPE=RelWithDebInfo \
          -DLIBCXX_CXX_ABI='libcxxabi' \
          llvm-source
    cmake --build llvm-build --target cxxabi
    cp -r llvm-build/lib/* /usr/lib/
    cp -r ${SOURCE}/projects/libcxxabi/include/* /usr/include
    cmake --build llvm-build --target cxx
    mkdir -p /usr/lib/llvm-$1/include/c++/v1
    mkdir -p /usr/include/c++/v1
    find . -name 'libc++*.so'
    cp -r llvm-build/lib/* /usr/lib/x86_64-linux-gnu
    cp -r ${SOURCE}/projects/libcxx/include/* /usr/lib/llvm-$1/include/c++/v1
else
    ln -s /usr/include/locale.h /usr/include/xlocale.h
    cmake -DCMAKE_C_COMPILER=clang-$1 -DCMAKE_CXX_COMPILER=clang++-$1 \
          -DCMAKE_INSTALL_PREFIX=/usr \
          -DCMAKE_BUILD_WITH_INSTALL_RPATH=1 \
          -DCMAKE_MODULE_PATH=${SOURCE}/Modules \
          -DLLVM_INCLUDE_BENCHMARKS=no \
          -DLIBCXX_INCLUDE_BENCHMARKS=no \
          -DLIBCXX_LIBCXXABI_INCLUDE_PATHS="${SOURCE}/projects/libcxxabi/include/" \
          -DLIBCXX_CXX_ABI='libcxxabi' \
          -DLIBCXX_ENABLE_EXPERIMENTAL_LIBRARY=no \
          -DLLVM_DEFAULT_TARGET_TRIPLE=x86_64-linux-gnu \
          -DLIBCXX_INSTALL_HEADERS=yes \
          -DLIBCXX_INSTALL_INCLUDE_TARGET_DIR=/usr/lib/llvm-$1/lib/clang/$VERSION/include \
          -DLIBCXX_INSTALL_RUNTIME_PATH=/usr/lib/llvm-$1/lib \
          -DLIBCXX_NEEDS_SITE_CONFIG=no \
          -DCMAKE_BUILD_TYPE=RelWithDebInfo \
          -B llvm-build \
          llvm-source
    cmake --build llvm-build --target cxxabi
    cmake --build llvm-build --target install-cxxabi
    cp -r ${SOURCE}/projects/libcxxabi/include/* /usr/include
    cmake --build llvm-build --target cxx
    cmake --build llvm-build --target install-cxx
fi
rm -rf llvm-* *${VERSION}.src.tar.xz
