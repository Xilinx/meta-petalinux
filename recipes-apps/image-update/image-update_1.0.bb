DESCRIPTION = "Image update is used to update alternate image on SOM."
SUMMARY = "Image update is used to update alternate image on SOM. \
	If the current image is ImageA, ImageB will get updated and vice versa. \
	Usage: image_update <Input Image File>"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/LICENSES/MIT;md5=2ac09a7a37dd6ee0ba23ce497d57d09b"

SRC_URI = "git://github.com/Xilinx/linux-image_update.git;protocol=https"
SRCREV = "7db14999deca6b0524db01d04d80c0fae287a9ae"

RDEPENDS_${PN} += "fru-print"

S = "${WORKDIR}/git"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp = "zynqmp"

do_install () {
    install -d ${D}${bindir}
    install -m 0755 ${S}/image_update ${D}${bindir}/
}

INSANE_SKIP_${PN} = "ldflags"

