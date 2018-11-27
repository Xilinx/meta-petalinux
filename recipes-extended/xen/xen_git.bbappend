XEN_REL = "4.11"
XEN_BRANCH = "stable-${XEN_REL}"

BRANCH = ""
REPO = "git://github.com/Xilinx/xen.git;protocol=https"
SRCREV = "b2edf52680415daa9cb7db0d8999faca299cd13c"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"

SRC_URI = "${REPO};${BRANCHARG}"

require xen-xilinx.inc

RDEPENDS_${PN}-base_remove = "${PN}-blktap ${PN}-libblktapctl ${PN}-libvhd"

RRECOMMENDS_${PN}-base += "\
        ${PN}-blktap \
        ${PN}-libblktapctl \
        ${PN}-libvhd \
        "

PACKAGES += "\
        ${PN}-libxentoolcore \
        ${PN}-libxentoolcore-dev \
        "

FILES_${PN}-libxentoolcore = "${libdir}/libxentoolcore.so.*"
FILES_${PN}-libxentoolcore-dev = " \
        ${libdir}/libxentoolcore.so \
        ${datadir}/pkgconfig/xentoolcore.pc \
        "

FILES_${PN}-misc += "\
        ${sbindir}/xen-diag \
        "
DEFAULT_PREFERENCE = "+1"
