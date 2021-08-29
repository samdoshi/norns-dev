#!/bin/sh

set -ex

GOLANG_VERSION=1.17
JACK2_VERSION=1.9.19
LIBMONOME_VERSION=1.4.4
NANOMSG_VERSION=1.1.5
SUPERCOLLIDER_VERSION=3.12.0
SUPERCOLLIDER_PLUGINS_VERSION=3.11.1

install_setup_apt() {
    apt-get update -q
    apt-get install -qy --no-install-recommends \
            apt-transport-https \
            apt-utils \
            ca-certificates \
            gnupg2
    apt-key add /tmp/install/nodesource.gpg.asc
    apt-key add /tmp/install/yarnpkg.gpg.asc
    cp /tmp/install/sources.list /etc/apt/sources.list.d/
}

install_packages() {
    apt-get update -yq
    apt-get dist-upgrade -yq
    apt-get install -qy --no-install-recommends \
            build-essential \
            bzip2 \
            cmake \
            curl \
            gdb \
            git \
            ladspalist \
            libasound2-dev \
            libavahi-client-dev \
            libavahi-compat-libdnssd-dev \
            libcwiid-dev \
            libcairo2-dev \
            libevdev-dev \
            libfftw3-dev \
            libicu-dev \
            liblo-dev \
            liblua5.1-dev \
            liblua5.3-dev \
            libreadline6-dev \
            libsndfile1-dev \
            libudev-dev \
            libxt-dev \
            luarocks \
            nodejs \
            pkg-config \
            python-dev \
            unzip \
            wget \
            yarn
}

install_clean_apt() {
    apt-get clean
    rm -rf /var/lib/apt/lists/*
}

install_jack2() {
    mkdir -p /tmp/jack2
    cd /tmp/jack2
    wget -q https://github.com/jackaudio/jack2/archive/v${1:-$JACK2_VERSION}.tar.gz -O jack2.tar.gz
    tar xvfz jack2.tar.gz
    cd jack2-${1:-$JACK2_VERSION}
    ./waf configure --classic --alsa=yes --firewire=no --iio=no --portaudio=no --prefix /usr
    ./waf
    ./waf install
    cd /
    rm -r /tmp/jack2
    ldconfig
}

install_supercollider() {
    mkdir -p /tmp/supercollider
    cd /tmp/supercollider
    wget -q https://github.com/supercollider/supercollider/releases/download/Version-${1:-$SUPERCOLLIDER_VERSION}/SuperCollider-${1:-$SUPERCOLLIDER_VERSION}-Source.tar.bz2 -O sc.tar.bz2
    tar xvf sc.tar.bz2
    cd /tmp/supercollider/SuperCollider-${1:-$SUPERCOLLIDER_VERSION}-Source
    mkdir -p build
    cd build
    cmake -DCMAKE_BUILD_TYPE="Release" \
          -DCMAKE_INSTALL_PREFIX=/usr/local \
          -DBUILD_TESTING=OFF \
          -DENABLE_TESTSUITE=OFF \
          -DNATIVE=OFF \
          -DINSTALL_HELP=OFF \
          -DSC_IDE=OFF \
          -DSC_QT=OFF \
          -DSC_ED=OFF \
          -DSC_EL=OFF \
          -DSUPERNOVA=ON \
          -DSC_VIM=OFF \
          ..
    make -j1
    make install
    cd /
    rm -r /tmp/supercollider
    ldconfig
}

install_sc3_plugins() {
    mkdir -p /tmp/sc3-plugins
    cd /tmp/sc3-plugins
    git clone --depth=1 --recursive --branch Version-${1:-$SUPERCOLLIDER_PLUGINS_VERSION} https://github.com/supercollider/sc3-plugins.git
    cd sc3-plugins
    mkdir -p build
    cd build
    cmake -DSC_PATH=/usr/local/include/SuperCollider \
          -DNATIVE=OFF \
          ..
    cmake --build . --config Release -- -j1
    cmake --build . --config Release --target install
    cd /
    rm -rf /tmp/sc3-plugins
    ldconfig
}

install_nanomsg() {
    mkdir -p /tmp/nanomsg
    cd /tmp/nanomsg
    wget -q https://github.com/nanomsg/nanomsg/archive/${1:-$NANOMSG_VERSION}.tar.gz -O nanomsg.tar.gz
    tar xvfz nanomsg.tar.gz
    cd nanomsg-${1:-$NANOMSG_VERSION}
    mkdir build
    cd build
    cmake ..
    cmake --build .
    cmake --build . --target install
    cd /
    rm -r /tmp/nanomsg
    ldconfig
}

install_libmonome() {
    mkdir -p /tmp/libmonome
    cd /tmp/libmonome
    wget -q https://github.com/monome/libmonome/archive/v${1:-$LIBMONOME_VERSION}.tar.gz -O libmonome.tar.gz
    tar xvfz libmonome.tar.gz
    cd libmonome-${1:-$LIBMONOME_VERSION}
    ./waf configure --disable-udev --disable-osc
    ./waf
    ./waf install
    cd /
    rm -r /tmp/libmonome
    ldconfig
}

install_go() {
    mkdir -p /tmp/go
    wget -q https://golang.org/dl/go${1:-$GOLANG_VERSION}.linux-amd64.tar.gz -O go.tar.gz
    tar -C /usr/local -xzf go.tar.gz
    cd /
    rm -r /tmp/go
}

install_ldoc() {
    luarocks install ldoc
}
