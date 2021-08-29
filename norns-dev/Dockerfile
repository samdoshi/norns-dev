FROM debian:10.10

ENV LANG=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive \
    PATH="/usr/local/go/bin:$PATH"

ADD install.sh \
    install-lib.sh \
    nodesource.gpg.asc \
    sources.list \
    yarnpkg.gpg.asc \
    /tmp/install/

RUN /tmp/install/install.sh

CMD bash
