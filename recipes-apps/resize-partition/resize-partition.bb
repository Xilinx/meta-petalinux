
DESCRIPTION = "Init script to extend the rootfs partition size \
		during runtime"

SUMMARY = "Init script to extend the rootfs partition size \
                during runtime \
                "

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://resize-partition.sh"

inherit update-rc.d

RDEPENDS:${PN} += "resize-part"

INSANE_SKIP:${PN} += "installed-vs-shipped"

INITSCRIPT_NAME = "resize-partition.sh"
INITSCRIPT_PARAMS = "start 99 S ."

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:zynqmp = "zynqmp"

do_install () {
    install -d ${D}${sysconfdir}/init.d/
    install -m 0755 ${WORKDIR}/resize-partition.sh ${D}${sysconfdir}/init.d/

    if [ "${INITRAMFS_IMAGE}" = "petalinux-initramfs-image" ]; then
        install -d ${D}/exec.d/
        install -m 0755 ${WORKDIR}/resize-partition.sh ${D}/exec.d/
    fi
}

FILES:${PN} = "${sysconfdir}/init.d/resize-partition.sh /exec.d/resize-partition.sh"

