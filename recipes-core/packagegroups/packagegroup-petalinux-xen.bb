DESCRIPTION = "PetaLinux Xen supported Packages"
LICENSE = "NONE"

inherit packagegroup distro_features_check

REQUIRED_DISTRO_FEATURES = "xen"

XEN_EXTRA_PACKAGES = " \
    kernel-module-xen-blkback \
    kernel-module-xen-gntalloc \
    kernel-module-xen-gntdev \
    kernel-module-xen-netback \
    kernel-module-xen-wdt \
    xen-base \
    qemu \
    "

RDEPENDS_${PN}_append += " \
    ${XEN_EXTRA_PACKAGES} \
    "
