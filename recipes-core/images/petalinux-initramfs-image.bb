# Simple petalinux initramfs image.
DESCRIPTION = "Small image capable of booting a device. The kernel includes \
the Minimal RAM-based Initial Root Filesystem (initramfs), which finds the \
first 'init' program more efficiently."

INITRAMFS_SCRIPTS ?= " \
    plnx-initramfs-framework-base \
    plnx-initramfs-module-e2fs \
    plnx-initramfs-module-udhcpc \
    plnx-initramfs-module-searche2fs \
"

INITRAMFS_SCRIPTS:append:kria = " plnx-initramfs-module-exec"

INITRAMFS_PACKAGES ?= "${VIRTUAL-RUNTIME_base-utils} \
		base-passwd \
		e2fsprogs \
		${ROOTFS_BOOTSTRAP_INSTALL} \
		"

BAD_RECOMMENDATIONS += "plnx-initramfs-module-rootfs"
PACKAGE_INSTALL ?= "${INITRAMFS_PACKAGES} ${INITRAMFS_SCRIPTS}"

# Do not pollute the initrd image with rootfs features
IMAGE_FEATURES = ""

export IMAGE_BASENAME = "petalinux-initramfs-image"
IMAGE_LINGUAS = ""

LICENSE = "MIT"

# BSPs use IMAGE_FSTYPES:<machine override> which would override
# an assignment to IMAGE_FSTYPES so we need anon python
IMAGE_FSTYPES:forcevariable = "${INITRAMFS_FSTYPES}"
python () {
    d.setVar("IMAGE_FSTYPES", d.getVar("INITRAMFS_FSTYPES"))
}

inherit core-image
inherit image_types_plnx

# Skip /boot when generating a cpio
PLNX_IMAGE_CPIO_SKIP += "! -path './boot/*'"

IMAGE_ROOTFS_SIZE = "8192"
IMAGE_ROOTFS_EXTRA_SPACE = "0"

rm_work_rootfs[noexec] = "1"
rm_work_rootfs[cleandirs] = ""
RM_WORK_EXCLUDE_ITEMS += "rootfs"
