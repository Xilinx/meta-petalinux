python () {
    if bb.data.inherits_class('image', d):
        d.appendVarFlag('do_image_complete','postfuncs', ' plnx_deploy_rootfs')
    packagelist = (d.getVar('PACKAGES_LIST', True) or "").split()
    pn = d.getVar("PN")
    if pn in packagelist:
        copyfiles_update(d)
        d.appendVarFlag('do_deploy', 'postfuncs', ' plnx_deploy')
        d.appendVarFlag('do_deploy_setscene', 'postfuncs', ' plnx_deploy')
}

DEFAULT_LIST ?= "u-boot-xlnx device-tree linux-xlnx"
PACKAGES_LIST:zynqmp ?= "${DEFAULT_LIST} \
		fsbl-firmware \
		pmu-firmware \
		arm-trusted-firmware \
		u-boot-zynq-scr \
		qemu-devicetrees \
		xen \
		board-id-data \
		"
PACKAGES_LIST:zynq ?= "${DEFAULT_LIST} \
		fsbl-firmware \
		u-boot-zynq-scr \
		"
PACKAGES_LIST:versal ?= "${DEFAULT_LIST} \
		plm-firmware \
		extract-cdo \
		psm-firmware \
		arm-trusted-firmware \
		u-boot-zynq-scr \
		qemu-devicetrees \
		xen \
		"
PACKAGES_LIST:microblaze ?= "${DEFAULT_LIST} \
		u-boot-zynq-scr \
		fs-boot \
		mb-realoc \
		"
SYMLINK_PACKAGES ?= ""
SYMLINK_PACKAGES:versal ?= "device-tree"
SYMLINK_PACKAGES:zynqmp ?= "device-tree"
SYMLINK_PACKAGES:vck190 ?= "device-tree"
SYMLINK_PACKAGES:vmk180 ?= "device-tree"
SYMLINK_PACKAGES:k26-kv ?= "device-tree"
SYMLINK_PACKAGES:k26-kr ?= "device-tree"

SYMLINK_FILES ?= ""
SYMLINK_FILES:versal ?= "system-default.dtb:system.dtb"
SYMLINK_FILES:zynqmp ?= "system-default.dtb:system.dtb"
SYMLINK_FILES:vck190 ?= "system-default.dtb:system.dtb"
SYMLINK_FILES:vmk180 ?= "system-default.dtb:system.dtb"
SYMLINK_FILES:k26-kv ?= "system-zynqmp-sck-kv-g-revB.dtb:system.dtb"
SYMLINK_FILES:k26-kr ?= "system-zynqmp-sck-kr-g-revB.dtb:system.dtb"

SYMLINK_PACKAGES[device-tree] ?= "${SYMLINK_FILES}"

PLNX_DEPLOY_DIR ?= "${TOPDIR}/images/linux"
EXTRA_FILESLIST ?= ""
EXTRA_FILESLIST:zynqmp ?= "${DEPLOY_DIR_IMAGE}/pmu-rom.elf:pmu_rom_qemu_sha3.elf"
PACKAGE_DTB_NAME ?= ""
PACKAGE_UBOOT_DTB_NAME ?= ""
PACKAGE_FITIMG_NAME ?= ""

UBOOT_IMAGES ?= "u-boot-nodtb.bin:u-boot.bin u-boot-nodtb.elf:u-boot.elf \
		u-boot.elf:u-boot-dtb.elf u-boot.bin:u-boot-dtb.bin \
		u-boot-s.bin:u-boot-s.bin fit-dtb.blob:fit-dtb.blob"
UBOOT_IMAGES:microblaze ?= "u-boot.bin:u-boot.bin u-boot.elf:u-boot.elf \
			   u-boot-s.bin:u-boot-s.bin"

