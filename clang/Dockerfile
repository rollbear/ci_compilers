ARG CONTAINER_ID
FROM ${CONTAINER_ID}
LABEL maintainer="Björn Fahller <bjorn@fahller.se>"

WORKDIR /root
COPY test/test.cpp ./

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
    valgrind \
    xz-utils \
    zlib1g-dev \
    wget

COPY clang/install-clang.sh ./
ARG CLANG_VERSION
RUN ./install-clang.sh ${CLANG_VERSION} && \
    rm install-clang.sh

COPY common/install-cmake.sh ./
RUN ./install-cmake.sh && \
    rm install-cmake.sh

COPY common/install-kcov.sh ./
ARG CLANG_VERSION
RUN ./install-kcov.sh clang-${CLANG_VERSION} clang++-${CLANG_VERSION} && \
    rm install-kcov.sh

COPY clang/install-libcxx.sh ./
ARG BUILD_LIBCXX
RUN ${BUILD_LIBCXX} && \
    rm install-libcxx.sh

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

ARG GCC_VERSION
ARG CXX_STANDARDS
COPY common/install-benchmark.sh ./
RUN ./install-benchmark.sh clang++-${CLANG_VERSION} "${CXX_STANDARDS}" "libc++" && \
    ./install-benchmark.sh clang++-${CLANG_VERSION} "${CXX_STANDARDS}" "" && \
    rm install-benchmark.sh

RUN apt-get clean

ENV CC              clang-${CLANG_VERSION}
ENV CXX             clang++-${CLANG_VERSION}
ENV CMAKE_GENERATOR Ninja
ENV PATH            /usr/lib/llvm-${CLANG_VERSION}/bin:${PATH}
