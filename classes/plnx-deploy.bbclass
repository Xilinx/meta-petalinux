python () {
    if bb.data.inherits_class('image', d):
        d.appendVarFlag('do_image_complete','postfuncs', ' plnx_deploy_rootfs')
    packagelist = (d.getVar('PACKAGES_LIST', True) or "").split()
    mc_packagelist = (d.getVar('MC_PACKAGES_LIST', True) or "").split()
    pn = d.getVar("PN")
    if pn in packagelist:
        copyfiles_update(d)
        d.appendVarFlag('do_deploy', 'postfuncs', ' plnx_deploy')
        d.appendVarFlag('do_deploy_setscene', 'postfuncs', ' plnx_deploy')
    if pn in mc_packagelist:
        copyfiles_update(d)
        d.appendVarFlag('do_deploy', 'postfuncs', ' mc_plnx_deploy')
        d.appendVarFlag('do_deploy_setscene', 'postfuncs', ' mc_plnx_deploy')

}

DEFAULT_LIST ?= "u-boot-xlnx device-tree linux-xlnx"
PACKAGES_LIST:zynqmp ?= "${DEFAULT_LIST} \
		fsbl-firmware \
		pmu-firmware \
		arm-trusted-firmware \
		trusted-firmware-a \
		u-boot-xlnx-scr \
		open-amp-device-tree \
		open-amp-xlnx \
		xen \
		board-id-data \
		"
PACKAGES_LIST:zynq ?= "${DEFAULT_LIST} \
		fsbl-firmware \
		u-boot-xlnx-scr \
		open-amp-device-tree \
		"
PACKAGES_LIST:versal ?= "${DEFAULT_LIST} \
		plm-firmware \
		extract-cdo \
		psm-firmware \
		arm-trusted-firmware \
		trusted-firmware-a \
		u-boot-xlnx-scr \
		open-amp-device-tree \
		open-amp-xlnx \
		xen \
		"
PACKAGES_LIST:versal-net ?= "${DEFAULT_LIST} \
		plm-firmware \
		extract-cdo \
		psm-firmware \
		arm-trusted-firmware \
		trusted-firmware-a \
		u-boot-xlnx-scr \
		open-amp-device-tree \
		open-amp-xlnx \
		xen \
		"
PACKAGES_LIST:microblaze ?= "${DEFAULT_LIST} \
		u-boot-xlnx-scr \
		fs-boot \
		mb-realoc \
		"

MC_PACKAGES_LIST ?= "empty-application \
                freertos-hello-world \
                freertos-lwip-echo-server \
                freertos-lwip-tcp-perf-client \
                freertos-lwip-tcp-perf-server \
                freertos-lwip-udp-perf-client \
                freertos-lwip-udp-perf-server \
                hello-world \
                lwip-echo-server \
                lwip-tcp-perf-client \
                lwip-tcp-perf-server \
                lwip-udp-perf-client \
                lwip-udp-perf-server \
                memory-tests \
                peripheral-tests \
                "

SYMLINK_PACKAGES ?= ""
SYMLINK_PACKAGES:versal ?= "device-tree"
SYMLINK_PACKAGES:versal-net ?= "device-tree"
SYMLINK_PACKAGES:zynqmp ?= "device-tree"
SYMLINK_PACKAGES:k26-kv ?= "device-tree"
SYMLINK_PACKAGES:k26-kr ?= "device-tree"

SYMLINK_FILES ?= ""
SYMLINK_FILES:versal ?= "system-default.dtb:system.dtb"
SYMLINK_FILES:versal-net ?= "system-default.dtb:system.dtb"
SYMLINK_FILES:zynqmp ?= "system-default.dtb:system.dtb"
SYMLINK_FILES:k26-kv ?= "system-zynqmp-sck-kv-g-revB.dtb:system.dtb"
SYMLINK_FILES:k26-kr ?= "system-zynqmp-sck-kr-g-revB.dtb:system.dtb"

SYMLINK_PACKAGES[device-tree] ?= "${SYMLINK_FILES}"

PLNX_DEPLOY_DIR ?= "${TOPDIR}/images/linux"
MC_PLNX_DEPLOY_DIR ?= "${TOPDIR}/images/${BB_CURRENT_MC}"
EXTRA_FILESLIST ?= ""
EXTRA_FILESLIST:zynqmp ?= "${DEPLOY_DIR_IMAGE}/pmu-rom.elf:pmu_rom_qemu_sha3.elf"
PACKAGE_DTB_NAME ?= ""
PACKAGE_UBOOT_DTB_NAME ?= ""
PACKAGE_FITIMG_NAME ?= ""

