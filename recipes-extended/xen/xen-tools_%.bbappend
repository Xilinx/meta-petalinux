require xen-xilinx.inc

# In a systemd or hybrid (both sysvinit and systemd) Xen is skipping
# installing the sysvinit initscripts.
# However, the meta-virtualization recipe we're based on is expecting the
# sysvinit components to exist during do_install processing.
do_install:prepend() {
    cd ${S}
    oe_runmake DESTDIR="${D}" install-tools

    if [ "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'systemd', '', d)}" = "systemd" ]; then
        install -m 0755 tools/hotplug/Linux/init.d/xendomains ${D}/etc/init.d/xendomains
        install -m 0755 tools/hotplug/Linux/init.d/xencommons ${D}/etc/init.d/xencommons
        install -m 0755 tools/hotplug/Linux/init.d/xendriverdomain ${D}/etc/init.d/xendriverdomain
        install -m 0755 tools/hotplug/Linux/init.d/xen-watchdog ${D}/etc/init.d/xen-watchdog
    fi
}

do_install:append () {
    if [ -e ${D}/usr/lib/xen/bin/pygrub ]; then
        sed -i -e '1c#!/usr/bin/env python3' ${D}/usr/lib/xen/bin/pygrub
    fi

    if [ "${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'sysvinit', '', d)}" != 'sysvinit' ]; then
        rm -f ${D}/etc/init.d/xendomains
        rm -f ${D}/etc/init.d/xencommons
        rm -f ${D}/etc/init.d/xendriverdomain
        rm -f ${D}/etc/init.d/xen-watchdog
    fi
}

# Additionally, if we're in a hybrid configuration, we want to stop the
# system from running any Xen sysvinit scripts
# This has a side effect of, on a hybrid system, if the init manager is
# sysvinit, the user will need to manually enable Xen.
INHIBIT_UPDATERCD_BBCLASS = "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '1', '', d)}"

FILES:${PN} += "${libdir}/xen/bin/init-dom0less \
    ${libdir}/xen/bin/get_overlay \
    ${libdir}/xen/bin/get_overlay.sh \
"
