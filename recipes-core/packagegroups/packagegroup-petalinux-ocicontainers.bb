DESCRIPTION = "PetaLinux oci containers related packages"

inherit packagegroup distro_features_check

REQUIRED_DISTRO_FEATURES = " virtualization"

OCI_PACKAGES = " \
	docker \
	runc-opencontainers \
	containerd-opencontainers \
	"

RDEPENDS_${PN} = "${OCI_PACKAGES}"
