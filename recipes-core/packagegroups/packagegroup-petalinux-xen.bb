DESCRIPTION = "PetaLinux Xen supported packages"

inherit packagegroup features_check

REQUIRED_DISTRO_FEATURES = "xen"

XEN_EXTRA_PACKAGES = " \
	kernel-module-xen-blkback \
	kernel-module-xen-gntalloc \
	kernel-module-xen-gntdev \
	kernel-module-xen-netback \
	kernel-module-xen-wdt \
	xen \
	xen-tools \
	xen-tools-xenstat \
	${@bb.utils.contains('DISTRO_FEATURES', 'vmsep', 'qemu-system-i386 qemu-keymaps', 'qemu', d)} \
	"

RDEPENDS_${PN} = "${XEN_EXTRA_PACKAGES}"
