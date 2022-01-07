# Fix a bug in the upstream do_install
# Upstream do_install modified SBINDIR, should be SBIN_DIR

do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}; then
            sed -i "s,@SBIN_DIR@,${sbindir},g" ${D}${INIT_D_DIR}/haveged
        fi
    fi
}

