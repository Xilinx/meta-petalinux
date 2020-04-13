inherit core-image
require xsct-tarball-esdk.inc

IMAGE_AUTOLOGIN ?= "1"

AUTOLOGIN = "${@ 'autologin' if d.getVar('IMAGE_AUTOLOGIN') == '1' else '' }"

inherit ${AUTOLOGIN}

COMMON_FEATURES = " \
    ssh-server-dropbear \
    hwcodecs \
    "
IMAGE_FEATURES += "${COMMON_FEATURES}"

COMMON_INSTALL = " \
    openssh-sftp-server \
    tcf-agent \
    mtd-utils \
    bridge-utils \
    can-utils \
    pciutils \
    kernel-modules \
    "

IMAGE_INSTALL = " \
    packagegroup-core-boot \
    ${COMMON_INSTALL} \
    ${CORE_IMAGE_EXTRA_INSTALL} \
    "

COMMON_INSTALL_append_zynqmp = " hellopm haveged"
COMMON_INSTALL_append_zynq = " haveged"
COMMON_INSTALL_append_versal = " haveged"

CORE_IMAGE_EXTRA_INSTALL_append_ultra96-zynqmp = " packagegroup-base-extended"

IMAGE_LINGUAS = " "

FEATURE_PACKAGES_petalinux-base ?= "packagegroup-petalinux"
FEATURE_PACKAGES_petalinux-x11 ?= "packagegroup-petalinux-x11"
FEATURE_PACKAGES_petalinux-x11[optional] ?= "1"
FEATURE_PACKAGES_petalinux-matchbox ?= "packagegroup-petalinux-matchbox"
FEATURE_PACKAGES_petalinux-matchbox[optional] ?= "1"
FEATURE_PACKAGES_petalinux-weston ?= "packagegroup-petalinux-weston"
FEATURE_PACKAGES_petalinux-weston[optional] ?= "1"
FEATURE_PACKAGES_petalinux-self-hosted ?= "packagegroup-petalinux-self-hosted"
FEATURE_PACKAGES_petalinux-self-hosted[optional] ?= "1"
FEATURE_PACKAGES_petalinux-qt ?= "packagegroup-petalinux-qt"
FEATURE_PACKAGES_petalinux-qt[optional] ?= "1"
FEATURE_PACKAGES_petalinux-opencv ?= "packagegroup-petalinux-opencv"
FEATURE_PACKAGES_petalinux-opencv[optional] ?= "1"
FEATURE_PACKAGES_petalinux-benchmarks ?= "packagegroup-petalinux-benchmarks"
FEATURE_PACKAGES_petalinux-benchmarks[optional] ?= "1"
FEATURE_PACKAGES_petalinux-gstreamer ?= "packagegroup-petalinux-gstreamer"
FEATURE_PACKAGES_petalinux-gstreamer[optional] ?= "1"
FEATURE_PACKAGES_petalinux-audio ?= "packagegroup-petalinux-audio"
FEATURE_PACKAGES_petalinux-audio[optional] ?= "1"
FEATURE_PACKAGES_petalinux-xen ?= "packagegroup-petalinux-xen"
FEATURE_PACKAGES_petalinux-xen[optional] ?= "1"
FEATURE_PACKAGES_petalinux-openamp ?= "packagegroup-petalinux-openamp"
FEATURE_PACKAGES_petalinux-openamp[optional] ?= "1"
FEATURE_PACKAGES_petalinux-mraa ?= "packagegroup-petalinux-mraa"
FEATURE_PACKAGES_petalinux-mraa[optional] ?= "1"
FEATURE_PACKAGES_petalinux-display-debug ?= "packagegroup-petalinux-display-debug"
FEATURE_PACKAGES_petalinux-display-debug[optional] ?= "1"
FEATURE_PACKAGES_petalinux-multimedia ?= "packagegroup-petalinux-multimedia"
FEATURE_PACKAGES_petalinux-multimedia[optional] ?= "1"
FEATURE_PACKAGES_petalinux-networking-debug ?= "packagegroup-petalinux-networking-debug"
FEATURE_PACKAGES_petalinux-networking-debug[optional] ?= "1"
FEATURE_PACKAGES_petalinux-networking-stack ?= "packagegroup-petalinux-networking-stack"
FEATURE_PACKAGES_petalinux-networking-stack[optional] ?= "1"
FEATURE_PACKAGES_petalinux-python-modules ?= "packagegroup-petalinux-python-modules"
FEATURE_PACKAGES_petalinux-python-modules[optional] ?= "1"
FEATURE_PACKAGES_petalinux-qt-extended ?= "packagegroup-petalinux-qt-extended"
FEATURE_PACKAGES_petalinux-qt-extended[optional] ?= "1"
FEATURE_PACKAGES_petalinux-utils ?= "packagegroup-petalinux-utils"
FEATURE_PACKAGES_petalinux-utils[optional] ?= "1"
FEATURE_PACKAGES_petalinux-v4lutils ?= "packagegroup-petalinux-v4lutils"
FEATURE_PACKAGES_petalinux-v4lutils[optional] ?= "1"
FEATURE_PACKAGES_petalinux-lmsensors ?= "packagegroup-petalinux-lmsensors"
FEATURE_PACKAGES_petalinux-lmsensors[optional] ?= "1"
FEATURE_PACKAGES_petalinux-ultra96-webapp ?= "packagegroup-petalinux-ultra96-webapp"
FEATURE_PACKAGES_petalinux-ultra96-webapp[optional] ?= "1"
FEATURE_PACKAGES_petalinux-96boards-sensors ?= "packagegroup-petalinux-96boards-sensors"
FEATURE_PACKAGES_petalinux-96boards-sensors[optional] ?= "1"
FEATURE_PACKAGES_fpga-manager ?= "fpga-manager-script fpga-manager-util"
FEATURE_PACKAGES_fpga-manager[optional] ?= "1"
FEATURE_PACKAGES_petalinux-syscontroller ?= "packagegroup-petalinux-syscontroller"
FEATURE_PACKAGES_petalinux-syscontroller[optional] ?= "1"
FEATURE_PACKAGES_petalinux-jupyter ?= "packagegroup-petalinux-jupyter"
FEATURE_PACKAGES_petalinux-jupyter[optional] ?= "1"
FEATURE_PACKAGES_petalinux-xrt ?= "packagegroup-petalinux-xrt"
FEATURE_PACKAGES_petalinux-xrt[optional] ?= "1"
FEATURE_PACKAGES_petalinux-pynq-bnn ?= "packagegroup-petalinux-pynq-bnn"
FEATURE_PACKAGES_petalinux-pynq-bnn[optional] ?= "1"
FEATURE_PACKAGES_petalinux-pynq-96boardsoverlay ?= "packagegroup-petalinux-pynq-96boardsoverlay"
FEATURE_PACKAGES_petalinux-pynq-96boardsoverlay[optional] ?= "1"
FEATURE_PACKAGES_petalinux-pynq ?= "packagegroup-petalinux-pynq"
FEATURE_PACKAGES_petalinux-pynq[optional] ?= "1"
FEATURE_PACKAGES_petalinux-pynq-helloworld ?= "packagegroup-petalinux-pynq-helloworld"
FEATURE_PACKAGES_petalinux-pynq-helloworld[optional] ?= "1"

# Vitis AI is only built for zynqmp at this time, but allow
# the FEATURE_PACKAGES to not error on no zynqmp systems
VITISAI_PKGS = ""
VITISAI_PKGS_zynqmp = "packagegroup-petalinux-vitisai"
FEATURE_PACKAGES_petalinux-vitisai ?= "${VITISAI_PKGS}"
FEATURE_PACKAGES_petalinux-vitisai[optional] ?= "1"

FEATURE_PACKAGES_petalinux-updateboot ?= "packagegroup-petalinux-updateboot"
FEATURE_PACKAGES_petalinux-updateboot[optional] ?= "1"
FEATURE_PACKAGES_petalinux-ocicontainers ?= "packagegroup-petalinux-ocicontainers"
FEATURE_PACKAGES_petalinux-ocicontainers[optional] ?= "1"
