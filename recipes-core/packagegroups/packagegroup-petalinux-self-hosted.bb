DESCRIPTION = "PetaLinux self hosted tools packages"
LICENSE = "NONE"

inherit packagegroup

PETALINUX_SELF_HOSTED_PACKAGES ?= " \
        packagegroup-self-hosted \
        vim \
        "

RDEPENDS_${PN}_zynq = "${PETALINUX_SELF_HOSTED_PACKAGES}"
RDEPENDS_${PN}_zynqmp = "${PETALINUX_SELF_HOSTED_PACKAGES}"
