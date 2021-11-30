DESCRIPTION = "PetaLinux oci containers related packages"

inherit packagegroup features_check

REQUIRED_DISTRO_FEATURES = " virtualization"
REQUIRED_DISTRO_FEATURES:append:zynqmp = " vmsep"
REQUIRED_DISTRO_FEATURES:append:versal = " vmsep"

OCI_PACKAGES = " \
	docker \
	runc-opencontainers \
	containerd-opencontainers \
        cgroup-lite \
	"
OCI_PACKAGES:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'vmsep', 'packagegroup-petalinux-runx', '', d)}"

RDEPENDS:${PN} = "${OCI_PACKAGES}"
