DESCRIPTION = "PetaLinux self hosted tools packages"

inherit packagegroup

PETALINUX_SELF_HOSTED_PACKAGES ?= " \
        packagegroup-self-hosted \
        vim \
        "

RDEPENDS_${PN} = "${PETALINUX_SELF_HOSTED_PACKAGES}"
