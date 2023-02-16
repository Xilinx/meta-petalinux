python () {
    if d.getVar('WITHIN_PLNX_FLOW') and not d.getVar('SYSTEM_DTFILE'):
        sysconfig_dir = d.getVar('SYSCONFIG_DIR') or ''
        plnx_scriptspath = d.getVar('PLNX_SCRIPTS_PATH') or ''
        if sysconfig_dir:
            d.prependVar('FILESEXTRAPATHS', '%s:' % sysconfig_dir)
            d.appendVar('SRC_URI', ' file://config')
        if plnx_scriptspath:
            d.prependVar('FILESEXTRAPATHS', '%s:' % plnx_scriptspath)
            d.appendVar('SRC_URI', ' file://%s' % plnx_scriptspath)
        d.setVar('YAML_FILE_PATH', '${WORKDIR}/fsboot.yaml')
        d.appendVar('EXTRA_OEMAKE_APP', ' CFLAGS=-O3\ -DCONFIG_FS_BOOT_OFFSET=${boot_offset}')
}

HSM_OUTFILE = "${WORKDIR}/offsets"
do_configure:append () {
	if [ x"${WITHIN_PLNX_FLOW}" = x1 ] && [ -z "${SYSTEM_DTFILE}" ]; then
		touch ${HSM_OUTFILE}
		xsct_args="${WORKDIR}/${PLNX_SCRIPTS_PATH}/petalinux_hsm.tcl"
		xsct_args="${xsct_args} get_flash_width_parts ${WORKDIR}/config"
		xsct_args="${xsct_args} ${WORKDIR}/${PLNX_SCRIPTS_PATH}/data/ipinfo.yaml"
		xsct_args="${xsct_args} ${XSCTH_HDF} ${HSM_OUTFILE}"
		echo "cmd is: xsct -sdx -nodisp $xsct_args"
		xsct -sdx -nodisp $xsct_args
	fi
}

do_compile:prepend () {
	if [ x"${WITHIN_PLNX_FLOW}" = x1 ] && [ -z "${SYSTEM_DTFILE}" ]; then
		boot_offset=$(egrep -e "^boot=" "${HSM_OUTFILE}" | cut -d "=" -f 2 | cut -d " " -f 1)
	fi
}
