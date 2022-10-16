ARG CONTAINER_ID
FROM ${CONTAINER_ID}
LABEL maintainer="Björn Fahller <bjorn@fahller.se>"

WORKDIR /root
COPY clang/install-clang.sh clang/install-libcxx.sh common/install-cmake.sh common/install-kcov.sh test/test.cpp ./

ARG CLANG_VERSION
ARG LIBCXX
ARG BUILD_LIBCXX
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    binutils-dev \
    ca-certificates \
    git \
    ${LIBCXX} \
    libcurl4-openssl-dev \
    libdw-dev \
    libiberty-dev \
    libssl-dev \
    make \
    ninja-build \
    python3 \
    xz-utils \
    zlib1g-dev \
    wget && \
    ./install-clang.sh ${CLANG_VERSION} && \
    ./install-cmake.sh && \
    ${BUILD_LIBCXX} \
    ./install-kcov.sh clang-${CLANG_VERSION} clang++-${CLANG_VERSION} && \
    rm install-clang.sh install-cmake.sh install-libcxx.sh install-kcov.sh

ENV CC              clang-${CLANG_VERSION}
ENV CXX             clang++-${CLANG_VERSION}
ENV CMAKE_GENERATOR Ninja
