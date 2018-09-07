DESCRIPTION = "An image containing the full set of packages in the Petalinux distro."
LICENSE = "MIT"

require petalinux-image-common.inc

TRACING_PROFILE_FEATURES = "\
    tools-debug \
    tools-profile \
    tools-testapps \
    "

ZYNQ_FEATURES = " \
    petalinux-benchmarks \
    dev-pkgs \
    package-management \
    ptest-pkgs \
    splash \
    tools-sdk \
    petalinux-base \
    petalinux-qt \
    petalinux-opencv \
    petalinux-display-debug \
    petalinux-networking-debug \
    petalinux-networking-stack \
    petalinux-python-modules \
    petalinux-qt-extended \
    petalinux-utils \
    petalinux-v4lutils \
    petalinux-lmsensors \
    ${TRACING_PROFILE_FEATURES} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'petalinux-self-hosted', '', d)} \
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
    petalinux-ultra96-webapp \
    petalinux-96boards-sensors \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'petalinux-multimedia', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'petalinux-weston', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'xen', 'petalinux-xen', '', d)} \
    "
IMAGE_FEATURES_append_zynqmp = " ${ZYNQ_FEATURES} ${ZYNQMP_FEATURES}"

IMAGE_FEATURES_append_microblazeel = " ${TRACING_PROFILE_FEATURES}"

IMAGE_FSTYPES_remove = "cpio.gz cpio cpio.gz.u-boot cpio.bz2"