SDT_DT_FILE_NAME ?= ""
SDT_DT_FILE_NAME:versal-net ?= "cortexa78-linux.dtb"
SDT_DT_FILE_NAME:versal ?= "cortexa72-linux.dtb"
SDT_DT_FILE_NAME:zynqmp ?= "cortexa53-linux.dtb"
SDT_DT_FILE_NAME:zynq ?= "cortexa9-linux.dtb"
LINUX_DT_FILE_NAME ?= "${@'/devicetree/${SDT_DT_FILE_NAME}' if d.getVar('SYSTEM_DTFILE') != '' else 'system.dtb'}"

UBOOT_IMAGES ?= "u-boot-nodtb.bin:u-boot.bin u-boot-nodtb.elf:u-boot.elf \
		u-boot.elf:u-boot-dtb.elf u-boot.bin:u-boot-dtb.bin \
		u-boot-s.bin:u-boot-s.bin fit-dtb.blob:fit-dtb.blob"
UBOOT_IMAGES:microblaze ?= "u-boot.bin:u-boot.bin u-boot.elf:u-boot.elf \
			   u-boot-s.bin:u-boot-s.bin"

PACKAGES_LIST[mb-realoc] = "u-boot-s.bin:u-boot-s.bin"
PACKAGES_LIST[device-tree] = "${LINUX_DT_FILE_NAME}:system.dtb"
PACKAGES_LIST[open-amp-xlnx] = "openamp-lopper-output.dtb:openamp-lopper-output.dtb"
PACKAGES_LIST[uboot-device-tree] = "uboot-device-tree.dtb:u-boot.dtb"
PACKAGES_LIST[u-boot-xlnx-scr] = "boot.scr:boot.scr"
PACKAGES_LIST[arm-trusted-firmware] = "arm-trusted-firmware.elf:bl31.elf arm-trusted-firmware.bin:bl31.bin"
PACKAGES_LIST[trusted-firmware-a] = "arm-trusted-firmware.elf:bl31.elf arm-trusted-firmware.bin:bl31.bin"
PACKAGES_LIST[extract-cdo] = "CDO/pmc_cdo.bin:pmc_cdo.bin"
PACKAGES_LIST[xen] = "xen:xen"
PACKAGES_LIST[board-id-data] = "som-eeprom.bin:som-eeprom.bin kv-eeprom.bin:kv-eeprom.bin kr-eeprom.bin:kr-eeprom.bin"

QEMU_HWDTB_NAME:zynqmp ?= "zcu102-arm.dtb"
QEMU_HWDTB_NAME:versal ?= "board-versal-ps-vc-p-a2197-00.dtb"
QEMU_HWDTB_NAME:versal-net ?= "board-ksb-psx-spp-1.4.dtb"
QEMU_HWDTB_NAME:vck190-versal ?= "board-versal-ps-vck190.dtb"
QEMU_HWDTB_NAME:vmk180-versal ?= "board-versal-ps-vmk180.dtb"
QEMU_HWDTB_NAME:vck5000-versal ?= "board-versal-ps-vck5000.dtb"
QEMU_HWDTB_NAME:k26-kria ?= "board-zynqmp-k26-som.dtb"
QEMU_HWDTB_NAME:vpk180-versal ?= "board-versal-ps-vpk180.dtb"
QEMU_HWDTB_NAME:vpk120-versal ?= "board-versal-ps-vpk120.dtb"
QEMU_HWDTB_NAME:vhk158-versal ?= "board-versal-ps-vhk158.dtb"
QEMU_HWDTB_NAME:vek280-versal ?= "board-versal-ps-vek280.dtb"
QEMU_HWDTB_NAME:vek280-es1-versal ?= "board-versal-ps-vek280-es1.dtb"
QEMU_HWDTB_NAME:zcu104-zynqmp ?= "board-zynqmp-zcu104.dtb"
QEMU_HWDTB_NAME:k26-smk-kv ?= "board-zynqmp-kv260.dtb"
QEMU_HWDTB_NAME:zc1751-zynqmp ?= "board-zynqmp-zc1751-dc1.dtb"
QEMU_HWDTB_NAME:zc1751-dc2-zynqmp ?= "board-zynqmp-zc1751-dc2.dtb"

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

