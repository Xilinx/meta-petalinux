DESCRIPTION = "Image update is used to update alternate image on SOM."
SUMMARY = "Image update is used to update alternate image on SOM. \
	If the current image is ImageA, ImageB will get updated and vice versa. \
	Usage: image_update <Input Image File>"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/LICENSES/MIT;md5=2ac09a7a37dd6ee0ba23ce497d57d09b"

BRANCH = "xlnx_rel_v2021.2"
SRC_URI = "git://github.com/Xilinx/linux-image_update.git;branch=${BRANCH};protocol=https"
SRCREV = "b19467ac98921cea15c8650ceb43e89b239c4653"

RDEPENDS_${PN} += "fru-print"

S = "${WORKDIR}/git"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp = "zynqmp"

PACKAGE_ARCH_zynqmp = "${SOC_FAMILY_ARCH}"

# Force the make system to use the flags we want!
EXTRA_OEMAKE = 'CC="${CC} ${TARGET_CFLAGS} ${TARGET_LDFLAGS}" all'

do_install () {
    install -d ${D}${bindir}
    install -m 0755 ${S}/image_update ${D}${bindir}/
}
