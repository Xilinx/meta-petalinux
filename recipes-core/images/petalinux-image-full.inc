DESCRIPTION = "An image containing the full set of packages in the Petalinux distro."
LICENSE = "MIT"

require petalinux-image-common.inc

TRACING_PROFILE_FEATURES = "\
    tools-debug \
    tools-profile \
    tools-testapps \
    "

PLNX_COMMON_FEATURES = " \
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
    petalinux-jupyter \
    ${TRACING_PROFILE_FEATURES} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11 opengl', 'petalinux-self-hosted', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'petalinux-x11', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'petalinux-matchbox', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'openamp', 'petalinux-openamp', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'virtualization vmsep', 'petalinux-ocicontainers', '', d)} \
    "

PLNX_COMMON_FEATURES_append_aarch64 = " \
    petalinux-gstreamer \
    petalinux-audio \
    petalinux-mraa \
    petalinux-xrt \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'petalinux-multimedia', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'petalinux-weston', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'xen', 'petalinux-xen', '', d)} \
    "

ZYNQ_FEATURES = ""

ZYNQMP_FEATURES = " \
    petalinux-vitisai \
    "

ULTRA96_FEATURES = " \
    petalinux-96boards-sensors \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'petalinux-ultra96-webapp', '', d)} \ 
    "

VERSAL_FEATURES = ""

IMAGE_FEATURES_append_zynq = " ${PLNX_COMMON_FEATURES} ${ZYNQ_FEATURES}"

IMAGE_FEATURES_append_zynqmp = " ${PLNX_COMMON_FEATURES} ${ZYNQMP_FEATURES}"

IMAGE_FEATURES_append_ultra96 = " ${ULTRA96_FEATURES}"

IMAGE_FEATURES_append_versal = " ${PLNX_COMMON_FEATURES} ${VERSAL_FEATURES}"

IMAGE_FEATURES_append_microblaze = " ${TRACING_PROFILE_FEATURES}"

IMAGE_FSTYPES_remove = "cpio.gz cpio cpio.gz.u-boot cpio.bz2"

IMAGE_INSTALL_append = " haveged"
SDK_RDEPENDS_append_task-populate-sdk-ext = " nativesdk-packagegroup-sdk-host packagegroup-cross-canadian-${MACHINE}"

#Adding native packages depends
DEPENDS_append = " cpio-native wic-tools"
