ARG GCC_VERSION=4.8
FROM gcc:$GCC_VERSION

ARG CMAKE_VERSION=3.20.0

RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.sh \
    -q -O /tmp/cmake-install.sh \
    && chmod u+x /tmp/cmake-install.sh

RUN  mkdir -p /usr/bin/cmake \
    && /tmp/cmake-install.sh --skip-license --prefix=/usr/bin/cmake \
    && rm /tmp/cmake-install.sh

RUN  apt-get update
RUN  apt-get install libnuma-dev -y
RUN  apt-get install unixodbc-dev -y

ENV PATH="/usr/bin/cmake/bin:${PATH}"

WORKDIR /app
