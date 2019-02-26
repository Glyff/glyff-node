FROM ubuntu:16.04

LABEL version="1.0"
LABEL maintainer="cmoore@glyff.io"
ENV PATH=/usr/lib/go-1.9/bin:$PATH
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --yes software-properties-common
RUN add-apt-repository ppa:ethereum/ethereum
RUN add-apt-repository -s ppa:ethereum/ethereum
RUN apt-get update && apt-get --yes build-dep geth
RUN apt-get install --yes build-essential cmake git libgmp3-dev libprocps4-dev python-markdown libboost-all-dev libssl-dev golang-1.9 curl

ADD . /glyff

WORKDIR /glyff

RUN make glyff

RUN curl -LO https://github.com/Glyff/glyff-sprout-params/releases/download/v0.2.0/glyff-keys.tar

RUN tar xf glyff-keys.tar ; rm glyff-keys.tar

EXPOSE 8545 8546 30303 30303/udp 30304/udp

ENTRYPOINT bash
