FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
    file://0001-libdrm-Update-drm-header-file-with-XV15-and-XV20.patch \
    file://0004-modetest-call-drmModeCrtcSetGamma-only-if-add_proper.patch \
    file://0005-modetest-Add-semiplanar-10bit-pattern-support-for-mo.patch \
    file://0006-modetest-fix-smpte-colour-pattern-issue-for-XV20-and.patch \
    file://0001-headers-Sync-with-HDR-from-v5.4.patch \
	"
