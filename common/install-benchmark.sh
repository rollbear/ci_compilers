#!/usr/bin/env bash
set -eou pipefail

readonly VERSION=v1.9.5
readonly FALLBACK_VERSION=v1.9.0
readonly CXX=$1
readonly CXX_STANDARDS="$2"
readonly CXXLIB=$3
readonly CXXFLAGS=${CXXLIB:+"-stdlib=${CXXLIB}"}


download_version () {
    version=$1
    echo "Downloading benchmark ${version}"
    dir="benchmark_src-$version"
    [ -d "$dir" ] || {
        wget -nv -O benchmark_src.tar.gz https://github.com/google/benchmark/archive/refs/tags/${version}.tar.gz
        mkdir "$dir"
        tar xf benchmark_src.tar.gz -C "$dir" --strip-components=1
    }
}

install_version () {
    version=$1
    download_version "$version"
    echo "Building benchmark ${version} for C++${STD}${CXXLIB}"
    PREFIX="/usr/local/lib/c++${STD}${CXXLIB}/benchmark"
    builddir="build-$version"
    [ -e "$builddir" ] && rm -rf "$builddir"
    mkdir "$builddir"
    cmake -B "$builddir" \
          -DCMAKE_CXX_COMPILER=${CXX} \
          -DCMAKE_CXX_STANDARD=${STD} \
          -DCMAKE_INSTALL_PREFIX=${PREFIX} \
          -DCMAKE_CXX_FLAGS="${CXXFLAGS} -Wno-error=shadow" \
          -DCMAKE_BUILD_TYPE=Release \
          -DHAVE_STD_REGEX=ON \
          -DBENCHMARK_ENABLE_TESTING=NO \
          -DCMAKE_VERBOSE_MAKEFILE=yes \
          -S "benchmark_src-$version" \
          -G Ninja && \
    cmake --build "$builddir" && cmake --install "$builddir" && rm -r "$builddir"
}

for STD in ${CXX_STANDARDS}
do
    install_version $VERSION || install_version $FALLBACK_VERSION
done
echo "Cleaning up"
rm -rf benchmark* build*
