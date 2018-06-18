DESCRIPTION = "Debian packages for AVR toolchain"

SUMMARY = "AVR Libc is a Free Software project whose goal is to provide a high \
quality C library for use with GCC on Atmel AVR microcontrollers."

HOMEPAGE = "http://www.nongnu.org/avr-libc/"

SRC_URI = " \
    http://http.us.debian.org/debian/pool/main/g/gcc-avr/gcc-avr_4.9.2+Atmel3.5.3-1_arm64.deb;subdir=avrgcc;unpack=false;name=gcc-avr \
    http://http.us.debian.org/debian/pool/main/e/elfutils/libelf1_0.168-1_arm64.deb;subdir=avrgcc;unpack=false;name=libelf1 \
    http://http.us.debian.org/debian/pool/main/a/arduino-mk/arduino-mk_1.5.2-1_all.deb;subdir=avrgcc;unpack=false;name=arduino-mk \
    http://http.us.debian.org/debian/pool/main/b/binutils-avr/binutils-avr_2.26.20160125+Atmel3.5.3-1_arm64.deb;subdir=avrgcc;unpack=false;name=binutils-avr \
    http://http.us.debian.org/debian/pool/main/a/arduino/arduino-core_1.0.5+dfsg2-4.1_all.deb;subdir=avrgcc;unpack=false;name=arduino-core \
    http://http.us.debian.org/debian/pool/main/a/avr-libc/avr-libc_1.8.0%2BAtmel3.5.0-1_all.deb;subdir=avrgcc;unpack=false;name=avr-libc \
"

SRC_URI[avr-libc.md5sum] = "99c34db66ac721c76c8ce7dfe3929eaf"
SRC_URI[avr-libc.sha256sum] = "f1a941e6cd5252a6d049ae28125d3c302e38358aa9390a2343681a299df22f70"

SRC_URI[gcc-avr.md5sum] = "54b529f7ea31e76e06e614f4e9741fd3"
SRC_URI[gcc-avr.sha256sum] = "9f39e38b3b14989478e2f0db5db61fda8fc47f24b5545b03ad0a833ff560a25d"

SRC_URI[arduino-mk.md5sum] = "d675c5e5ba8c41e6453198e49e1cd1f3"
SRC_URI[arduino-mk.sha256sum] = "bfde5a2fc665d5369a2e6ca4abeb7a97552606c5a0dac31aeae5db15442875e9"

SRC_URI[binutils-avr.md5sum] = "b1b4e41558e04916fed3810e72d253e0"
SRC_URI[binutils-avr.sha256sum] = "3a3a6ae2a04bc9dacb0bcc7f97aff9fb1a126c62d14931ca7cbb5be6200b4cf0"

SRC_URI[libelf1.md5sum] = "b12b36546be7a0d580f7cf38f73764c7"
SRC_URI[libelf1.sha256sum] = "b6c729dffaaf9f3a0f871ad9718eafc55a81cdcf5ec13c55b60f989d8d045ca2"

SRC_URI[arduino-core.md5sum] = "eaa903350b2425e876ac6b2b4310829e"
SRC_URI[arduino-core.sha256sum] = "0ffc074724358a3b08bd66580809ea80d6abee92fb0a8c10b5de4b6aca25e066"

DEPENDS =  "gmp libmpc mpfr zlib dpkg-native"
RDEPENDS_${PN} = "bash"

LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-2-Clause;md5=8bef8e6712b1be5aa76af1ebde9d6378"

INSANE_SKIP_${PN} = "arch debug-files dev-so dev-deps ldflags staticdev already-stripped"

#install process is similar to bin_package.bbclass
# Skip the unwanted steps
do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    install -d ${D}${bindir}
    install -d ${D}${libdir}
    install -d ${D}${datadir}
    install -d ${D}${datadir}/arduino

    for deb in ${WORKDIR}/avrgcc/*.deb; do
        dpkg -x $deb ${WORKDIR}/avrgcc
        rm -f $deb
    done

    sed -i "s/done\ ;/done ;STTYF='stty -F';/" "${WORKDIR}/avrgcc/usr/share/arduino/Arduino.mk" 
    cp -a --no-preserve=ownership ${WORKDIR}/avrgcc/usr/* ${D}/${prefix}

}

FILES_${PN} += "/usr/*"
