FROM golang:1.15-buster

RUN apt-get update && apt-get install -y \
  jq \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /go/src/github.com/bluzelle \
  && cd /go/src/github.com/bluzelle \
  && git clone https://github.com/bluzelle/curium.git \
  && cd curium && make testnet

# Smoke test
RUN blzcli version --long && blzd version --long

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["tail -f ${BLZ_PROC_STD_DESCRIPTORS}"]
