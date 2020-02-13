DESCRIPTION = "Debian packages for AVR toolchain"

SUMMARY = "AVR Libc is a Free Software project whose goal is to provide a high \
quality C library for use with GCC on Atmel AVR microcontrollers."

HOMEPAGE = "http://www.nongnu.org/avr-libc/"

SRC_URI = " \
    http://http.us.debian.org/debian/pool/main/g/gcc-avr/gcc-avr_5.4.0+Atmel3.6.1-2_arm64.deb;subdir=avrgcc;unpack=false;name=gcc-avr \
    http://http.us.debian.org/debian/pool/main/e/elfutils/libelf1_0.176-1.1_arm64.deb;subdir=avrgcc;unpack=false;name=libelf1 \
    http://http.us.debian.org/debian/pool/main/a/arduino-mk/arduino-mk_1.5.2-1_all.deb;subdir=avrgcc;unpack=false;name=arduino-mk \
    http://http.us.debian.org/debian/pool/main/b/binutils-avr/binutils-avr_2.26.20160125+Atmel3.6.1-4_arm64.deb;subdir=avrgcc;unpack=false;name=binutils-avr \
    http://http.us.debian.org/debian/pool/main/a/arduino/arduino-core_1.0.5+dfsg2-4.1_all.deb;subdir=avrgcc;unpack=false;name=arduino-core \
    http://http.us.debian.org/debian/pool/main/a/avr-libc/avr-libc_2.0.0%2BAtmel3.6.1-2_all.deb;subdir=avrgcc;unpack=false;name=avr-libc \
"

SRC_URI[avr-libc.md5sum] = "b37dc17b004e8cd217bda10e8f7baa53"
SRC_URI[avr-libc.sha256sum] = "7b7740a4544ffbf16cb4e6d81cd1ee8c21d7d05185d22b385949f7514412afba"

SRC_URI[gcc-avr.md5sum] = "a5a879f928a95d8e938b90a36f8c77e9"
SRC_URI[gcc-avr.sha256sum] = "7321cbcdaf3c2653a599e31690c8fa2ae0400de9264cdf0861f2d06afa122ae0"

SRC_URI[arduino-mk.md5sum] = "d675c5e5ba8c41e6453198e49e1cd1f3"
SRC_URI[arduino-mk.sha256sum] = "bfde5a2fc665d5369a2e6ca4abeb7a97552606c5a0dac31aeae5db15442875e9"

SRC_URI[binutils-avr.md5sum] = "e5856b043502b70c323ec8051a9a461d"
SRC_URI[binutils-avr.sha256sum] = "39d18e794c5484f5abe24fe1ddd2e64dc8814265fd3d631cbeb565518abcc5fb"

SRC_URI[libelf1.md5sum] = "a9244703eec4735e54108001cee4c408"
SRC_URI[libelf1.sha256sum] = "7c550a5eb057ec5c38f37e79eba476785e3a84097f7b740866db39012b99470f"

SRC_URI[arduino-core.md5sum] = "eaa903350b2425e876ac6b2b4310829e"
SRC_URI[arduino-core.sha256sum] = "0ffc074724358a3b08bd66580809ea80d6abee92fb0a8c10b5de4b6aca25e066"

DEPENDS =  "gmp libmpc mpfr zlib dpkg-native"
RDEPENDS_${PN} = "bash"

LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-2-Clause;md5=cb641bc04cda31daea161b1bc15da69f"

INSANE_SKIP_${PN} = "arch debug-files dev-so dev-deps ldflags staticdev already-stripped"

#install process is similar to bin_package.bbclass
# Skip the unwanted steps
do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    install -d ${D}${bindir}
    install -d ${D}${libdir}
    install -m 0755 -d ${D}${datadir}
    install -m 0755 -d ${D}${datadir}/arduino

    for deb in ${WORKDIR}/avrgcc/*.deb; do
        dpkg -x $deb ${WORKDIR}/avrgcc
        rm -f $deb
    done

    sed -i "s/done\ ;/done ;STTYF='stty -F';/" "${WORKDIR}/avrgcc/usr/share/arduino/Arduino.mk" 
    cp -a --no-preserve=ownership ${WORKDIR}/avrgcc/usr/* ${D}/${prefix}

}

FILES_${PN} += "/usr/*"
