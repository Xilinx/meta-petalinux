# If PLNX_DEPLOY_DIR isn't set, default to the image directory
PLNX_DEPLOY_DIR ??= "${DEPLOY_DIR_IMAGE}"

XEN_CONFIG ?= "${PLNX_DEPLOY_DIR}/xen.cfg"
XEN_CONFIG_SKIP ?= "0"
MEMORY_START ?= "0x0"
MEMORY_END ?= "0x80000000"
DEVICE_TREE ?= "${@bb.utils.contains('PREFERRED_PROVIDER_virtual/dtb', 'device-tree', 'system.dtb', d.getVar('KERNELDT'), d)}"
XEN ?= "xen"
DOM0_KERNEL ?= "${KERNEL_IMAGETYPE}"
DOM0_RAMDISK ?= "rootfs.cpio.gz"
NUM_DOMUS ?= "0"
UBOOT_SOURCE ?= "xen_boot.source"
UBOOT_SCRIPT ?= "xen_boot.scr"

plnx_config_image_builder() {
	# We always want to make sure we have the full current set..
	install -m 0755 "${DEPLOY_DIR_IMAGE}/uboot-script-gen" "${WORKDIR}/image_builder/"
	install -m 0644 "${DEPLOY_DIR_IMAGE}/${INITRAMFS_IMAGE}-${MACHINE}.cpio.gz" "${WORKDIR}/image_builder/${DOM0_RAMDISK}"
	install -m 0644 "${DEPLOY_DIR_IMAGE}/${XEN}" "${WORKDIR}/image_builder/"
	install -m 0644 "${DEPLOYDIR}/${DOM0_KERNEL}" "${WORKDIR}/image_builder/"
	install -m 0644 "${DEPLOY_DIR_IMAGE}/${DEVICE_TREE}" "${WORKDIR}/image_builder/"

	if [ "${XEN_CONFIG_SKIP}" != "1" ];then
		cat > ${WORKDIR}/image_builder/$(basename ${XEN_CONFIG}) << EOL
MEMORY_START=${MEMORY_START}
MEMORY_END=${MEMORY_END}
DEVICE_TREE=${DEVICE_TREE}
XEN=${XEN}
DOM0_KERNEL=${DOM0_KERNEL}
DOM0_RAMDISK=${DOM0_RAMDISK}
NUM_DOMUS=${NUM_DOMUS}
UBOOT_SOURCE=${UBOOT_SOURCE}
UBOOT_SCRIPT=${UBOOT_SCRIPT}
EOL
	else
		# We have to have a config, expect that there is one available
		if [ ! -e ${XEN_CONFIG} ]; then
			echo "You must have a xen configuration file (${XEN}) present."
			exit 1
		fi
		cp "${XEN_CONFIG}" "${WORKDIR}/image_builder/"
	fi
}

# We use deployed components from each of these items, so explicitly list them as dependencies
do_deploy[depends] += "image-builder-native:do_deploy xen:do_deploy device-tree:do_deploy"

do_deploy_append() {
	mkdir -p ${WORKDIR}/image_builder

	plnx_config_image_builder

	${WORKDIR}/image_builder/uboot-script-gen -c ${WORKDIR}/image_builder/$(basename ${XEN_CONFIG}) -t tftp -d ${WORKDIR}/image_builder/ -o ${WORKDIR}/image_builder/xen_boot_tftp
	${WORKDIR}/image_builder/uboot-script-gen -c ${WORKDIR}/image_builder/$(basename ${XEN_CONFIG}) -t sd -d ${WORKDIR}/image_builder/ -o ${WORKDIR}/image_builder/xen_boot_sd

	# Since the ramdisk has a different name, we need to use the one from this script
	install -m 0644 ${WORKDIR}/image_builder/${DOM0_RAMDISK} ${DEPLOYDIR}/${DOM0_RAMDISK}

	# Deploy the recently built items
	install -m 0644 ${WORKDIR}/image_builder/$(basename ${XEN_CONFIG}) ${DEPLOYDIR}/.
	install -m 0644 ${WORKDIR}/image_builder/xen_boot_tftp* ${DEPLOYDIR}/.
	install -m 0644 ${WORKDIR}/image_builder/xen_boot_sd* ${DEPLOYDIR}/.
}

python() {
    add_list = "xen.cfg:xen.cfg xen_boot_tftp.scr:xen_boot_tftp.scr xen_boot_tftp.source:xen_boot_tftp.source xen_boot_sd.scr:xen_boot_sd.scr xen_boot_sd.source:xen_boot_sd.source"
    d.appendVarFlag('PACKAGES_LIST', d.getVar('PN'), ' ' + add_list)
}
