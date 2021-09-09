ARG GCC_VERSION=4.8
FROM gcc:$GCC_VERSION

ARG CMAKE_VERSION=3.20.1
ARG GTEST_VERSION=1.10.0

ENV PATH="/usr/bin/cmake/bin:${PATH}"

RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.sh \
    -q -O /tmp/cmake-install.sh \
    && chmod u+x /tmp/cmake-install.sh

RUN mkdir -p /usr/bin/cmake \
    && /tmp/cmake-install.sh --skip-license --prefix=/usr/bin/cmake \
    && rm /tmp/cmake-install.sh

RUN wget https://github.com/google/googletest/archive/release-${GTEST_VERSION}.tar.gz
RUN tar xf release-${GTEST_VERSION}.tar.gz \
    && cd googletest-release-${GTEST_VERSION} \
    && /usr/bin/cmake/bin/cmake -DBUILD_SHARED_LIBS=ON . \
    && make \
    && make install
RUN cd .. \
    && rm -rf googletest-release-${GTEST_VERSION}

RUN echo "deb http://archive.debian.org/debian wheezy main" > /etc/apt/sources.list
RUN echo "deb http://archive.debian.org/debian-archive/debian-security/ wheezy updates/main" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install libnuma-dev -y
RUN apt-get autoclean; rm -rf /var/lib/apt/lists/*

ENV ODBC_VERSION=2.3.1-1
ENV ODBCINI=/etc/odbc.ini
ENV ODBCSYSINI=/etc/

RUN curl ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-${ODBC_VERSION}.tar.gz -O && \
    tar xzvf unixODBC-${ODBC_VERSION}.tar.gz && \
    cd unixODBC-${ODBC_VERSION} && \
    ./configure --sysconfdir=${ODBCSYSINI} --disable-gui --disable-drivers --enable-iconv --with-iconv-char-enc=UTF8 --with-iconv-ucode-enc=UTF16LE --prefix=/usr && \
    make && \
    make install && \
    cp include/*.h /usr/include/ && \
    cp unixodbc_conf.h /usr/include/ && \
    cd .. && \
    rm -rf unixODBC-${ODBC_VERSION} unixODBC-${ODBC_VERSION}.tar.gz

WORKDIR /app
