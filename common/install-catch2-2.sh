#!/usr/bin/env bash
set -eou pipefail

VERSION="2.13.10"

CATCH_DIR=/usr/include/catch2-2
CXX=$1
CXX_STANDARDS="$2"
CXXLIB="$3"
echo "Downloading catch2-v${VERSION}"

wget -nv -O catch2_src.tar.gz https://github.com/catchorg/Catch2/archive/refs/tags/v${VERSION}.tar.gz
mkdir catch2_src
tar xf catch2_src.tar.gz -C catch2_src --strip-components=1

CXXFLAGS=${CXXLIB:+"-stdlib=${CXXLIB}"}

for STD in ${CXX_STANDARDS}
do
    cmake -B catch2-build \
          -DCMAKE_INSTALL_PREFIX="/usr/local/lib/c++${STD}${CXXLIB}/catch2-2" \
          -DCMAKE_CXX_COMPILER=${CXX} \
          -DCMAKE_CXX_STANDARD="${STD}" \
          -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
          -DCATCH_BUILD_TESTING=off \
          -DCATCH_BUILD_STATIC_LIBRARY=on \
          catch2_src && \
    cmake --build catch2-build && \
    cmake --install catch2-build && \
    rm -rf catch2-build
done
rm -r catch2_src*
