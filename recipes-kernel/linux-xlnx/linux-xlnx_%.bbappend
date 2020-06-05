PLNX_XEN_DEPLOY = "${@ 'image-xlnx-xen' if d.getVar('IMAGE_PLNX_XEN_DEPLOY') == '1' else '' }"
inherit deploy ${PLNX_XEN_DEPLOY}
