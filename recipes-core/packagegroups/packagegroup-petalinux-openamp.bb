DESCRIPTION = "PetaLinux OpenAMP supported packages"

PACKAGE_ARCH:k26 = "${MACHINE_ARCH}"
PACKAGE_ARCH:zcu102 = "${MACHINE_ARCH}"

inherit packagegroup features_check

REQUIRED_DISTRO_FEATURES = "openamp"

PACKAGES = "\
	packagegroup-petalinux-openamp-echo-test \
	packagegroup-petalinux-openamp-matrix-mul \
	packagegroup-petalinux-openamp-rpc-demo \
	packagegroup-petalinux-openamp \
	"

RDEPENDS:${PN}-echo-test = "rpmsg-echo-test"
RDEPENDS:${PN}-echo-test:append:k26 = " openamp-fw-echo-testd"
RDEPENDS:${PN}-echo-test:append:zcu102 = " openamp-fw-echo-testd"

RDEPENDS:${PN}-matrix-mul = "rpmsg-mat-mul"
RDEPENDS:${PN}-matrix-mul:append:k26 = " openamp-fw-mat-muld"
RDEPENDS:${PN}-matrix-mul:append:zcu102 = " openamp-fw-mat-muld"

RDEPENDS:${PN}-rpc-demo = "rpmsg-proxy-app"
RDEPENDS:${PN}-rpc-demo:append:k26 = " openamp-fw-rpc-demo"
RDEPENDS:${PN}-rpc-demo:append:zcu102 = " openamp-fw-rpc-demo"

RDEPENDS:${PN}:append = " \
	libmetal \
	libmetal-demos \
	open-amp \
	open-amp-demos \
	packagegroup-petalinux-openamp-echo-test \
	packagegroup-petalinux-openamp-matrix-mul \
	packagegroup-petalinux-openamp-rpc-demo \
	"
