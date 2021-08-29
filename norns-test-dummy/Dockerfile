FROM samdoshi/norns-dev:latest

# Using commit hashes instead of releases because there are
# unreleased fixes to allow things to run in docker.
ENV NORNS_TAG=c52a6bb52931444880c4aea132602cae8f506728 \
    NORNS_REPO=https://github.com/monome/norns.git \
    MAIDEN_TAG=1daf030c2c81b8d8fadadda22e1de5d1ec1381f1 \
    MAIDEN_REPO=https://github.com/monome/maiden.git

RUN groupadd we -g 1000 && \
    useradd we -g 1000 -u 1000 -m -s /bin/bash

RUN apt-get update -q && \
    apt-get install -qy --no-install-recommends \
            python3-pip \
            python3-setuptools \
            python3-wheel \
            tmux \
            vim \
            libboost-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install tmuxp==1.4.0

USER we
WORKDIR /home/we

# MAIDEN - build release then install it.
RUN git clone $MAIDEN_REPO maiden_src && \
    cd maiden_src && \
    git checkout $MAIDEN_TAG && \
    make release-local && \
    tar -xvf dist/maiden.tgz -C /home/we && \
    /home/we/maiden/project-setup.sh

# DUST - maiden data directory.
RUN /home/we/maiden/project-setup.sh && \
    mkdir -p dust/code && \
    cd dust/code && \
    # TODO: More scripts - which ones??
    git clone https://github.com/tehn/awake.git

# MATRON (Norns)
RUN git clone $NORNS_REPO && \
    cd /home/we/norns && \
    git checkout $NORNS_TAG && \
    git submodule update --init --recursive && \
    ./waf configure && \
    ./waf

# Install SuperCollider extensions
RUN mkdir -p /home/we/.local/share/SuperCollider/Extensions/norns && \
    cd /home/we/norns/sc && \
    ./install.sh && \
    # TODO: PR: add 'echo | sclang' to 'install.sh'
    echo | sclang

COPY ["jackdrc", "/etc/jackdrc"]
COPY ["norns.yaml", "/home/we/.tmuxp/norns.yaml"]
COPY ["tmux.conf", "/home/we/.tmux.conf"]

CMD tmuxp load norns
