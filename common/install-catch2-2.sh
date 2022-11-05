#!/usr/bin/env bash
set -eou pipefail

VERSION="2.13.10"

CATCH_DIR=/usr/include/catch2-2
CXX=$1
CXX_STANDARDS="$2"
CXXLIB="$3"
echo "Downloading catch2-v${VERSION}"
wget -nv https://github.com/catchorg/Catch2/releases/download/v${VERSION}/catch.hpp

cat > main.cpp <<DONE
#define CATCH_CONFIG_MAIN
#include "catch.hpp"
DONE

CXXFLAGS=${CXXLIB:+"-stdlib=${CXXLIB}"}

echo "Building catch2-v${VERSION} main"
for STD in ${CXX_STANDARDS}
do
    PREFIX="/usr/local/catch2-2-c++${STD}${CXXLIB}"
    echo ${CXX} -I . -std=c++${STD} ${CXXFLAGS} main.cpp -c
    ${CXX} -I . -std=c++${STD} ${CXXFLAGS} main.cpp -c
    ar rcs -o libCatch2Main.a main.o
    mkdir -p ${PREFIX}/lib
    mkdir -p ${PREFIX}/include/catch2
    mv libCatch2Main.a ${PREFIX}/lib
    cp catch.hpp ${PREFIX}/include/catch2
    rm main.o
done
rm main.cpp
rm catch.hpp
