FROM ubuntu:20.04
LABEL maintainer="Rivtower Technologies <contact@rivtower.com>"

ENV DEBIAN_FRONTEND=noninteractive
# Ref:
#   + https://github.com/tianon/gosu/blob/master/INSTALL.md#from-debian
RUN set -eux \
 && apt-get update && apt-get install -y \
    automake \
    binutils-dev \
    build-essential \
    ca-certificates \
    clang \
    cmake \
    curl \
    git \
    google-perftools \
    gosu \
    jq \
    libcurl4-openssl-dev \
    libdw-dev \
    libffi-dev \
    libgmp-dev \
    libgoogle-perftools-dev \
    libiberty-dev \
    libsecp256k1-dev \
    libsnappy-dev \
    libsodium* \
    libssl-dev \
    libtool \
    libyaml-cpp-dev \
    libzmq3-dev \
    pkg-config \
    python3-pip \
    rabbitmq-server \
    sudo \
    zlib1g-dev \
 # verify that the binary works
 && gosu nobody true \
 && rm -rf /var/lib/apt/lists \
 && apt-get clean

ENV PATH $PATH:/opt/.cargo/bin
ENV CARGO_HOME=/opt/.cargo
ENV RUSTUP_HOME=/opt/.rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain 1.74.0

RUN pip3 install -U pip \
  && hash pip3 \
  && pip3 install pysodium toml jsonschema secp256k1 protobuf requests ecdsa ethereum \
  jsonrpcclient[requests]==2.4.2 \
  py_solc==3.0.0 \
  simplejson==3.11.1 \
  pathlib==1.0.1 \
  pysha3>=1.0.2 \
  bitcoin==1.1.42 \
  && rm -r ~/.cache/pip

RUN curl -o solc -L https://github.com/ethereum/solidity/releases/download/v0.4.24/solc-static-linux \
  && mv solc /usr/bin/ \
  && chmod +x /usr/bin/solc

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

WORKDIR /opt

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
