python () {
    pn = d.getVar("PN")
    if pn == 'xen':
        d.appendVarFlag('do_deploy', 'postfuncs', ' do_config_image_builder')
    if pn == 'linux-xlnx':
        d.appendVarFlag('do_deploy', 'depends', ' image-builder-native:do_populate_sysroot')
        d.appendVarFlag('do_deploy', 'postfuncs', ' do_compile_image_builder')
}

DEST_PATH = "${OUTPUT_PATH}"
XEN_CONFIG ?= "${DEST_PATH}/xen.cfg"
MEMORY_START ?= "0x0"
MEMORY_END ?= "0x80000000"
DEVICE_TREE ?= "${@bb.utils.contains('PREFERRED_PROVIDER_virtual/dtb', 'device-tree', 'system.dtb', d.getVar('KERNELDT'), d)}"
XEN ?= "xen"
DOM0_KERNEL ?= "${KERNEL_IMAGETYPE}"
DOM0_RAMDISK ?= "rootfs.cpio.gz"
NUM_DOMUS ?= "0"
UBOOT_SOURCE ?= "xen_boot.source"
UBOOT_SCRIPT ?= "xen_boot.scr"

do_config_image_builder() {
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

do_compile_image_builder() {
	if [ -f "${XEN_CONFIG}" ]; then
		uboot-script-gen -c ${XEN_CONFIG} -t tftp -d $(dirname "${XEN_CONFIG}") -o xen_boot_tftp
		uboot-script-gen -c ${XEN_CONFIG} -t sd -d $(dirname "${XEN_CONFIG}") -o xen_boot_sd
	fi
}

