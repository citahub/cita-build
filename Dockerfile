FROM cita/cita-build:latest

RUN git clone https://github.com/cryptape/solidity.git \
&& cd solidity \
&& git checkout ubuntu-16 \
&& git submodule update --init --recursive \
&& ./scripts/install_ubuntu16_deps.sh \
&& ./scripts/build.sh

RUN cp /usr/local/bin/solc /usr/bin
RUN chmod +x /usr/bin/solc
