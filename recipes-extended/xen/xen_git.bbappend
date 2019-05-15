XEN_REL = "4.12"

BRANCH = "master"
REPO = "git://github.com/Xilinx/xen.git;protocol=https"
SRCREV = "997d6248a9ae932d0dbaac8d8755c2b15fec25dc"

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
