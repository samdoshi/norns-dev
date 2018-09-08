FROM samdoshi/norns-dev:latest

RUN groupadd we -g 1000 && \
    useradd we -g 1000 -u 1000 -m -s /bin/bash

RUN apt-get update -q && \
    apt-get install -qy --no-install-recommends \
            python3-pip \
            python3-setuptools \
            python3-wheel \
            tmux && \
    pip3 install tmuxp

USER we
WORKDIR /home/we

RUN go get -d github.com/monome/maiden && \
    cd /home/we/go/src/github.com/monome/maiden && \
    glide install && \
    go build

RUN cd /home/we/go/src/github.com/monome/maiden/app && \
    yarn install && \
    yarn build

RUN mkdir -p /home/we/.local/share/SuperCollider/Extensions/norns && \
    git clone --depth=1 https://github.com/monome/norns.git && \
    git clone --depth=1 https://github.com/monome/dust.git

RUN cd /home/we/norns && \
    ./waf configure && \
    ./waf && \
    cd sc && \
    ./install.sh

COPY ["jackdrc", "/etc/jackdrc"]
COPY ["norns.yaml", "/home/we/.tmuxp/norns.yaml"]
COPY ["tmux.conf", "/home/we/.tmux.conf"]

CMD tmuxp load norns
