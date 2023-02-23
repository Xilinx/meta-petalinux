# gvim desktop application failed to launch in matchbox-desktop
# environment. This is due to givm binaries doesn't generate when you
# build vim recipes, hence remove gvim.desktop file.
# TODO: remove this file after https://bugzilla.yoctoproject.org/show_bug.cgi?id=15044 is fixed
do_install:append() {
    if [ -f ${D}${DESKTOPDIR}/gvim.desktop ]; then
        rm -f ${D}${DESKTOPDIR}/gvim.desktop
    fi
}
