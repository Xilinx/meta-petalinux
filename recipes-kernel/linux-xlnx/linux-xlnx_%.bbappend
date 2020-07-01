PLNX_XEN_DEPLOY = "${@ 'image-xlnx-xen' if d.getVar('IMAGE_PLNX_XEN_DEPLOY') == '1' else '' }"
inherit deploy ${PLNX_XEN_DEPLOY}

python() {
    initramfs = d.getVar('INITRAMFS_IMAGE') or ''
    xen_deploy = d.getVar('IMAGE_PLNX_XEN_DEPLOY') or ''
    if initramfs and xen_deploy:
        d.appendVarFlag('do_deploy', 'postfuncs', ' plnx_compile_image_builder')
}
