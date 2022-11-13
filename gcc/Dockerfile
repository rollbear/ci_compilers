ARG CONTAINER_ID
FROM ${CONTAINER_ID}
LABEL maintainer="Björn Fahller <bjorn@fahller.se>"

WORKDIR /root
COPY common/install-cmake.sh common/install-kcov.sh test/test.cpp ./

ARG GCC_VERSION
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    binutils-dev \
    ca-certificates \
    g++-${GCC_VERSION} \
    git \
    libcurl4-openssl-dev \
    libdw-dev \
    libiberty-dev \
    libssl-dev \
    ninja-build \
    parallel \
    python3 \
    xz-utils \
    zlib1g-dev \
    wget && \
    ./install-cmake.sh && \
    ./install-kcov.sh gcc-${GCC_VERSION} g++-${GCC_VERSION} && \
    rm install-cmake.sh install-kcov.sh

ARG GCC_VERSION
ARG CXX_STANDARDS
COPY common/install-catch2-3.sh common/install-catch2-2.sh .
RUN ./install-catch2-3.sh g++-${GCC_VERSION} "${CXX_STANDARDS}" "" && \
    ./install-catch2-2.sh g++-${GCC_VERSION} "${CXX_STANDARDS}" "" && \
    rm install-catch2-3.sh && \
    rm install-catch2-2.sh

ARG GCC_VERSION
ARG CXX_STANDARDS
COPY common/install-fmt.sh .
RUN ./install-fmt.sh g++-${GCC_VERSION} "${CXX_STANDARDS}" "" && \
    rm install-fmt.sh

ENV CC              gcc-${GCC_VERSION}
ENV CXX             g++-${GCC_VERSION}
ENV CMAKE_GENERATOR Ninja
