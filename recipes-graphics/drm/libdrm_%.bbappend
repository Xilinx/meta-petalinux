FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
    file://0001-libdrm-Update-drm-header-file-with-XV15-and-XV20.patch \
    file://0002-modetest-Add-support-for-setting-mode-having-floatin.patch \
    file://0003-modetest-Use-floating-vrefresh-while-dumping-mode.patch \
    file://0004-modetest-call-drmModeCrtcSetGamma-only-if-add_proper.patch \
    file://0005-modetest-Add-semiplanar-10bit-pattern-support-for-mo.patch \
	"
