#
# This recipe is used to resize SD card partition.
#

SUMMARY = "Resize sd card partition application"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
	file://resize-part \
"

S = "${WORKDIR}"

INSANE_SKIP:${PN} += "installed-vs-shipped"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

RDEPENDS:${PN} = "parted e2fsprogs-resize2fs"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:zynq = "zynq"
COMPATIBLE_MACHINE:zynqmp = "zynqmp"
COMPATIBLE_MACHINE:versal = "versal"


do_install() {
	install -d ${D}/${bindir}
	install -d ${D}/${datadir}/resize_fs
	install -m 0755 ${S}/resize-part ${D}/${datadir}/resize_fs
	ln -sf -r ${D}${datadir}/resize_fs/resize-part ${D}/${bindir}/resize-part
}

FILES:${PN} += "${datadir}/*"
