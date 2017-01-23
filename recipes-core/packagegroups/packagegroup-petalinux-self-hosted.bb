DESCRIPTION = "PetaLinux self hosted tools packages"
LICENSE = "NONE"

inherit packagegroup

PETALINUX_SELF_HOSTED_PACKAGES ?= " \
        packagegroup-self-hosted \
        vim \
        "

# We enable self hosting only when not running with external tools
RDEPENDS_${PN} = "${@['', d.getVar('PETALINUX_SELF_HOSTED_PACKAGES', True)]\
                     [d.getVar('PREFERRED_PROVIDER_virtual/glibc', True) == 'glibc']}"
