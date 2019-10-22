XEN_REL = "4.11"
XEN_BRANCH = "stable-${XEN_REL}"

BRANCH = "xilinx/release-2019.2"
REPO = "git://github.com/Xilinx/xen.git;protocol=https"
SRCREV = "0bb0d1c1f59da1a0fbc8d3fea843434678bcd6d9"

RDEPENDS_${PN}-base_remove = "${PN}-blktap ${PN}-libblktapctl ${PN}-libvhd"

RRECOMMENDS_${PN}-base += "\
	${PN}-blktap \
	${PN}-libblktapctl \
	${PN}-libvhd \
	"

FILES_${PN}-libxentoolcore = "${libdir}/libxentoolcore.so.*"
FILES_${PN}-libxentoolcore-dev = " \
	${libdir}/libxentoolcore.so \
	${datadir}/pkgconfig/xentoolcore.pc \
	"

FILES_${PN}-misc += "\
	${sbindir}/xen-diag \
	"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"

SRC_URI = "${REPO};${BRANCHARG}"

require xen-xilinx.inc

DEFAULT_PREFERENCE = "+1"
