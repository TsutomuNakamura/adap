FROM tsutomu/docker-samba-ad
LABEL maintainer "Tsutomu Nakamura<tsuna.0x00@gmail.com>"

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install \
        curl ruby-full ruby-bundler \
    && gem update --system \
    && rm -rf /usr/share/rubygems-integration/all/specifications/rake-* \
    && apt-get clean

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

