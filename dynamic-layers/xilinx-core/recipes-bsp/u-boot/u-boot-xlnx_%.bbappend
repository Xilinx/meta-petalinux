FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI:append = " file://platform-top-zynq.h \
	file://platform-top-microblaze.h \
	file://platform-top-zynqmp.h \
	file://platform-top-versal.h \
	"

python () {
    if d.getVar('WITHIN_PLNX_FLOW') and d.getVar('U_BOOT_AUTO_CONFIG'):
        sysconfig_dir = d.getVar('SYSCONFIG_DIR') or ''
        if sysconfig_dir:
            d.prependVar('FILESEXTRAPATHS', '%s/u-boot-xlnx:' % sysconfig_dir)
            d.appendVar('SRC_URI', ' file://config.mk file://config.cfg file://platform-auto.h')
}

do_configure:append () {
	if [ x"${WITHIN_PLNX_FLOW}" = x1 ]; then
		if echo ${TUNE_FEATURES} | grep -w microblaze > /dev/null; then
			install ${WORKDIR}/platform-top-microblaze.h ${S}/include/configs/platform-top.h
		else
			install ${WORKDIR}/platform-top-${SOC_FAMILY}.h ${S}/include/configs/platform-top.h
		fi
		if [ x"${U_BOOT_AUTO_CONFIG}" = x1 ]; then
			install -d ${B}/source/board/xilinx/microblaze-generic/
			install ${WORKDIR}/config.mk ${B}/source/board/xilinx/microblaze-generic/
			install ${WORKDIR}/platform-auto.h ${S}/include/configs/
		fi
	fi
}
