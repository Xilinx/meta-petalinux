DESCRIPTION = "Install script to help update kernel"
SUMMARY = "Install script to complete updating the kernel after doing a dnf install kernel"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "\
	file://updatekernel.sh \
	"

S = "${WORKDIR}"
B = "${WORKDIR}/build"

do_compile() {
    sed -e 's/@@KERNEL_IMAGETYPE@@/${KERNEL_IMAGETYPE}/g' \
        "${S}/updatekernel.sh" > "${B}/updatekernel"
}
do_install() {
	install -Dm 0755 ${B}/updatekernel ${D}${bindir}/updatekernel
}
