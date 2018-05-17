FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    pkg-config \
    rabbitmq-server \
    python3-pip \
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
    binutils-dev \
    libcurl4-openssl-dev \
    zlib1g-dev \
    libdw-dev \
    libiberty-dev \
    cmake \
    build-essential \
    automake \
    libtool \
    libffi-dev \
    libgmp-dev \
    libyaml-cpp-dev \
 && curl -o v35.tar.gz -L https://github.com/SimonKagstrom/kcov/archive/v35.tar.gz \
 && tar -xf v35.tar.gz && cd kcov-35 \
 && mkdir build && cd build \
 && cmake .. && make && make install \
 && cd ../.. \
 && rm -rf v35.tar.gz kcov-35 \
 && rm -rf /var/lib/apt/lists \
 && rm -rf ~/.cache/pip

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly-2018-05-14

ENV PATH $PATH:/root/.cargo/bin

RUN cargo install --force --vers 0.7.0 rustfmt-nightly

RUN pip3 install -U pip
RUN pip3 install pysodium toml
RUN git clone https://github.com/ethereum/pyethereum/
WORKDIR /pyethereum
RUN python3 setup.py install

COPY solc /usr/bin/
RUN chmod +x /usr/bin/solc

COPY libgmssl.so.1.0.0 /usr/local/lib/
RUN ln -srf /usr/local/lib/libgmssl.so.1.0.0 /usr/local/lib/libgmssl.so
RUN ldconfig