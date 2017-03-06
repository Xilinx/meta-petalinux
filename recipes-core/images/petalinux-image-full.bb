DESCRIPTION = "An image containing the full set of packages in the Petalinux distro."
LICENSE = "MIT"

require petalinux-image-common.inc

ZYNQ_FEATURES = " \
    dev-pkgs \
    package-management \
    ptest-pkgs \
    splash \
    tools-debug \
    tools-profile \
    tools-sdk \
    tools-testapps \
    petalinux-base \
    petalinux-self-hosted \
    petalinux-qt \
    petalinux-opencv \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'petalinux-x11', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'openamp', 'petalinux-openamp', '', d)} \
    "
IMAGE_FEATURES_append_zynq = " ${ZYNQ_FEATURES}"

ZYNQMP_FEATURES = " \
    petalinux-benchmarks \
    petalinux-gstreamer \
    petalinux-audio \
    ${@bb.utils.contains('DISTRO_FEATURES', 'xen', 'petalinux-xen', '', d)} \
    "
IMAGE_FEATURES_append_zynqmp = " ${ZYNQ_FEATURES} ${ZYNQMP_FEATURES}"