QEMU_HWDTBS ??= ""
QEMU_MULTI_HWDTBS ??= ""

# Add to the above settings DEPLOY_DIR_IMAGES
QEMU_DTB_FILESLIST = "${@' '.join([os.path.join('${DEPLOY_DIR_IMAGE}', entry) for entry in (d.getVar('QEMU_HWDTBS') + ' ' + d.getVar('QEMU_MULTI_HWDTBS')).split()])}"

def copyfiles_update(d):
    soc_family = d.getVar('SOC_FAMILY') or ""
    machine_arch = d.getVar('MACHINE') or ""
    initramfs_image = d.getVar('INITRAMFS_IMAGE') or ""
    bundle_image = d.getVar('INITRAMFS_IMAGE_BUNDLE') or ""
    pn = d.getVar("PN")
    d.setVarFlag('PACKAGES_LIST', 'u-boot-xlnx',d.getVar('UBOOT_IMAGES'))
    d.setVarFlag('PACKAGES_LIST', 'fsbl-firmware', 'fsbl' + '-' + machine_arch + '.elf:' + soc_family + '_' + 'fsbl' + '.elf ' + 'pmu-conf.bin:pmu-conf.bin' )
    d.setVarFlag('PACKAGES_LIST', 'fs-boot', pn + '-' + machine_arch + '.elf:' + 'fs-boot.elf' )
    d.setVarFlag('PACKAGES_LIST', 'imgsel', pn + '-' + machine_arch + '.elf:' + 'imgsel.elf ' + pn + '-' + machine_arch + '.bin:' + 'imgsel.bin' )
    d.setVarFlag('PACKAGES_LIST', 'imgrcry', pn + '-' + machine_arch + '.elf:' + 'imgrcry.elf ' + pn + '-' + machine_arch + '.bin:' + 'imgrcry.bin' )
    d.setVarFlag('PACKAGES_LIST', 'pmu-firmware', pn + '-' + machine_arch + '.elf:' + 'pmufw.elf' )
    d.setVarFlag('PACKAGES_LIST', 'psm-firmware', pn + '-' + machine_arch + '.elf:' + 'psmfw.elf' )
    d.setVarFlag('PACKAGES_LIST', 'plm-firmware', 'plm' + '-' + machine_arch + '.elf:' + 'plm.elf' )
    d.setVarFlag('MC_PACKAGES_LIST', 'hello-world', pn + '-' + machine_arch + '.elf:' + 'hello-world.elf' )
    d.setVarFlag('MC_PACKAGES_LIST', 'empty-application', pn + '-' + machine_arch + '.elf:' + 'empty-application.elf' )
    d.setVarFlag('MC_PACKAGES_LIST', 'freertos-hello-world', pn + '-' + machine_arch + '.elf:' + 'freertos-hello-world.elf' )
    d.setVarFlag('MC_PACKAGES_LIST', 'freertos-lwip-echo-server', pn + '-' + machine_arch + '.elf:' + 'freertos-lwip-echo-server.elf' )
    d.setVarFlag('MC_PACKAGES_LIST', 'freertos-lwip-tcp-perf-client', pn + '-' + machine_arch + '.elf:' + 'freertos-lwip-tcp-perf-client.elf' )
    d.setVarFlag('MC_PACKAGES_LIST', 'freertos-lwip-tcp-perf-server', pn + '-' + machine_arch + '.elf:' + 'freertos-lwip-tcp-perf-server.elf' )
    d.setVarFlag('MC_PACKAGES_LIST', 'freertos-lwip-udp-perf-client', pn + '-' + machine_arch + '.elf:' + 'freertos-lwip-udp-perf-client.elf' )
    d.setVarFlag('MC_PACKAGES_LIST', 'freertos-lwip-udp-perf-server', pn + '-' + machine_arch + '.elf:' + 'freertos-lwip-udp-perf-server.elf' )
    d.setVarFlag('MC_PACKAGES_LIST', 'lwip-echo-server', pn + '-' + machine_arch + '.elf:' + 'lwip-echo-server.elf' )
    d.setVarFlag('MC_PACKAGES_LIST', 'lwip-tcp-perf-client', pn + '-' + machine_arch + '.elf:' + 'lwip-tcp-perf-client.elf' )
    d.setVarFlag('MC_PACKAGES_LIST', 'lwip-tcp-perf-server', pn + '-' + machine_arch + '.elf:' + 'lwip-tcp-perf-server.elf' )
    d.setVarFlag('MC_PACKAGES_LIST', 'lwip-udp-perf-client', pn + '-' + machine_arch + '.elf:' + 'lwip-udp-perf-client.elf' )
    d.setVarFlag('MC_PACKAGES_LIST', 'lwip-udp-perf-server', pn + '-' + machine_arch + '.elf:' + 'lwip-udp-perf-server.elf' )
    d.setVarFlag('MC_PACKAGES_LIST', 'memory-tests', pn + '-' + machine_arch + '.elf:' + 'memory-tests.elf' )
    d.setVarFlag('MC_PACKAGES_LIST', 'peripheral-tests', pn + '-' + machine_arch + '.elf:' + 'peripheral-tests.elf' )

    dtb_name = d.getVar('PACKAGE_DTB_NAME') or ""
    if dtb_name:
        d.setVarFlag('PACKAGES_LIST', 'device-tree', d.getVar('LINUX_DT_FILE_NAME') + ':' + dtb_name)
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

    if pn == 'u-boot-xlnx-scr':
        pxeconfig = d.getVar('UBOOTPXE_CONFIG') or ""
        d.appendVarFlag('PACKAGES_LIST', 'u-boot-xlnx-scr', ' ' + pxeconfig + ':' + 'pxelinux.cfg' )

    if pn in ['device-tree', 'open-amp-device-tree'] and \
            os.path.exists(deploy_dir + '/devicetree/'):
        dtbo_files = [f for f in os.listdir(deploy_dir + '/devicetree/') if f.endswith('.dtbo')]
        for dtbo_file in dtbo_files:
            if dtbo_file != 'pl.dtbo' and dtbo_file != 'pl-final.dtbo':
               d.appendVarFlag('PACKAGES_LIST', pn, ' /devicetree/' + dtbo_file + ':/dtbos/' + dtbo_file)

    if pn in 'device-tree' and os.path.exists(deploy_dir + '/devicetree/'):
        dtb_files = [f for f in os.listdir(deploy_dir + '/devicetree/') if f.endswith('.dtb')]
        for dtb_file in dtb_files:
            if dtb_file != 'system-top.dtb':
               d.appendVarFlag('PACKAGES_LIST', pn, ' /devicetree/' + dtb_file + ':/' + dtb_file)

    for package_bin in d.getVarFlag('PACKAGES_LIST', pn).split():
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

