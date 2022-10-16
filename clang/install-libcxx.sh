#!/usr/bin/env bash

set -e

VERSION=$2


MAJOR=$(echo $VERSION | sed 's/\..*//')

echo "Fetching libc++/libc++abi version: ${VERSION}..."
if [ ${MAJOR} -ge 8 ]; then
    BASE_URL="https://github.com/llvm/llvm-project/releases/download/llvmorg-"
else
    BASE_URL="https://releases.llvm.org/"
fi
LLVM_URL="${BASE_URL}${VERSION}/llvm-${VERSION}.src.tar.xz"
LIBCXX_URL="${BASE_URL}${VERSION}/libcxx-${VERSION}.src.tar.xz"
#LIBCXXABI_URL="${BASE_URL}${VERSION}/libcxxabi-${VERSION}.src.tar.xz"
COMPILERRT_URL="${BASE_URL}${VERSION}/compiler-rt-${VERSION}.src.tar.xz"
echo wget $LLVM_URL
echo wget $LIBCXX_URL
#echo wget $LIBCXXABI_URL
echo wget $COMPILERRT_URL
wget $LLVM_URL
wget $LIBCXX_URL
#wget $LIBCXXABI_URL
wget $COMPILERRT_URL

mkdir llvm-source
mkdir llvm-source/projects
mkdir llvm-source/projects/libcxx
mkdir llvm-source/projects/libcxxabi

tar -xf llvm-${VERSION}.src.tar.xz -C llvm-source --strip-components=1
tar -xf libcxx-${VERSION}.src.tar.xz -C llvm-source/projects/libcxx --strip-components=1

SOURCE=`pwd`/llvm-source
mkdir llvm-build

# - libc++ versions < 4.x do not have the install-cxxabi and install-cxx targets
# - only ASAN is enabled for clang/libc++ versions < 4.x
if [[ $VERSION == *"3."* ]]; then
    #cd llvm-build
    cmake -B llvm-build \
	  -DCMAKE_C_COMPILER=clang-$1 \
	  -DCMAKE_CXX_COMPILER=clang++-$1 \
          -DCMAKE_BUILD_TYPE=RelWithDebInfo \
	  -DLIBCXX_LIBSUPCXX_INCLUDE_PATHS="/usr/include/c++/4.7;/usr/include/x86_64-linux-gnu/c++/4.7" \
          -DLIBCXX_CXX_ABI='libstdc++' \
          llvm-source
    cmake --build llvm-build --target cxx
    mkdir -p /usr/lib/llvm-$1/include/c++/v1
    cp -r llvm-build/lib/* /usr/lib/x86_64-linux-gnu
    cp -r llvm-build/include/c++/v1/* /usr/lib/llvm-$1/include/c++/v1
else
    ln -s /usr/include/locale.h /usr/include/xlocale.h
    cmake -DCMAKE_C_COMPILER=clang-$1 -DCMAKE_CXX_COMPILER=clang++-$1 \
	  -DCMAKE_INSTALL_PREFIX=/usr \
          -DCMAKE_BUILD_WITH_INSTALL_RPATH=1 \
          -DCMAKE_MODULE_PATH=${SOURCE}/Modules \
          -DLLVM_INCLUDE_BENCHMARKS=no \
          -DLIBCXX_INCLUDE_BENCHMARKS=no \
          -DLIBCXX_CXX_ABI='libstdc++' \
	  -DLIBCXX_ENABLE_EXPERIMENTAL_LIBRARY=no \
	  -DLIBCXX_INSTALL_HEADERS=yes \
	  -DLIBCXX_NEEDS_SITE_CONFIG=no \
	  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
          -B llvm-build \
	  -G Ninja \
          llvm-source
    cmake --build llvm-build --target cxx
    cmake --build llvm-build --target install-cxx
    cd ..  
fi
rm -rf llvm-*
