DESCRIPTION = "An image containing the full set of packages in the Petalinux distro."
LICENSE = "MIT"

require petalinux-image-common.inc

TRACING_PROFILE_FEATURES = "\
    tools-debug \
    tools-profile \
    tools-testapps \
    "

PLNX_COMMON_FEATURES = " \
    dev-pkgs \
    package-management \
    ptest-pkgs \
    splash \
    tools-sdk \
    petalinux-base \
    petalinux-opencv \
    petalinux-display-debug \
    petalinux-networking-debug \
    petalinux-networking-stack \
    petalinux-python-modules \
    petalinux-utils \
    petalinux-v4lutils \
    petalinux-lmsensors \
    petalinux-benchmarks \
    petalinux-jupyter \
    ${TRACING_PROFILE_FEATURES} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11 opengl', 'petalinux-self-hosted', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'petalinux-x11', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'petalinux-matchbox', '', d)} \
    petalinux-qt \
    petalinux-qt-extended \
    ${@bb.utils.contains('DISTRO_FEATURES', 'openamp', 'petalinux-openamp', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'virtualization vmsep', 'petalinux-ocicontainers', '', d)} \
    "

PLNX_COMMON_FEATURES:append:aarch64 = " \
    petalinux-gstreamer \
    petalinux-audio \
    petalinux-mraa \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'petalinux-multimedia', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'petalinux-weston', '', d)} \
    petalinux-ros \
    ${@bb.utils.contains('DISTRO_FEATURES', 'xen', 'petalinux-xen', '', d)} \
    aws-greengrass-v2 \
    "

ZYNQ_FEATURES = ""

ZYNQMP_FEATURES = ""

ULTRA96_FEATURES = " \
    petalinux-96boards-sensors \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'petalinux-ultra96-webapp', '', d)} \ 
    "

VERSAL_FEATURES = ""

IMAGE_FEATURES:append:zynq = " ${PLNX_COMMON_FEATURES} ${ZYNQ_FEATURES}"

IMAGE_FEATURES:append:zynqmp = " ${PLNX_COMMON_FEATURES} ${ZYNQMP_FEATURES}"

IMAGE_FEATURES:append:ultra96-zynqmp = " ${ULTRA96_FEATURES}"

IMAGE_FEATURES:append:versal = " ${PLNX_COMMON_FEATURES} ${VERSAL_FEATURES}"

IMAGE_FEATURES:append:microblaze = " ${TRACING_PROFILE_FEATURES}"

IMAGE_FSTYPES:remove = "cpio.gz cpio cpio.gz.u-boot cpio.bz2"

SDK_RDEPENDS:append:task-populate-sdk-ext = " nativesdk-packagegroup-sdk-host packagegroup-cross-canadian-${MACHINE}"

#Adding native packages depends
DEPENDS:append = " cpio-native wic-tools"
