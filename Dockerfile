FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    sudo \
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
    libsecp256k1-dev \
 && curl -o v35.tar.gz -L https://github.com/SimonKagstrom/kcov/archive/v35.tar.gz \
 && tar -xf v35.tar.gz && cd kcov-35 \
 && mkdir build && cd build \
 && cmake .. && make && make install \
 && cd ../.. \
 && rm -rf v35.tar.gz kcov-35 \
 && rm -rf /var/lib/apt/lists \
 && apt-get autoremove \
 && apt-get clean \
 && apt-get autoclean

ENV CARGO_HOME=/opt/.cargo
ENV RUSTUP_HOME=/opt/.rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly-2018-05-23

ENV PATH $PATH:/opt/.cargo/bin

RUN rustup component add rustfmt-preview --toolchain nightly-2018-05-23

RUN rustup self update

RUN pip3 install -U pip \
  && hash pip3 \
  && pip3 install pysodium toml jsonschema secp256k1 protobuf requests ecdsa \
  jsonrpcclient[requests]==2.4.2 \
  py_solc==3.0.0 \
  simplejson==3.11.1 \
  pathlib==1.0.1 \
  pysha3>=1.0.2 \
  && pip3 install git+https://github.com/ethereum/pyethereum.git@3d5ec14032cc471f4dcfc7cc5c947294daf85fe0 \
  && rm -r ~/.cache/pip

COPY solc /usr/bin/
RUN chmod +x /usr/bin/solc

COPY libgmssl.so.1.0.0 /usr/local/lib/
RUN ln -srf /usr/local/lib/libgmssl.so.1.0.0 /usr/local/lib/libgmssl.so
RUN ldconfig

# Link: https://denibertovic.com/posts/handling-permissions-with-docker-volumes/
COPY gosu /usr/bin/
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/gosu
RUN chmod +x /usr/bin/entrypoint.sh

WORKDIR /opt

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
