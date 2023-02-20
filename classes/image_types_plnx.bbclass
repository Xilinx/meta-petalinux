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

# Format of this needs to be argument(s) to find, such as:
# To skip /boot directory
#    PLNX_IMAGE_UBI_SKIP = "! -path './boot/*'"
# Note the matching path needs to be '.' for ${IMAGE_ROOTFS}, and any
# globbing needs to be quoted to prevent expansion.
# Affects ubi, ubifs and multiubi
PLNX_IMAGE_UBI_SKIP ?= ""

do_image_ubifs[cleandirs] += "${WORKDIR}/multiubi"
multiubi_mkfs() {
	local mkubifs_args="$1"
	local ubinize_args="$2"

        # Added prompt error message for ubi and ubifs image creation.
        if [ -z "$mkubifs_args" ] || [ -z "$ubinize_args" ]; then
            bbfatal "MKUBIFS_ARGS and UBINIZE_ARGS have to be set, see http://www.linux-mtd.infradead.org/faq/ubifs.html for details"
        fi

	write_ubi_config "$3"

	if [ -n "$vname" ]; then
		(cd ${IMAGE_ROOTFS} && find . ${PLNX_IMAGE_UBI_SKIP} | sort | cpio -o -H newc) | cpio -i -d -m --sparse -D ${WORKDIR}/multiubi
		mkfs.ubifs -r ${WORKDIR}/multiubi -o ${IMGDEPLOYDIR}/${IMAGE_NAME}${vname}${IMAGE_NAME_SUFFIX}.ubifs ${mkubifs_args}
	fi
	ubinize -o ${IMGDEPLOYDIR}/${IMAGE_NAME}${vname}${IMAGE_NAME_SUFFIX}.ubi ${ubinize_args} ubinize${vname}-${IMAGE_NAME}.cfg

	# Cleanup cfg file
	mv ubinize${vname}-${IMAGE_NAME}.cfg ${IMGDEPLOYDIR}/

	# Create own symlinks for 'named' volumes
	if [ -n "$vname" ]; then
		cd ${IMGDEPLOYDIR}
		if [ -e ${IMAGE_NAME}${vname}${IMAGE_NAME_SUFFIX}.ubifs ]; then
			ln -sf ${IMAGE_NAME}${vname}${IMAGE_NAME_SUFFIX}.ubifs \
			${IMAGE_LINK_NAME}${vname}.ubifs
		fi
		if [ -e ${IMAGE_NAME}${vname}${IMAGE_NAME_SUFFIX}.ubi ]; then
			ln -sf ${IMAGE_NAME}${vname}${IMAGE_NAME_SUFFIX}.ubi \
			${IMAGE_LINK_NAME}${vname}.ubi
		fi
		cd -
	fi
}

do_image_ubifs[cleandirs] += "${WORKDIR}/ubifs"
IMAGE_CMD:ubifs () {
	(cd ${IMAGE_ROOTFS} && find . ${PLNX_IMAGE_UBI_SKIP} | sort | cpio -o -H newc) | cpio -i -d -m --sparse -D ${WORKDIR}/ubifs
	mkfs.ubifs -r ${WORKDIR}/ubifs -o ${IMGDEPLOYDIR}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.ubifs ${MKUBIFS_ARGS}
}
