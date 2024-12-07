#To support yocto native zcu104 SDT BSP, adding the rootfs packages for petalinux distro 
IMAGE_INSTALL:append:zynqmp-zcu104-sdt-full = "\
	packagegroup-xilinx-gstreamer \
	packagegroup-xilinx-matchbox \
	packagegroup-core-x11 \
	libdrm \
	libdrm-tests \
	gstreamer-vcu-examples \
	v4l-utils \
	e2fsprogs-mke2fs \
	dosfstools \
	yavta \
	packagegroup-xilinx-audio \
	libmali-xlnx \
	zocl \
	xrt \
	opencl-headers \
	gstreamer-vcu-notebooks \
	vcu-ctrlsw \
	zcu104-pl-vcu-fw \
	"

IMAGE_INSTALL:append:versal-vek280-sdt-seg = "\
	e2fsprogs-mke2fs \
	dosfstools \
	vek280-pl-aie-vdu-fw \
	packagegroup-xilinx-gstreamer \
	libvdu-omxil \
	vdu-ctrlsw \
	kernel-module-vdu \
	vdu-firmware \
	gstreamer-vdu-examples \
	gstreamer-vdu-notebooks \
	"
