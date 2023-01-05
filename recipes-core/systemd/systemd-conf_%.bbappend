python () {
    if d.getVar('WITHIN_PLNX_FLOW') and d.getVar('SYSCONFIG_DIR'):
        d.prependVar('FILESEXTRAPATHS', '%s/systemd-conf:' % d.getVar('SYSCONFIG_DIR'))
}
