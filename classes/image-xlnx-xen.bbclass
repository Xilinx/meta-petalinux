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

deltask do_deploy_setscene

plnx_config_image_builder() {
	cp "${DEPLOY_DIR_IMAGE}/${INITRAMFS_IMAGE}-${MACHINE}.cpio.gz" "${WORKDIR}/image_builder/rootfs.cpio.gz"
	cp "${DEPLOY_DIR_IMAGE}/${XEN}" "${WORKDIR}/image_builder/"
	cp "${DEPLOYDIR}/${DOM0_KERNEL}" "${WORKDIR}/image_builder/"
	cp "${DEPLOY_DIR_IMAGE}/${DEVICE_TREE}" "${WORKDIR}/image_builder/"
	cat > ${XEN_CONFIG} << EOL
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
}

plnx_compile_image_builder[dirs] ?= "${WORKDIR}/image_builder"
plnx_compile_image_builder[dirs] ?= "${PLNX_DEPLOY_DIR}"
plnx_compile_image_builder() {
	if [ "${XEN_CONFIG_SKIP}" != "1" ];then
		plnx_config_image_builder
	fi
	if [ -f "${XEN_CONFIG}" ]; then
                ${DEPLOY_DIR_IMAGE}/uboot-script-gen -c ${XEN_CONFIG} -t tftp -d $(dirname "${XEN_CONFIG}") -o ${PLNX_DEPLOY_DIR}/xen_boot_tftp
                ${DEPLOY_DIR_IMAGE}/uboot-script-gen -c ${XEN_CONFIG} -t sd -d $(dirname "${XEN_CONFIG}") -o ${PLNX_DEPLOY_DIR}/xen_boot_sd
        fi
}
