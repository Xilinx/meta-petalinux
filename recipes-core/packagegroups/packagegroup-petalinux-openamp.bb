DESCRIPTION = "PetaLinux OpenAMP supported packages"

inherit packagegroup features_check

REQUIRED_DISTRO_FEATURES = "openamp"

PACKAGES = "\
	packagegroup-petalinux-openamp-echo-test \
	packagegroup-petalinux-openamp-matrix-mul \
	packagegroup-petalinux-openamp-rpc-demo \
	packagegroup-petalinux-openamp \
	"

RDEPENDS:packagegroup-petalinux-openamp-echo-test = "\
	rpmsg-echo-test \
	openamp-fw-echo-testd \
	"

RDEPENDS:packagegroup-petalinux-openamp-matrix-mul = "\
	rpmsg-mat-mul \
	openamp-fw-mat-muld \
	"

RDEPENDS:packagegroup-petalinux-openamp-rpc-demo = "\
	rpmsg-proxy-app \
	openamp-fw-rpc-demo \
	"

RDEPENDS:${PN}:append = " \
	libmetal \
	libmetal-demos \
	open-amp \
	open-amp-demos \
	packagegroup-petalinux-openamp-echo-test \
	packagegroup-petalinux-openamp-matrix-mul \
	packagegroup-petalinux-openamp-rpc-demo \
	"
