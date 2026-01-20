#To support yocto native zcu104 SDT BSP, adding the rootfs packages for petalinux distro 
IMAGE_INSTALL:append:zynqmp-zcu104-sdt-full = "\
	packagegroup-xilinx-gstreamer \
	packagegroup-xilinx-matchbox \
	packagegroup-core-x11 \
	libdrm \
	libdrm-tests \
	v4l-utils \
	e2fsprogs-mke2fs \
	dosfstools \
	yavta \
	packagegroup-xilinx-audio \
	libmali-xlnx \
	opencl-headers \
	zcu104-pl-vcu-fw \
	"

IMAGE_INSTALL:append:versal-vek280-sdt-seg = "\
	e2fsprogs-mke2fs \
	dosfstools \
	packagegroup-xilinx-gstreamer \
	"
