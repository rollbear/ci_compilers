#!/usr/bin/env bash
set -eou pipefail

VERSIONS="11.0.0 10.2.1 9.1.0 8.1.1"

readonly CXX=$1
readonly CXX_STANDARDS="$2"
readonly CXXLIB=$3

readonly CXXFLAGS=${CXXLIB:+"-stdlib=${CXXLIB}"}

install() {
    VERSION=$1
    MAJOR=${VERSION/.*/}
    echo "Downloading fmt-${VERSION}"
    wget -nv -O fmt_src.tar.gz "https://github.com/fmtlib/fmt/archive/refs/tags/${VERSION}.tar.gz"

    echo "Installing fmt-${VERSION}"
    mkdir fmt_src
    tar xf fmt_src.tar.gz -C fmt_src --strip-components=1

    for STD in ${CXX_STANDARDS}
    do
        PREFIX="/usr/local/lib/c++${STD}${CXXLIB}/fmt${MAJOR}"
        BUILD_DIR="fmt_build_${STD}"
        mkdir ${BUILD_DIR}
        cmake -B ${BUILD_DIR} \
            -DCMAKE_CXX_COMPILER=${CXX} \
            -DCMAKE_CXX_STANDARD=${STD} \
            -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
            -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
            -DFMT_DOC=off \
            -DFMT_TEST=off \
            fmt_src -G Ninja && \
        cmake --build ${BUILD_DIR} && cmake --install ${BUILD_DIR} || true
    done
    echo "Cleaning up"
    rm -r fmt*
}

for version in $VERSIONS
do
    install $version
done
