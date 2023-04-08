ARG CONTAINER_ID
FROM ${CONTAINER_ID}
LABEL maintainer="Björn Fahller <bjorn@fahller.se>"

WORKDIR /root
COPY test/test.cpp ./

ARG GCC_VERSION
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    binutils-dev \
    ca-certificates \
    g++-${GCC_VERSION} \
    gdb \
    git \
    libcurl4-openssl-dev \
    libdw-dev \
    libiberty-dev \
    libssl-dev \
    ninja-build \
    parallel \
    python3 \
    valgrind \
    xz-utils \
    zlib1g-dev \
    wget

ARG GCC_VERSION
RUN bash -c 'for f in /usr/bin/*-${GCC_VERSION}; do echo ln -s $f /usr/bin/`basename $f -${GCC_VERSION}`; ln -s $f /usr/bin/`basename $f -${GCC_VERSION}`; done'

COPY common/install-cmake.sh ./
RUN ./install-cmake.sh && \
    rm install-cmake.sh

COPY common/install-kcov.sh ./
ARG GCC_VERSION
RUN ./install-kcov.sh gcc-${GCC_VERSION} g++-${GCC_VERSION} && \
    rm  install-kcov.sh

ARG GCC_VERSION
ARG CXX_STANDARDS
COPY common/install-catch2-3.sh common/install-catch2-2.sh ./
RUN ./install-catch2-3.sh g++-${GCC_VERSION} "${CXX_STANDARDS}" "" && \
    ./install-catch2-2.sh g++-${GCC_VERSION} "${CXX_STANDARDS}" "" && \
    rm install-catch2-3.sh && \
    rm install-catch2-2.sh

ARG GCC_VERSION
ARG CXX_STANDARDS
COPY common/install-fmt.sh ./
RUN ./install-fmt.sh g++-${GCC_VERSION} "${CXX_STANDARDS}" "" && \
    rm install-fmt.sh

ARG GCC_VERSION
ARG CXX_STANDARDS
COPY common/install-benchmark.sh ./
RUN ./install-benchmark.sh g++-${GCC_VERSION} "${CXX_STANDARDS}" "" && \
    rm install-benchmark.sh

ENV CC              gcc-${GCC_VERSION}
ENV CXX             g++-${GCC_VERSION}
ENV CMAKE_GENERATOR Ninja
