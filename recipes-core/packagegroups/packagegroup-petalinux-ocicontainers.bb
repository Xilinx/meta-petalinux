DESCRIPTION = "PetaLinux oci containers related packages"

inherit packagegroup distro_features_check

REQUIRED_DISTRO_FEATURES = " virtualization vmsep"

OCI_PACKAGES = " \
	docker \
	runc-opencontainers \
	containerd-opencontainers \
	${@bb.utils.contains('DISTRO_FEATURES', 'vmsep', 'packagegroup-petalinux-runx', '', d)} \
	"

RDEPENDS_${PN} = "${OCI_PACKAGES}"