mc_plnx_deploy[dirs] ?= "${MC_PLNX_DEPLOY_DIR}"
python mc_plnx_deploy() {
    pn = d.getVar('PN')

    deploy_dir = d.getVar('DEPLOYDIR') or ""
    mc_output_path = d.getVarFlag('mc_plnx_deploy', 'dirs')
    packageflags = d.getVarFlags('MC_PACKAGES_LIST') or {}
    if pn in packageflags:
        for package_bin in packageflags[pn].split():
            input, output = package_bin.split(':')
            inputfile = deploy_dir + '/' + input
            outputfile = mc_output_path + '/' + output
            copy_files(inputfile,outputfile)
}


plnx_deploy_rootfs[dirs] ?= "${PLNX_DEPLOY_DIR}"
python plnx_deploy_rootfs() {
    import os
    import re
    deploy_dir = d.getVar('IMGDEPLOYDIR') or ""
    image_name = d.getVar('IMAGE_NAME') or ""
    output_path = d.getVarFlag('plnx_deploy', 'dirs')
    search_str = re.escape(image_name)
    if os.path.exists(deploy_dir):
        for _file in os.listdir(deploy_dir):
            if re.search(search_str, _file) and not _file.endswith('.qemu-sd-fatimg'):
                if image_name.find('initramfs') != -1:
                    dest_name='ramdisk'
                else:
                    dest_name='rootfs'
                source_name=str(_file)
                dest_name=dest_name + source_name.split(image_name)[1]
                copy_files(deploy_dir + '/' + source_name,output_path + '/' + dest_name)

    extra_files = d.getVar('EXTRA_FILESLIST') or ""
    dtb_files = d.getVar('QEMU_DTB_FILESLIST') or ""
    for file in extra_files.split() + dtb_files.split():
        input, output = file.split(':')
        copy_files(input,output_path + '/' + output)
}
