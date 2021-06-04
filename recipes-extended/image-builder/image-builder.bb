SUMMARY = "Xen Image Builder"
SECTION = "xen"
LICENSE = "MIT"

DEPENDS += "u-boot-mkimage-native"
inherit deploy

RDEPENDS_${PN} += "bash"

LIC_FILES_CHKSUM = "file://LICENSE;md5=d2794c0df5b907fdace235a619d80314"
SRC_URI = "git://github.com/Xilinx/imagebuilder.git;protocol=https"
BRANCH ??= "master"
SRCREV ??= "7760210b3c0e4ac29b7a7e5e2daba86f34ca79c2"
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

do_deploy_class-native() {
	install -d ${DEPLOYDIR}
	install -m 0755 ${S}/scripts/uboot-script-gen ${DEPLOYDIR}/
}

addtask do_deploy after do_install

BBCLASSEXTEND = "native nativesdk"
