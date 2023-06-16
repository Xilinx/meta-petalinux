FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI:append = " file://platform-top.h"

python () {
    soc_family = d.getVar('SOC_FAMILY')
    tune_features = (d.getVar('TUNE_FEATURES') or []).split()
    if 'microblaze' in tune_features:
        soc_family = 'microblaze'
    if d.getVar('WITHIN_PLNX_FLOW'):
        if (soc_family == 'microblaze' and d.getVar('U_BOOT_AUTO_CONFIG')) or soc_family != 'microblaze':
            sysconfig_dir = d.getVar('SYSCONFIG_DIR') or ''
            if sysconfig_dir:
                d.prependVar('FILESEXTRAPATHS', '%s/u-boot-xlnx:' % sysconfig_dir)
                if os.path.exists(os.path.join(sysconfig_dir, 'u-boot-xlnx', 'config.cfg')):
                    d.appendVar('SRC_URI', ' file://config.cfg')
}

do_configure:append () {
	if [ x"${WITHIN_PLNX_FLOW}" = x1 ]; then
                install ${WORKDIR}/platform-top.h ${S}/include/configs/
	fi
}
