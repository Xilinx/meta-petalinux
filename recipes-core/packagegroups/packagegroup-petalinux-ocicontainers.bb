DESCRIPTION = "PetaLinux oci containers related packages"

inherit packagegroup features_check

REQUIRED_DISTRO_FEATURES = " virtualization"
REQUIRED_DISTRO_FEATURES_append_zynqmp = " vmsep"
REQUIRED_DISTRO_FEATURES_append_versal = " vmsep"

OCI_PACKAGES = " \
	docker \
	runc-opencontainers \
	containerd-opencontainers \
        cgroup-lite \
	"
OCI_PACKAGES_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'vmsep', 'packagegroup-petalinux-runx', '', d)}"

RDEPENDS_${PN} = "${OCI_PACKAGES}"
