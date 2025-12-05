DESCRIPTION = "An image containing the full set of packages in the Petalinux distro."
LICENSE = "MIT"

require petalinux-image-common.inc

TRACING_PROFILE_FEATURES = "\
    tools-debug \
    tools-profile \
    tools-testapps \
    "

IMAGE_INSTALL += " \
    bash \
    bzip2 \
    flex \
    gmp \
    libnet \
    libpng \
    libusb-compat \
    libusb1 \
    popt \
    unzip \
    zlib \
    tcf-agent \
    dnf \
    libattr \
    libinput \
    gdb \
    libftdi \
    cmake \
    util-linux \
    cpufrequtils \
    bridge-utils \
    mtd-utils \
    usbutils \
    pciutils \
    can-utils \
    i2c-tools \
    smartmontools \
    e2fsprogs \
    tcpdump \
    wireshark \
    libdrm \
    libdrm-tests \
    python3-pip \
    python3-multiprocessing \
    python3-shell \
    python3-threading \
    python3-pyserial \
    ${@bb.utils.contains('DISTRO_FEATURES', 'virtualization vmsep', 'packagegroup-oci', '', d)} \
"

IMAGE_INSTALL:append:arm = "\
    python3-h5py \
    python3-numpy \
"

IMAGE_INSTALL:append:aarch64 = "\
    python3-h5py \
    python3-numpy \
"

PLNX_COMMON_FEATURES = " \
    dev-pkgs \
    package-management \
    ptest-pkgs \
    splash \
    tools-sdk \
    petalinux-opencv \
    petalinux-networking-stack \
    petalinux-v4lutils \
    petalinux-lmsensors \
    petalinux-benchmarks \
    petalinux-jupyter \
    ${TRACING_PROFILE_FEATURES} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11 opengl', 'petalinux-self-hosted', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'petalinux-x11', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'petalinux-matchbox', '', d)} \
    "

PLNX_COMMON_FEATURES:append:aarch64 = " \
    petalinux-gstreamer \
    petalinux-audio \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'petalinux-multimedia', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'petalinux-weston', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'xen', 'petalinux-xen', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'openamp', 'petalinux-openamp', '', d)} \
    petalinux-ros \
    "

ZYNQ_FEATURES = ""

ZYNQMP_FEATURES = ""

VERSAL_FEATURES = ""

IMAGE_FEATURES:append:zynq = " ${PLNX_COMMON_FEATURES} ${ZYNQ_FEATURES}"

IMAGE_FEATURES:append:zynqmp = " ${PLNX_COMMON_FEATURES} ${ZYNQMP_FEATURES}"

IMAGE_FEATURES:append:versal = " ${PLNX_COMMON_FEATURES} ${VERSAL_FEATURES}"
IMAGE_FEATURES:append:versal-net = " ${PLNX_COMMON_FEATURES} ${VERSAL_FEATURES}"

IMAGE_FEATURES:append:microblaze = " ${TRACING_PROFILE_FEATURES}"

IMAGE_FSTYPES:remove = "cpio.gz cpio cpio.gz.u-boot cpio.bz2"

SDK_RDEPENDS:append:task-populate-sdk-ext = " nativesdk-packagegroup-sdk-host packagegroup-cross-canadian-${MACHINE}"

#Adding native packages depends
DEPENDS:append = " cpio-native wic-tools"
