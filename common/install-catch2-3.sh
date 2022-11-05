#!/usr/bin/env bash
set -eou pipefail

VERSION="3.1.1"

CXX=$1
CXX_STANDARDS="$2"
CXXLIB=$3

CXXFLAGS=${CXXLIB:+"-stdlib=${CXXLIB}"}

echo "Downloading catch2-v${VERSION}"
wget -nv -O catch2_src.tar.gz "https://github.com/catchorg/Catch2/archive/refs/tags/v${VERSION}.tar.gz"

echo "Installing catch2-${VERSION}"
mkdir catch2_src
tar xf catch2_src.tar.gz -C catch2_src --strip-components=1

for STD in ${CXX_STANDARDS}
do
    [ "${STD}" == "11" ] || { # catch2 v3 does not support C++11
        PREFIX="/usr/local/catch2-3-c++${STD}${CXXLIB}"
        BUILD_DIR="catch2_build_${STD}"
        mkdir ${BUILD_DIR}
        cmake -B ${BUILD_DIR} \
            -DCMAKE_CXX_COMPILER=${CXX} \
            -DCMAKE_CXX_STANDARD=${STD} \
            -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
            -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
            catch2_src -G Ninja
        cmake --build ${BUILD_DIR}
        cmake --install ${BUILD_DIR}
    }
done
echo "Cleaning up"
rm -r catch2*