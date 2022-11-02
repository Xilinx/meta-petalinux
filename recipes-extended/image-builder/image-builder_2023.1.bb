
SUMMARY = "Xen Image Builder"
SECTION = "xen"
LICENSE = "MIT"

DEPENDS += "u-boot-mkimage-native"
inherit deploy

RDEPENDS:${PN} += "bash"

LIC_FILES_CHKSUM = "file://LICENSE;md5=d2794c0df5b907fdace235a619d80314"
SRC_URI = "git://github.com/Xilinx/imagebuilder.git;protocol=https;branch=${BRANCH}"
BRANCH ??= "xlnx_rel_v2022.2"
SRCREV ??= "8934dc43c2ab835a1a291fbb4140abe6276ec0cb"
S = "${WORKDIR}/git"

do_install () {
	install -d ${D}${bindir}
	chmod -R 777 ${S}/scripts/*
	install -m 0755 ${S}/scripts/* ${D}${bindir}
	ln -sf ${D}${bindir}/uboot-script-gen uboot-script-gen
}

do_deploy() {
	:
}

do_deploy:class-native() {
	install -d ${DEPLOYDIR}
	install -m 0755 ${S}/scripts/uboot-script-gen ${DEPLOYDIR}/
}

addtask do_deploy after do_install

BBCLASSEXTEND = "native nativesdk"
