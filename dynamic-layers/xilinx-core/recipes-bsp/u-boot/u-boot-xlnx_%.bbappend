FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI:append = " file://platform-top.h"

python () {
    if d.getVar('WITHIN_PLNX_FLOW') and d.getVar('U_BOOT_AUTO_CONFIG'):
        sysconfig_dir = d.getVar('SYSCONFIG_DIR') or ''
        if sysconfig_dir:
            d.prependVar('FILESEXTRAPATHS', '%s/u-boot-xlnx:' % sysconfig_dir)
            d.appendVar('SRC_URI', ' file://config.mk file://config.cfg')
}

do_configure:append () {
	if [ x"${WITHIN_PLNX_FLOW}" = x1 ]; then
                install ${WORKDIR}/platform-top.h ${S}/include/configs/
		if [ x"${U_BOOT_AUTO_CONFIG}" = x1 ]; then
			install -d ${B}/source/board/xilinx/microblaze-generic/
			install ${WORKDIR}/config.mk ${B}/source/board/xilinx/microblaze-generic/
		fi
	fi
}