PACKAGES_LIST[mb-realoc] = "u-boot-s.bin:u-boot-s.bin"
PACKAGES_LIST[device-tree] = "system.dtb:system.dtb"
PACKAGES_LIST[uboot-device-tree] = "uboot-device-tree.dtb:u-boot.dtb"
PACKAGES_LIST[u-boot-zynq-scr] = "boot.scr:boot.scr"
PACKAGES_LIST[arm-trusted-firmware] = "arm-trusted-firmware.elf:bl31.elf arm-trusted-firmware.bin:bl31.bin"
PACKAGES_LIST[extract-cdo] = "CDO/pmc_cdo.bin:pmc_cdo.bin"
PACKAGES_LIST[xen] = "xen:xen"
PACKAGES_LIST[board-id-data] = "som-eeprom.bin:som-eeprom.bin kv-eeprom.bin:kv-eeprom.bin kr-eeprom.bin:kr-eeprom.bin"

QEMU_HWDTB_NAME:zynqmp ?= "zcu102-arm.dtb"
QEMU_HWDTB_NAME:ultra96 ?= "zcu100-arm.dtb"
QEMU_HWDTB_NAME:versal ?= "board-versal-ps-vc-p-a2197-00.dtb"
QEMU_HWDTB_NAME:versal-net ?= "board-ksb-psx-spp-1.4.dtb"
QEMU_HWDTB_NAME:vck190 ?= "board-versal-ps-vck190.dtb"
QEMU_HWDTB_NAME:vck5000 ?= "board-versal-ps-vck5000.dtb"
QEMU_HWDTB_NAME:k26 ?= "board-zynqmp-k26-som.dtb"
QEMU_HWDTB_NAME:vpk180 ?= "board-versal-ps-vpk180.dtb"
QEMU_HWDTB_NAME:vhk158 ?= "board-versal-ps-vhk158.dtb"

QEMU_HWDTBS:zynqmp ?= "qemu-hw-devicetrees/${QEMU_HWDTB_NAME}:zynqmp-qemu-arm.dtb"

QEMU_MULTI_HWDTBS:zynqmp ?= " \
		qemu-hw-devicetrees/multiarch/${QEMU_HWDTB_NAME}:zynqmp-qemu-multiarch-arm.dtb \
		qemu-hw-devicetrees/multiarch/zynqmp-pmu.dtb:zynqmp-qemu-multiarch-pmu.dtb"

QEMU_HWDTBS:versal ?= "qemu-hw-devicetrees/${QEMU_HWDTB_NAME}:versal-qemu-ps.dtb"
QEMU_MULTI_HWDTBS:versal ?= " \
		qemu-hw-devicetrees/multiarch/${QEMU_HWDTB_NAME}:versal-qemu-multiarch-ps.dtb \
		qemu-hw-devicetrees/multiarch/board-versal-pmc-vc-p-a2197-00.dtb:versal-qemu-multiarch-pmc.dtb"

QEMU_HWDTBS:versal-net ?= "qemu-hw-devicetrees/${QEMU_HWDTB_NAME}:versal-net-qemu-psx.dtb"

QEMU_MULTI_HWDTBS:versal-net ?= " \
                qemu-hw-devicetrees/multiarch/${QEMU_HWDTB_NAME}:versal-net-qemu-multiarch-psx.dtb \
                qemu-hw-devicetrees/multiarch/board-versal-pmx-virt.dtb:versal-net-qemu-multiarch-pmx.dtb"

