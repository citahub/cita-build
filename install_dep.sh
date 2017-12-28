#!/usr/bash
set -e

sudo(){
    set -o noglob
    if [ "$(whoami)" == "root" ] ; then
        $*
    else
        /usr/bin/sudo -H $*
    fi
    set +o noglob
}

# add repositores
# add libsodium repository if using trusty version; only for travis trusty build environment.
if [ $(lsb_release -s -c) = "trusty" ]; then
    sudo add-apt-repository -y ppa:chris-lea/libsodium;
fi;

#  install add-apt-repository
sudo apt-get update -q
sudo apt-get install -y software-properties-common

if [ "dev" = "$1" ]; then
    #  install develop dependencies
    sudo apt-get install -y build-essential pkg-config rabbitmq-server python-pip curl jq  google-perftools capnproto wget git \
         libsnappy-dev libgoogle-perftools-dev libsodium* libzmq3-dev libssl-dev cmake libz3-dev libboost-all-dev

    # install rust&rustfmt
    # rust
    which cargo || (curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly-2017-12-05)
    . ${HOME}/.cargo/env

    # rustfmt
    cargo install --force --vers 0.2.17 rustfmt-nightly
else
    # 3) install runtime dependencies
    sudo apt-get install -y libstdc++6 rabbitmq-server libssl-dev libgoogle-perftools4 python-pip wget \
                        libsodium* libz3-dev cmake libz3-dev libboost-all-dev
fi

# install solc
chmod +x ./solc
sudo cp ./solc /usr/bin/solc

# install python package
umask 022
sudo pip install -U pip
sudo pip install ethereum==2.2.0 pysodium

# extra
sudo cp ./libgmssl.so.1.0.0 /usr/local/lib/
sudo ln -srf /usr/local/lib/libgmssl.so.1.0.0 /usr/local/lib/libgmssl.so
sudo ldconfig

# clean all cache
rm -rf /var/lib/apt/lists
rm -rf ~/.cache/pip
sudo apt-get autoclean
sudo apt-get autoremove
sudo apt-get clean
