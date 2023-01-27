#
# Copyright OpenEmbedded Contributors
#
# SPDX-License-Identifier: MIT
#

# Based on the poky image_types, used to allow us to exclude files from
# certain filetypes.  This allows PetaLinux to construct a single rootfs
# that is appropriate for different filesystem types, i.e.:
#
# wic/ext4 - good for sd cards (full filesystem)
# cpio - good for ramdisks/jtag loading (smaller, so skip /boot/* files)

# Format of this needs to be argument(s) to find, such as:
# To skip /boot directory
#    PLNX_IMAGE_CPIO_SKIP = "! -path './boot/*'"
# Note the matching path needs to be '.' for ${IMAGE_ROOTFS}, and any
# globbing needs to be quoted to prevent expansion.
PLNX_IMAGE_CPIO_SKIP ?= ""
IMAGE_CMD:cpio () {
	(cd ${IMAGE_ROOTFS} && find . ${PLNX_IMAGE_CPIO_SKIP} | sort | cpio --reproducible -o -H newc >${IMGDEPLOYDIR}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.cpio)
	# We only need the /init symlink if we're building the real
	# image. The -dbg image doesn't need it! By being clever
	# about this we also avoid 'touch' below failing, as it
	# might be trying to touch /sbin/init on the host since both
	# the normal and the -dbg image share the same WORKDIR
	if [ "${IMAGE_BUILDING_DEBUGFS}" != "true" ]; then
		if [ ! -L ${IMAGE_ROOTFS}/init ] && [ ! -e ${IMAGE_ROOTFS}/init ]; then
			if [ -L ${IMAGE_ROOTFS}/sbin/init ] || [ -e ${IMAGE_ROOTFS}/sbin/init ]; then
				ln -sf /sbin/init ${WORKDIR}/cpio_append/init
			else
				touch ${WORKDIR}/cpio_append/init
			fi
			(cd  ${WORKDIR}/cpio_append && echo ./init | cpio -oA -H newc -F ${IMGDEPLOYDIR}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.cpio)
		fi
	fi
}

# Format of this needs to be argument(s) to find, such as:
# To skip /boot directory
#    PLNX_IMAGE_JFFS2_SKIP = "! -path './boot/*'"
# Note the matching path needs to be '.' for ${IMAGE_ROOTFS}, and any
# globbing needs to be quoted to prevent expansion.
PLNX_IMAGE_JFFS2_SKIP ?= ""
do_image_jffs2[cleandirs] += "${WORKDIR}/jffs2"
IMAGE_CMD:jffs2 () {
	(cd ${IMAGE_ROOTFS} && find . ${PLNX_IMAGE_JFFS2_SKIP} | sort | cpio -o -H newc) | cpio -i -d -m --sparse -D ${WORKDIR}/jffs2

	mkfs.jffs2 --root=${WORKDIR}/jffs2 --faketime --output=${IMGDEPLOYDIR}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.jffs2 ${EXTRA_IMAGECMD}
}
