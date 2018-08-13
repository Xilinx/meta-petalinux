XEN_REL = "4.11"
XEN_BRANCH = "stable-${XEN_REL}"

BRANCH = ""
REPO = "git://github.com/Xilinx/xen.git;protocol=https"
SRCREV = "c227fe68589bdfb36b85f7b78c034a40c95b9a30"

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
