FROM ubuntu:16.04

COPY solc /usr/bin/
COPY libgmssl.so.1.0.0 /usr/local/lib/

RUN apt-get update \
    && apt-get install -y \
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
    && chmod +x /usr/bin/solc \
    && ln -srf /usr/local/lib/libgmssl.so.1.0.0 /usr/local/lib/libgmssl.so \
    && ldconfig \
    && pip install -U pip ethereum==2.2.0 pysodium toml \
    && rm -rf /var/lib/apt/lists \
    && rm -rf ~/.cache/pip \
    && apt-get autoremove \
    && apt-get clean \
    && apt-get autoclean

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly-2017-12-05
ENV PATH $PATH:/root/.cargo/bin
RUN cargo install --force --vers 0.3.0 rustfmt-nightly