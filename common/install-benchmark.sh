#!/usr/bin/env bash
set -eou pipefail

readonly VERSION=v1.8.4
readonly CXX=$1
readonly CXX_STANDARDS="$2"
readonly CXXLIB=$3
readonly CXXFLAGS=${CXXLIB:+"-stdlib=${CXXLIB}"}

echo "Downloading benchmark ${VERSION}"
wget -nv -O benchmark_src.tar.gz https://github.com/google/benchmark/archive/refs/tags/${VERSION}.tar.gz
mkdir benchmark_src
tar xf benchmark_src.tar.gz -C benchmark_src --strip-components=1

for STD in ${CXX_STANDARDS}
do
    echo "Building benchmark ${VERSION} for C++${STD}${CXXLIB}"
    PREFIX="/usr/local/lib/c++${STD}${CXXLIB}/benchmark"
    mkdir build
    cmake -B build \
          -DCMAKE_CXX_COMPILER=${CXX} \
          -DCMAKE_CXX_STANDARD=${STD} \
          -DCMAKE_INSTALL_PREFIX=${PREFIX} \
          -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
          -DCMAKE_BUILD_TYPE=Release \
          -DHAVE_STD_REGEX=ON \
          -DBENCHMARK_ENABLE_TESTING=NO \
          -DCMAKE_CXX_FLAGS="-Wno-error=shadow" \
          -S benchmark_src \
          -G Ninja &&
    cmake --build build && cmake --install build && rm -r build
done
echo "Cleaning up"
rm -r benchmark*
