esp8266-toolchain-pfalcon
=========================

The esp8266-toolchain docker container is a little helper to setup an esp toolchain based on the
esp-open-sdk build projekt of Paul Sokolovsky (<https://github.com/pfalcon/esp-open-sdk/).> It's
mainly used to build micropython/pycopy. It's based on the following Frameworks/Toolkits:

* Build script - <https://github.com/pfalcon/esp-open-sdk>
* crosstool-NG Crosscompiler Toolkit - <https://github.com/jcmvbkbc/crosstool-NG>
* Hardware Abstraction Library for Xtensa LX106 - <https://github.com/tommie/lx106-hal>
* lwIP TCP/IP Implementation - <https://github.com/pfalcon/esp-open-lwip>
* ESP8266 Non-OS SDK - <https://github.com/espressif/ESP8266_NONOS_SDK>
* ESP Tool - <https://github.com/espressif/esptool>

Building this container should work as usual with

```bash
docker build -t esp8266-toolchain-pfalcon .
```

Be patient: The build takes about 20 minutes to compile (at least on my Mac).

Using the toolchain
-------------------

Simply run the container:

```bash
docker run -it esp8266-toolchain-pfalcon
```

Than, inside the container, you can set the path to the toolchain and use it:

```bash
export PATH=/usr/lib/gcc-cross/xtensa-lx106-elf/bin:$PATH
xtensa-lx106-elf-gcc --version
```

License
-------

The project files in this directory are licensed under the Apache License, Version 2.0. Please note, that many of the downloaded files have their own terms and license conditions.