def copyfiles_update(d):
    soc_family = d.getVar('SOC_FAMILY') or ""
    machine_arch = d.getVar('MACHINE') or ""
    initramfs_image = d.getVar('INITRAMFS_IMAGE') or ""
    bundle_image = d.getVar('INITRAMFS_IMAGE_BUNDLE') or ""
    pn = d.getVar("PN")
    d.setVarFlag('PACKAGES_LIST', 'u-boot-xlnx',d.getVar('UBOOT_IMAGES'))
    d.setVarFlag('PACKAGES_LIST', 'fsbl-firmware', 'fsbl' + '-' + machine_arch + '.elf:' + soc_family + '_' + 'fsbl' + '.elf' )
    d.setVarFlag('PACKAGES_LIST', 'fs-boot', pn + '-' + machine_arch + '.elf:' + 'fs-boot.elf' )
    d.setVarFlag('PACKAGES_LIST', 'imgsel', pn + '-' + machine_arch + '.elf:' + 'imgsel.elf ' + pn + '-' + machine_arch + '.bin:' + 'imgsel.bin' )
    d.setVarFlag('PACKAGES_LIST', 'imgrcry', pn + '-' + machine_arch + '.elf:' + 'imgrcry.elf ' + pn + '-' + machine_arch + '.bin:' + 'imgrcry.bin' )
    d.setVarFlag('PACKAGES_LIST', 'pmu-firmware', pn + '-' + machine_arch + '.elf:' + 'pmufw.elf' )
    d.setVarFlag('PACKAGES_LIST', 'psm-firmware', pn + '-' + machine_arch + '.elf:' + 'psmfw.elf' )
    d.setVarFlag('PACKAGES_LIST', 'plm-firmware', 'plm' + '-' + machine_arch + '.elf:' + 'plm.elf' )
    dtb_name = d.getVar('PACKAGE_DTB_NAME') or ""
    if dtb_name:
        d.setVarFlag('PACKAGES_LIST', 'device-tree', 'system.dtb:' + dtb_name)
    d.appendVarFlag('PACKAGES_LIST', 'device-tree', ' /devicetree/pl.dtbo:pl.dtbo /devicetree/pl-final.dtbo:pl.dtbo' )
    uboot_dtb_name = d.getVar('PACKAGE_UBOOT_DTB_NAME') or ""
    if uboot_dtb_name:
        d.setVarFlag('PACKAGES_LIST', 'uboot-device-tree', 'uboot-device-tree.dtb:' + uboot_dtb_name )
    type = d.getVar('KERNEL_IMAGETYPE') or ""
    alttype = d.getVar('KERNEL_ALT_IMAGETYPE') or ""
    types = d.getVar('KERNEL_IMAGETYPES') or ""
    if type not in types.split():
        types = (type + ' ' + types).strip()
    if alttype not in types.split():
        types = (alttype + ' ' + types).strip()
    kernel_images = ' '
    for kernel_image in types.split(' '):
        if kernel_image and kernel_image != 'fitImage':
            if bundle_image == '1' and not kernel_image.startswith('simpleImage.'):
                kernel_images += kernel_image + '-initramfs-' + machine_arch + '.bin:' + kernel_image + ' '
            elif kernel_image.startswith("simpleImage."):
                kernel_images += kernel_image + '-' + machine_arch + '.strip:image.elf '
            else:
                kernel_images += kernel_image + ':' + kernel_image + ' '
    fitimage_name = d.getVar('PACKAGE_FITIMG_NAME') or ""
    if not fitimage_name:
        fitimage_name = 'image.ub'
    if initramfs_image and bundle_image != '1':
        fitimage = 'fitImage-' + initramfs_image + '-' + machine_arch + '-' + machine_arch
        kernel_images += fitimage + ':' + fitimage_name + ' '
    else:
        kernel_images += 'fitImage-' + machine_arch + '.bin:' + fitimage_name + ' '
    if kernel_images:
        d.setVarFlag('PACKAGES_LIST', 'linux-xlnx', kernel_images )

    qemuhw_dir = "qemu-hw-devicetrees/"
    multi_qemuhw_dir = qemuhw_dir + "multiarch/"
    qemu_hwdtbs = (d.getVar('QEMU_HWDTBS') or "").split()
    qemu_multi_hwdtbs = (d.getVar('QEMU_MULTI_HWDTBS') or "").split()
    dtbs_list = (' '.join(qemu_hwdtbs) + ' ' + ' '.join(qemu_multi_hwdtbs))
    d.setVarFlag('PACKAGES_LIST', 'qemu-devicetrees', dtbs_list)

def copy_files(inputfile,outputfile):
   import shutil
   import os
   if os.path.exists(inputfile):
       if not os.path.exists(os.path.dirname(outputfile)):
           os.mkdir(os.path.dirname(outputfile))
       if os.path.isdir(inputfile):
           if os.path.exists(outputfile):
               shutil.rmtree(outputfile)
           shutil.copytree(inputfile, outputfile,symlinks=True)
       else:
           shutil.copy2(inputfile,outputfile)

