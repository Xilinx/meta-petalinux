DESCRIPTION = "Firmware files for use with TI wl18xx"
LICENSE = "TI-TSPA"
LIC_FILES_CHKSUM = "file://LICENCE;md5=4977a0fe767ee17765ae63c435a32a9e"

SRC_URI = " \
	git://git.ti.com/wilink8-wlan/wl18xx_fw.git;protocol=git;branch=${BRANCH} \
	https://git.ti.com/ti-bt/service-packs/blobs/raw/5f73abe7c03631bb2596af27e41a94abcc70b009/initscripts/TIInit_11.8.32.bts;name=TIInit_11.8.32 \
	file://0001-Add-Makefile-to-install-firmware-files.patch \
	file://wl18xx.sh \
"

inherit update-rc.d

INITSCRIPT_NAME = "wl18xx.sh"
INITSCRIPT_PARAMS = "start 99 S ."

SRC_URI[TIInit_11.8.32.md5sum] = "a76788680905c30979038f9e6aa407f3"
SRC_URI[TIInit_11.8.32.sha256sum] = "26ab0608e39fab95a6a55070c2f8364c92aad34442e8349abda71cee4da3277a"

# Tag: R8.7-SP1 (8.7.1)
SRCREV = "fe3909e93d15a4b17e43699dde2bba0e9a3c0abc"
BRANCH = "master"

S = "${WORKDIR}/git"

CLEANBROKEN = "1"

do_compile() {
    :
}

do_install() {
    oe_runmake 'DEST_DIR=${D}' install
	cp ${WORKDIR}/TIInit_11.8.32.bts ${D}/lib/firmware/ti-connectivity/
	install -d ${D}${sysconfdir}/init.d
	install -m 0755 ${WORKDIR}/wl18xx.sh ${D}${sysconfdir}/init.d/wl18xx.sh
}

FILES_${PN} = "/lib/firmware/ti-connectivity/* ${sysconfdir}/*"
