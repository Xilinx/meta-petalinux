# meta-petalinux

This layer is a distro layer on supported architectures
MicroBlaze, Zynq, ZynqMP and Versal.

> **Note:** Additional information on Xilinx architectures can be found at:
	https://www.xilinx.com/products/silicon-devices.html

Limitation for fru-print utility: The SOM Memory Config record offset was updated.
Legacy devices using the old offset will skip this record when printing fru data.

## Maintainers, Patches/Submissions, Community

Please open pull requests for any changes.

For more details follow the OE community patch submission guidelines, as described in:

https://www.openembedded.org/wiki/Commit_Patch_Message_Guidelines
https://www.openembedded.org/wiki/How_to_submit_a_patch_to_OpenEmbedded

When creating patches, please use below format.

**Syntax:**
`git format-patch -s --subject "meta-petalinux][<release-version>][PATCH" -1`

**Example:**
`git format-patch -s --subject "meta-petalinux][rel-v2022.1][PATCH" -1`

**Maintainers:**

	Mark Hatle <mark.hatle@amd.com>
	Sandeep Gundlupet Raju <sandeep.gundlupet-raju@amd.com>
	John Toomey <john.toomey@amd.com>

## Dependencies

This layer depends on:

	URI: https://git.openembedded.org/bitbake

	URI: https://github.com/OSSystems/meta-browser
	layers: meta-chromium

	URI: https://git.yoctoproject.org/meta-clang

	URI: https://github.com/Xilinx/meta-jupyter

	URI: https://git.yoctoproject.org/meta-mingw

	URI: https://github.com/OpenAMP/meta-openamp

	URI: https://git.openembedded.org/openembedded-core
	layers: meta, meta-poky

	URI: https://git.openembedded.org/meta-openembedded
	layers: meta-filesystems, meta-gnome, meta-initramfs, meta-multimedia,
		meta-networking, meta-oe, meta-perl, meta-python, meta-webserver
		meta-xfce.

	URI: https://git.openembedded.org/meta-python2

	URI: https://github.com/meta-qt5/meta-qt5

	URI: https://github.com/Xilinx/meta-ros
	layers: meta-ros-common, meta-ros2, meta-ros2-humble

	URI: https://git.yoctoproject.org/meta-security
	layers: meta-tpm

	URI: https://github.com/Xilinx/meta-som

	URI: https://github.com/Xilinx/meta-som-apps

	URI: https://git.yoctoproject.org/meta-virtualization

	URI: https://github.com/Xilinx/meta-vitis

	URI: https://git.yoctoproject.org/meta-xilinx
	layers: meta-xilinx-microblaze, meta-xilinx-bsp, meta-xilinx-core,
		meta-xilinx-pynq, meta-xilinx-contrib, meta-xilinx-standalone,
		meta-xilinx-vendor.

	URI: https://git.yoctoproject.org/meta-xilinx-tools

	URI: https://github.com/Xilinx/meta-xilinx-tsn

	branch: master or xilinx current release version (e.g. hosister)