def create_symlink(inputfile,symlinkfile):
   import shutil
   import os
   if os.path.exists(inputfile):
       if os.path.exists(symlinkfile):
           if os.path.isfile(symlinkfile) or os.path.islink(symlinkfile):
               os.remove(symlinkfile)
       fd = os.open(os.path.dirname(inputfile), os.O_RDONLY)
       bb.note("Creating symlink: %s -> %s" % (inputfile, symlinkfile))
       os.symlink(os.path.basename(inputfile),os.path.basename(symlinkfile),dir_fd=fd)
       os.close(fd)

plnx_deploy[dirs] ?= "${PLNX_DEPLOY_DIR}"
python plnx_deploy() {
    pn = d.getVar('PN')

    deploy_dir = d.getVar('DEPLOYDIR') or ""
    output_path = d.getVarFlag('plnx_deploy', 'dirs')

    if pn == 'u-boot-zynq-scr':
        pxeconfig = d.getVar('UBOOTPXE_CONFIG') or ""
        d.appendVarFlag('PACKAGES_LIST', 'u-boot-zynq-scr', ' ' + pxeconfig + ':' + 'pxelinux.cfg' )

    if pn == 'device-tree' and os.path.exists(deploy_dir + '/devicetree/'):
        dtbo_files = [f for f in os.listdir(deploy_dir + '/devicetree/') if f.endswith('.dtbo')]
        for dtbo_file in dtbo_files:
            if dtbo_file != 'pl.dtbo' and dtbo_file != 'pl-final.dtbo':
               d.appendVarFlag('PACKAGES_LIST', 'device-tree', ' /devicetree/' + dtbo_file + ':/dtbos/' + dtbo_file)

    if pn == 'device-tree' and os.path.exists(deploy_dir + '/devicetree/'):
        dtb_files = [f for f in os.listdir(deploy_dir + '/devicetree/') if f.endswith('.dtb')]
        for dtb_file in dtb_files:
            if dtb_file != 'system-top.dtb':
               d.appendVarFlag('PACKAGES_LIST', 'device-tree', ' /devicetree/' + dtb_file + ':/' + dtb_file)

    packageflags = d.getVarFlags('PACKAGES_LIST') or {}
    for package_bin in packageflags[pn].split():
        input, output = package_bin.split(':')
        inputfile = deploy_dir + '/' + input
        outputfile = output_path + '/' + output
        copy_files(inputfile,outputfile)

    symlinkpkgs = (d.getVar('SYMLINK_PACKAGES', True) or "").split()
    if pn in symlinkpkgs:
        for package in d.getVarFlag('SYMLINK_PACKAGES', pn).split():
            input, output = package.split(':')
            inputfile = output_path + '/' + input
            symlinkfile = output_path + '/' + output
            create_symlink(inputfile,symlinkfile)
}

plnx_deploy_rootfs[dirs] ?= "${PLNX_DEPLOY_DIR}"
python plnx_deploy_rootfs() {
    import os
    import re
    deploy_dir = d.getVar('IMGDEPLOYDIR') or ""
    image_name = d.getVar('IMAGE_NAME') or ""
    image_suffix = d.getVar('IMAGE_NAME_SUFFIX') or ""
    output_path = d.getVarFlag('plnx_deploy', 'dirs')
    search_str = image_name + image_suffix
    search_str = re.escape(search_str)
    if os.path.exists(deploy_dir):
        for _file in os.listdir(deploy_dir):
            if re.search(search_str, _file) and not _file.endswith('.qemu-sd-fatimg'):
                if image_name.find('initramfs') != -1:
                    dest_name='ramdisk'
                else:
                    dest_name='rootfs'
                source_name=str(_file)
                dest_name=dest_name + source_name.split(image_suffix)[1]
                copy_files(deploy_dir + '/' + source_name,output_path + '/' + dest_name)

    extra_files = d.getVar('EXTRA_FILESLIST') or ""
    for file in extra_files.split():
        input, output = file.split(':')
        copy_files(input,output_path + '/' + output)
}
