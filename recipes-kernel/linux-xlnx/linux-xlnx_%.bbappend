PLNX_XEN_DEPLOY = "${@ 'image-xlnx-xen' if d.getVar('IMAGE_PLNX_XEN_DEPLOY') == '1' else '' }"
inherit deploy ${PLNX_XEN_DEPLOY}
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI:append:aarch64 = " ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'file://uevent.cfg', '', d)}"

python() {
    initramfs = d.getVar('INITRAMFS_IMAGE') or ''
    xen_deploy = d.getVar('IMAGE_PLNX_XEN_DEPLOY') or ''
    if initramfs and xen_deploy:
        d.appendVarFlag('do_deploy', 'postfuncs', ' plnx_compile_image_builder')
}

DT_SEARCH_ARG="-name *.dtb"
