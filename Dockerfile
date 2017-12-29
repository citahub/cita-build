FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
    pkg-config \
    rabbitmq-server \
    python-pip \
    curl \
    jq \
    google-perftools \
    capnproto \
    git \
    libsnappy-dev \
    libgoogle-perftools-dev \
    libsodium* \
    libzmq3-dev \
    libssl-dev \
 && rm -rf /var/lib/apt/lists \
 && rm -rf ~/.cache/pip


RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly-2017-12-05

ENV PATH $PATH:/root/.cargo/bin

RUN cargo install --force --vers 0.2.17 rustfmt-nightly


COPY solc /usr/bin/
RUN chmod +x /usr/bin/solc

RUN pip install -U pip
RUN pip install ethereum==2.2.0 pysodium


COPY libgmssl.so.1.0.0 /usr/local/lib/
RUN ln -srf /usr/local/lib/libgmssl.so.1.0.0 /usr/local/lib/libgmssl.so
RUN ldconfig
