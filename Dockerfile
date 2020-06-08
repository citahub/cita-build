FROM ubuntu:18.04
LABEL maintainer="Rivtower Technologies <contact@rivtower.com>"

# Ref:
#   + https://github.com/tianon/gosu/blob/master/INSTALL.md#from-debian
# change source
RUN set -eux \
 && sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
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
    wget \
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
    libclang-dev \
    llvm \
    libc6-dev-i386 \
 # verify that the binary works
 && gosu nobody true \
 && curl -o v35.tar.gz -L https://github.com/SimonKagstrom/kcov/archive/v35.tar.gz \
 && tar -xf v35.tar.gz && cd kcov-35 \
 && mkdir build && cd build \
 && cmake .. && make && make install \
 && cd ../.. \
 && rm -rf v35.tar.gz kcov-35 \
 && rm -rf /var/lib/apt/lists \
 && apt-get clean

ENV PATH $PATH:/opt/.cargo/bin
ENV CARGO_HOME=/opt/.cargo
ENV RUSTUP_HOME=/opt/.rustup
RUN curl --proto '=https' https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable \
 && rustup component add rustfmt --toolchain stable \
 && rustup self update \
 && rustup component add clippy --toolchain stable

#COPY gcc-linaro-5.5.0-2017.10-x86_64_aarch64-linux-gnu /opt/gcc-linaro-5.5.0-2017.10-x86_64_aarch64-linux-gnu/
ENV PATH=/opt/gcc-linaro-5.5.0-2017.10-x86_64_aarch64-linux-gnu/bin:$PATH
# rust change source
RUN wget https://releases.linaro.org/components/toolchain/binaries/latest-5/aarch64-linux-gnu/gcc-linaro-5.5.0-2017.10-x86_64_aarch64-linux-gnu.tar.xz \
 && tar -xvf gcc-linaro-5.5.0-2017.10-x86_64_aarch64-linux-gnu.tar.xz \
 && mv gcc-linaro-5.5.0-2017.10-x86_64_aarch64-linux-gnu /opt/ \
 && rustup target add aarch64-unknown-linux-gnu \
 && wget http://mirror.archlinuxarm.org/aarch64/extra/snappy-1.1.8-1-aarch64.pkg.tar.xz \
 && tar Jxvf snappy-1.1.8-1-aarch64.pkg.tar.xz \
 && cp usr/lib/libsnappy.so /opt/gcc-linaro-5.5.0-2017.10-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/lib64/


COPY openssl /opt/openssl/
ENV OPENSSL_LIB_DIR=/opt/openssl
ENV OPENSSL_INCLUDE_DIR=/opt/openssl/include

RUN pip3 install -U pip \
  && hash pip3 \
  && pip3 install pysodium toml jsonschema secp256k1 protobuf requests ecdsa \
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
