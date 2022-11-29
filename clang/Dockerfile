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
    gdb \
    git \
    ${LIBCXX} \
    libcurl4-openssl-dev \
    libdw-dev \
    libiberty-dev \
    libssl-dev \
    make \
    ninja-build \
    parallel \
    python3 \
    xz-utils \
    zlib1g-dev \
    wget && \
    ./install-clang.sh ${CLANG_VERSION} && \
    ./install-cmake.sh && \
    ./install-kcov.sh clang-${CLANG_VERSION} clang++-${CLANG_VERSION} && \
    ${BUILD_LIBCXX} && \
    rm install-clang.sh install-cmake.sh install-libcxx.sh install-kcov.sh

ARG CLANG_VERSION
ARG CXX_STANDARDS
COPY common/install-catch2-3.sh common/install-catch2-2.sh ./
RUN ./install-catch2-3.sh clang++-${CLANG_VERSION} "${CXX_STANDARDS}" "libc++" && \
    ./install-catch2-3.sh clang++-${CLANG_VERSION} "${CXX_STANDARDS}" "" && \
    ./install-catch2-2.sh clang++-${CLANG_VERSION} "${CXX_STANDARDS}" "libc++" && \
    ./install-catch2-2.sh clang++-${CLANG_VERSION} "${CXX_STANDARDS}" "" && \
    rm install-catch2-3.sh && \
    rm install-catch2-2.sh

ARG CLANG_VERSION
ARG CXX_STANDARDS
COPY common/install-fmt.sh ./
RUN ./install-fmt.sh clang++-${CLANG_VERSION} "${CXX_STANDARDS}" "libc++" && \
    ./install-fmt.sh clang++-${CLANG_VERSION} "${CXX_STANDARDS}" "" && \
    rm install-fmt.sh


ENV CC              clang-${CLANG_VERSION}
ENV CXX             clang++-${CLANG_VERSION}
ENV CMAKE_GENERATOR Ninja
ENV PATH            /usr/lib/llvm-${CLANG_VERSION}/bin:${PATH}
