FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI:append = " file://platform-top.h"

# Include plnx cfg if plnx flow and U_BOOT_AUTO_CONFIG is set
INCLUDE_PLNX_UCFG ?= "${@'1' if d.getVar('WITHIN_PLNX_FLOW') and d.getVar('U_BOOT_AUTO_CONFIG') else ''}"
# Include SYSCONFIG_DIR
PLNX_SYSCONFIG_UDIR ?= "${@'%s/u-boot-xlnx' % d.getVar('SYSCONFIG_DIR') if d.getVar('SYSCONFIG_DIR') else ''}"

FILESEXTRAPATHS:prepend := "${@'${PLNX_SYSCONFIG_UDIR}:' if d.getVar('INCLUDE_PLNX_UCFG') and d.getVar('PLNX_SYSCONFIG_UDIR') else ''}"
SRC_URI += "${@'file://config.cfg' if d.getVar('INCLUDE_PLNX_UCFG') and d.getVar('PLNX_SYSCONFIG_UDIR') else ''}"

do_configure:append () {
	if [ x"${WITHIN_PLNX_FLOW}" = x1 ]; then
                install ${WORKDIR}/platform-top.h ${S}/include/configs/
	fi
}
