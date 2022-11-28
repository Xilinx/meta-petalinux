python () {
    if d.getVar('WITHIN_PLNX_FLOW') and d.getVar('KERNEL_AUTO_CONFIG'):
        sysconfig_dir = d.getVar('SYSCONFIG_DIR') or ''
        if sysconfig_dir:
            d.prependVar('FILESEXTRAPATHS', '%s/linux-xlnx:' % sysconfig_dir)
            d.appendVar('SRC_URI', ' file://plnx_kernel.cfg')
}
