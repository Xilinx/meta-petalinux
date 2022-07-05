FILESEXTRAPATHS:append: := ":${THISDIR}/files"

SRC_URI += "file://zcu106-xlnx-firmware-detect"

PACKAGE_ARCH:zcu106 = "${MACHINE_ARCH}"

# User a zcu106 specific version of the firmware detection script
do_install:append:zcu106 () {
	install -m 0755 ${WORKDIR}/zcu106-xlnx-firmware-detect ${D}${bindir}/xlnx-firmware-detect
}
