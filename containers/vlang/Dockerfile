FROM thevlang/vlang:buster-dev

ARG VLANG_UID

RUN apt-get update \
    && apt-get --no-install-recommends -y install sudo \
    && useradd -m -u "$VLANG_UID" vlang \
    && chown -R vlang:vlang /opt/vlang

USER vlang
