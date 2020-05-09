Understanding the toolchain Makefile
====================================

For a general description see the README file from <https://github.com/pfalcon/esp-open-sdk/>. I made these notes while i'm learning how the toolchain works. Maybe it's useful for other people.

Using the ESP8266 Non-OS SDK
----------------------------

The used SDK is an outdated version cloned from github (commit 61248df5f6, 2017-11-03).

Some modifications are made on the original SDK files:

* Introduce a version header
* Use standard header files stdint and stdbool instead of (re-)defining types (avoid redefining types with C99)
* Add all binaries from libcrypto.a to libwpa.a (to avoid using libcrypt.a?)
* Add (compiled) user_rf_cal_sector_set to libmain.a (needs to be done for each application using the SDK)

```bash
echo -e "#undef ESP_SDK_VERSION\n#define ESP_SDK_VERSION 020100" >>$(VENDOR_SDK_DIR)/include/esp_sdk_ver.h
$(PATCH) -d $(VENDOR_SDK_DIR) -p1 < c_types-c99_sdk_2.patch
cd $(VENDOR_SDK_DIR)/lib; mkdir -p tmp; cd tmp; $(TOOLCHAIN)/bin/xtensa-lx106-elf-ar x ../libcrypto.a; cd ..; $(TOOLCHAIN)/bin/xtensa-lx106-elf-ar rs libwpa.a tmp/*.o
$(TOOLCHAIN)/bin/xtensa-lx106-elf-ar r $(VENDOR_SDK_DIR)/lib/libmain.a user_rf_cal_sector_set.o
```

TCP/IP Implementation
---------------------

The core SDK uses a forked version of a very old (1.4.0-rc2?) lwIP release for TCP/IP:

* third-party/include/lwip
* third-party/include/lwipopts.h
* third-party/lwip
* lib/liblwip.a

For some reasons, this implementation was forked by pfalcon (<https://github.com/pfalcon/esp-open-lwip>). The original library may be found here: <http://git.savannah.nongnu.org/cgit/lwip.git>.

Changes to crosstool-NG
-----------------------

Building crosstool-NG using commit 37b07f6 (2017-01-13) and gcc 4.8.5 patched with 1000-mforce-l32.patch.

```bash
./bootstrap
./configure --prefix=`pwd`
$(MAKE) MAKELEVEL=0
$(MAKE) install MAKELEVEL=0

cp -f 1000-mforce-l32.patch crosstool-NG/local-patches/gcc/4.8.5/
./ct-ng xtensa-lx106-elf
sed -r -i.org s%CT_PREFIX_DIR=.*%CT_PREFIX_DIR="$(TOOLCHAIN)"% .config
sed -r -i s%CT_INSTALL_DIR_RO=y%"#"CT_INSTALL_DIR_RO=y% .config
cat ../crosstool-config-overrides >> .config
./ct-ng build
```

Misc (not related to micropython?)
----------------------------------

* libhal.a (project lx106-hal) is not used in micropython. Later introduced on the SDK with commit d4ef61a.
* libcirom.a (renaming .text to .irom0.text in libc.a section) not used in micropython.
