FROM samdoshi/norns-dev:latest

ENV NORNS_TAG=v1.0.3 \
    MAIDEN_TAG=v0.9.3 \
    DUST_TAG=9a28abbd1abc8520337e8858d882bf8eebb01463

RUN groupadd we -g 1000 && \
    useradd we -g 1000 -u 1000 -m -s /bin/bash

RUN apt-get update -q && \
    apt-get install -qy --no-install-recommends \
            python3-pip \
            python3-setuptools \
            python3-wheel \
            tmux && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install tmuxp==1.4.0

USER we
WORKDIR /home/we

RUN go get -d github.com/monome/maiden && \
    cd /home/we/go/src/github.com/monome/maiden && \
    git checkout $MAIDEN_TAG && \
    glide install && \
    go build

RUN cd /home/we/go/src/github.com/monome/maiden/app && \
    yarn install && \
    yarn build

RUN mkdir -p /home/we/.local/share/SuperCollider/Extensions/norns && \
    git clone --branch=$NORNS_TAG --depth=1 https://github.com/monome/norns.git && \
    git clone https://github.com/monome/dust.git && \
    cd /home/we/dust && \
    git checkout $DUST_TAG

RUN cd /home/we/norns && \
    ./waf configure && \
    ./waf && \
    cd sc && \
    ./install.sh

COPY ["jackdrc", "/etc/jackdrc"]
COPY ["norns.yaml", "/home/we/.tmuxp/norns.yaml"]
COPY ["tmux.conf", "/home/we/.tmux.conf"]

CMD tmuxp load norns
