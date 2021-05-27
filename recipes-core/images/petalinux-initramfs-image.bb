# Simple petalinux initramfs image.
DESCRIPTION = "Small image capable of booting a device. The kernel includes \
the Minimal RAM-based Initial Root Filesystem (initramfs), which finds the \
first 'init' program more efficiently."

INITRAMFS_SCRIPTS ?= "initramfs-framework-base \
		initramfs-module-e2fs \
		initramfs-module-udhcpc \
		initramfs-module-searche2fs \
		"

INITRAMFS_SCRIPTS_append_k26 = " initramfs-module-exec"

INITRAMFS_PACKAGES ?= "${VIRTUAL-RUNTIME_base-utils} \
		base-passwd \
		e2fsprogs \
		${ROOTFS_BOOTSTRAP_INSTALL} \
		${MACHINE_ESSENTIAL_EXTRA_RDEPENDS} \
		"

BAD_RECOMMENDATIONS += "initramfs-module-rootfs"

PACKAGE_INSTALL ?= "packagegroup-core-boot ${INITRAMFS_PACKAGES} ${INITRAMFS_SCRIPTS}"

# Do not pollute the initrd image with rootfs features
IMAGE_FEATURES = ""

export IMAGE_BASENAME = "petalinux-initramfs-image"
IMAGE_LINGUAS = ""

LICENSE = "MIT"

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
inherit core-image

IMAGE_ROOTFS_SIZE = "8192"
IMAGE_ROOTFS_EXTRA_SPACE = "0"

rm_work_rootfs[noexec] = "1"
rm_work_rootfs[cleandirs] = ""
RM_WORK_EXCLUDE_ITEMS = "rootfs"
