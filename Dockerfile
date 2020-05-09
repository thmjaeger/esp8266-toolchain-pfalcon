FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
  ncurses-dev libtool-bin gawk help2man texinfo flex bison libexpat-dev \
  gperf autoconf automake build-essential git wget unzip python python-dev \
  && rm -rf /var/lib/apt/lists/*

# crosstool-NG will not run under root...
RUN groupadd toolchain \
  && useradd -g toolchain -m -s /bin/bash toolchain \ 
  && mkdir /toolchain \
  && chown -R toolchain:toolchain /toolchain

USER toolchain

RUN cd /toolchain \
  && git clone --recursive https://github.com/pfalcon/esp-open-sdk \
  && cd esp-open-sdk \
  && make \
  && rm /toolchain/esp-open-sdk/xtensa-lx106-elf/build.log.bz2

FROM ubuntu:18.04

COPY --from=0 /toolchain/esp-open-sdk/xtensa-lx106-elf /usr/lib/gcc-cross/xtensa-lx106-elf

RUN apt-get update && apt-get install -y \
  python python-serial \
  && rm -rf /var/lib/apt/lists/* \
  && chown -R 0:0 /usr/lib/gcc-cross/xtensa-lx106-elf
