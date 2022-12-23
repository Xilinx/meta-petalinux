FILESEXTRAPATHS:prepend := "${@'${THISDIR}/files:' \
        if ((d.getVar('WITHIN_PLNX_FLOW') or '') != '' and \
        not d.getVar("SYSTEM_DTFILE")) else ''}"

python () {
    if d.getVar("CONFIG_DISABLE"):
        d.setVarFlag("do_configure", "noexec", "1")

    if d.getVar("WITHIN_PLNX_FLOW") and not d.getVar("SYSTEM_DTFILE"):
        d.appendVar('SRC_URI', ' file://config file://system-user.dtsi')
        sysconfig_dir = d.getVar('SYSCONFIG_DIR') or ''
        plnx_scriptspath = d.getVar('PLNX_SCRIPTS_PATH') or ''
        if sysconfig_dir:
            d.prependVar('FILESEXTRAPATHS', '%s:' % sysconfig_dir)
        if plnx_scriptspath:
            d.prependVar('FILESEXTRAPATHS', '%s:' % plnx_scriptspath)
            d.appendVar('SRC_URI', ' file://%s' % plnx_scriptspath)
}

do_configure:append () {
    if [ x"${WITHIN_PLNX_FLOW}" = x1 ] && [ -z "${SYSTEM_DTFILE}" ]; then
	    script=${WORKDIR}/${PLNX_SCRIPTS_PATH}/petalinux_hsm_bridge.tcl
	    data=${WORKDIR}/${PLNX_SCRIPTS_PATH}/data/
	    echo "cmd is xsct -sdx -nodisp ${script} -c ${WORKDIR}/config -hdf ${DT_FILES_PATH}/hardware_description.${HDF_EXT} -repo ${S} -data ${data} -sw ${DT_FILES_PATH} -o ${DT_FILES_PATH} -a "soc_mapping""
	    eval xsct -sdx -nodisp ${script} -c ${WORKDIR}/config \
	    -hdf ${DT_FILES_PATH}/hardware_description.${HDF_EXT} -repo ${S} \
	    -data ${data} -sw ${DT_FILES_PATH} -o ${DT_FILES_PATH} -a "soc_mapping"
    fi
}
