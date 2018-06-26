FROM cita/cita-build:ubuntu-18.04-20180523
LABEL maintainer="Cryptape Technologies <contact@cryptape.com>"

RUN curl -o solc -L https://github.com/ethereum/solidity/releases/download/v0.4.19/solc-static-linux \
  && mv solc /usr/bin/ \
  && chmod +x /usr/bin/solc

WORKDIR /opt

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
