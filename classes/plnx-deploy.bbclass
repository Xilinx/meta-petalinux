python () {
    if bb.data.inherits_class('image', d):
        d.appendVarFlag('do_image_complete','postfuncs', ' plnx_deploy_rootfs')
    packagelist = (d.getVar('PACKAGES_LIST', True) or "").split()
    pn = d.getVar("PN")
    if pn in packagelist:
        copyfiles_append(d)
        d.appendVarFlag('do_deploy', 'postfuncs', ' plnx_deploy')
        d.appendVarFlag('do_deploy_setscene', 'postfuncs', ' plnx_deploy')
}

DEFAULT_LIST ?= "u-boot-xlnx device-tree linux-xlnx"
PACKAGES_LIST_zynqmp ?= "${DEFAULT_LIST} \
		fsbl \
		pmu-firmware \
		arm-trusted-firmware \
		u-boot-zynq-scr \
		qemu-devicetrees \
		xen \
		"
PACKAGES_LIST_zynq ?= "${DEFAULT_LIST} \
		fsbl \
		u-boot-zynq-scr \
		"
PACKAGES_LIST_versal ?= "${DEFAULT_LIST} \
		plm \
		extract-cdo \
		psm-firmware \
		arm-trusted-firmware \
		u-boot-zynq-scr \
		qemu-devicetrees \
		xen \
		"
PACKAGES_LIST_microblaze ?= "${DEFAULT_LIST} \
		u-boot-zynq-scr \
		fs-boot \
		mb-realoc \
		"

PLNX_DEPLOY_DIR ?= "${TOPDIR}/images/linux"
EXTRA_FILESLIST ?= ""
PACKAGE_DTB_NAME ?= ""
PACKAGE_FITIMG_NAME ?= ""

PACKAGES_LIST[u-boot-xlnx] = "u-boot.elf:u-boot.elf u-boot.bin:u-boot.bin u-boot-s.bin:u-boot-s.bin"
PACKAGES_LIST[mb-realoc] = "u-boot-s.bin:u-boot-s.bin"
PACKAGES_LIST[device-tree] = "system.dtb:system.dtb"
PACKAGES_LIST[u-boot-zynq-scr] = "boot.scr:boot.scr"
PACKAGES_LIST[arm-trusted-firmware] = "arm-trusted-firmware.elf:bl31.elf arm-trusted-firmware.bin:bl31.bin"
PACKAGES_LIST[extract-cdo] = "CDO/pmc_cdo.bin:pmc_cdo.bin"
PACKAGES_LIST[xen] = "xen:xen"

QEMU_HWDTBS_zynqmp ?= "qemu-hw-devicetrees/zcu102-arm.dtb:zynqmp-qemu-arm.dtb"
QEMU_HWDTBS_zc1751-zynqmp ?= "qemu-hw-devicetrees/zc1751-dc2-arm.dtb:zynqmp-qemu-arm.dtb"
QEMU_HWDTBS_ultra96-zynqmp ?= "qemu-hw-devicetrees/zcu100-arm.dtb:zynqmp-qemu-arm.dtb"
QEMU_MULTI_HWDTBS_zynqmp ?= " \
		qemu-hw-devicetrees/multiarch/zcu102-arm.dtb:zynqmp-qemu-multiarch-arm.dtb \
		qemu-hw-devicetrees/multiarch/zynqmp-pmu.dtb:zynqmp-qemu-multiarch-pmu.dtb"

QEMU_HWDTBS_versal ?= "qemu-hw-devicetrees/board-versal-ps-vc-p-a2197-00.dtb:versal-qemu-ps.dtb"
QEMU_MULTI_HWDTBS_versal ?= " \
		qemu-hw-devicetrees/multiarch/board-versal-ps-vc-p-a2197-00.dtb:versal-qemu-multiarch-ps.dtb \
		qemu-hw-devicetrees/multiarch/board-versal-pmc-vc-p-a2197-00.dtb:versal-qemu-multiarch-pmc.dtb"

def copyfiles_append(d):
    soc_family = d.getVar('SOC_FAMILY') or ""
    machine_arch = d.getVar('MACHINE') or ""
    initramfs_image = d.getVar('INITRAMFS_IMAGE') or ""
    bundle_image = d.getVar('INITRAMFS_IMAGE_BUNDLE') or ""
    pn = d.getVar("PN")
    d.setVarFlag('PACKAGES_LIST', 'fsbl', pn + '-' + machine_arch + '.elf:' + soc_family + '_' + pn + '.elf' )
    d.setVarFlag('PACKAGES_LIST', 'fs-boot', pn + '-' + machine_arch + '.elf:' + 'fs-boot.elf' )
    d.setVarFlag('PACKAGES_LIST', 'pmu-firmware', pn + '-' + machine_arch + '.elf:' + 'pmufw.elf' )
    d.setVarFlag('PACKAGES_LIST', 'psm-firmware', pn + '-' + machine_arch + '.elf:' + 'psmfw.elf' )
    d.setVarFlag('PACKAGES_LIST', 'plm', pn + '-' + machine_arch + '.elf:' + 'plm.elf' )
    dtb_name = d.getVar('PACKAGE_DTB_NAME') or ""
    if dtb_name:
        d.setVarFlag('PACKAGES_LIST', 'device-tree', 'system.dtb:' + dtb_name)
    d.appendVarFlag('PACKAGES_LIST', 'device-tree', ' ' + machine_arch + '-system.dtbo:' + 'pl.dtbo' )
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
    if initramfs_image:
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
       if os.path.isdir(inputfile):
           if os.path.exists(outputfile):
               shutil.rmtree(outputfile)
           shutil.copytree(inputfile, outputfile,symlinks=True)
       else:
           shutil.copy2(inputfile,outputfile)

plnx_deploy[dirs] ?= "${PLNX_DEPLOY_DIR}"
python plnx_deploy() {
    pn = d.getVar('PN')

    deploy_dir = d.getVar('DEPLOYDIR') or ""
    output_path = d.getVarFlag('plnx_deploy', 'dirs')

    if pn == 'u-boot-zynq-scr':
        pxeconfig = d.getVar('UBOOTPXE_CONFIG') or ""
        d.appendVarFlag('PACKAGES_LIST', 'u-boot-zynq-scr', ' ' + pxeconfig + ':' + 'pxelinux.cfg' )
    
    packageflags = d.getVarFlags('PACKAGES_LIST') or {}
    for package_bin in packageflags[pn].split():
        input, output = package_bin.split(':')
        inputfile = deploy_dir + '/' + input
        outputfile = output_path + '/' + output
        copy_files(inputfile,outputfile)
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
    dest_name=''
    if os.path.exists(deploy_dir):
        for _file in os.listdir(deploy_dir):
            if re.search(search_str, _file):
                source_name=str(_file)
                dest_name=source_name.split(image_suffix)[1]
                dest_name= 'rootfs' + dest_name
                copy_files(deploy_dir + '/' + source_name,output_path + '/' + dest_name)

    extra_files = d.getVar('EXTRA_FILESLIST') or ""
    for file in extra_files.split():
        input, output = file.split(':')
        copy_files(input,output_path + '/' + output)
}
