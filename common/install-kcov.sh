#!/usr/bin/env bash
set -eou pipefail

CC=$1
CXX=$2


(echo "" | $CXX -std=c++17 -E - ) 2>&1 > /dev/null && VERSION="v42" || VERSION="v41"

echo "Downloading kcov-${VERSION}"
wget -nv -O kcov_src.tar.gz "https://github.com/SimonKagstrom/kcov/archive/refs/tags/${VERSION}.tar.gz"

echo "Installing kcov-${VERSION}"
mkdir kcov_src
tar xf kcov_src.tar.gz -C kcov_src --strip-components=1

mkdir kcov_build
cmake -B kcov_build -DCMAKE_C_COMPILER=${CC} -DCMAKE_CXX_COMPILER=${CXX} kcov_src -G Ninja
cmake --build kcov_build
cmake --install kcov_build

echo "Cleaning up"
rm -r kcov_src.tar.gz kcov_build kcov_src
