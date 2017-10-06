DESCRIPTION = "An image containing the full set of packages in the Petalinux distro."
LICENSE = "MIT"

require petalinux-image-common.inc

TRACING_PROFILE_FEATURES = "\
    tools-debug \
    tools-profile \
    tools-testapps \
"

ZYNQ_FEATURES = " \
    dev-pkgs \
    package-management \
    ptest-pkgs \
    splash \
    tools-sdk \
    petalinux-base \
    petalinux-self-hosted \
    petalinux-qt \
    petalinux-opencv \
    ${TRACING_PROFILE_FEATURES} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'petalinux-x11', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'petalinux-matchbox', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'petalinux-xfce', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'openamp', 'petalinux-openamp', '', d)} \
    "

IMAGE_FEATURES_append_zynq = " ${ZYNQ_FEATURES}"

ZYNQMP_FEATURES = " \
    petalinux-benchmarks \
    petalinux-gstreamer \
    petalinux-audio \
    petalinux-mraa \
    ${@bb.utils.contains('DISTRO_FEATURES', 'xen', 'petalinux-xen', '', d)} \
    "
IMAGE_FEATURES_append_zynqmp = " ${ZYNQ_FEATURES} ${ZYNQMP_FEATURES}"

IMAGE_FEATURES_append_microblazeel = " ${TRACING_PROFILE_FEATURES}"

IMAGE_FSTYPES_remove = "cpio.gz cpio cpio.gz.u-boot"
