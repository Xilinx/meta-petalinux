DESCRIPTION = "PetaLinux xcfe related packages"

inherit packagegroup distro_features_check

REQUIRED_DISTRO_FEATURES = "x11"

RDEPENDS_${PN} = "packagegroup-petalinux-x11 packagegroup-xfce-base"
