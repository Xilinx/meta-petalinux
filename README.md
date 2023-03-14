# meta-petalinux

This layer is a distro layer on supported architectures MicroBlaze, Zynq, ZynqMP
and Versal.

> **Note:** Additional information on Xilinx architectures can be found at:
	https://www.xilinx.com/products/silicon-devices.html

## Toolchains

To build standalone toolchains similar to those embedded with the Xilinx xsct
tooling:

Use one of the custom machines:
  aarch32-tc - 32-bit ARM toolchains (various)
  aarch64-tc - 64-bit ARM toolchains (various)
  arm-rm-tc  - ARM Cortex-R (and various)
  microblaze-tc - Microblaze toolchains (various)
```
MACHINE=<machine> DISTRO=xilinx-standalone bitbake meta-xilinx-toolchain
```
---
## Maintainers, Patches/Submissions, Community

Please send any patches, pull requests, comments or questions for this layer to
the [meta-xilinx mailing list](https://lists.yoctoproject.org/g/meta-xilinx):

	meta-xilinx@lists.yoctoproject.org

When sending patches, please make sure the email subject line includes
`[meta-petalinux][<BRANCH_NAME>][PATCH]` and cc'ing the maintainers.

For more details follow the OE community patch submission guidelines, as described in:

https://www.openembedded.org/wiki/Commit_Patch_Message_Guidelines
https://www.openembedded.org/wiki/How_to_submit_a_patch_to_OpenEmbedded

`git send-email --to meta-xilinx@lists.yoctoproject.org *.patch`

> **Note:** When creating patches, please use below format. To follow best practice,
> if you have more than one patch use `--cover-letter` option while generating the
> patches. Edit the `0000-cover-letter.patch` and change the title and top of the
> body as appropriate.

**Syntax:**
`git format-patch -s --subject "meta-petalinux][<BRANCH_NAME>][PATCH" -1`

**Example:**
`git format-patch -s --subject "meta-petalinux][rel-v2023.1][PATCH" -1`

**Maintainers:**

	Mark Hatle <mark.hatle@amd.com>
	Sandeep Gundlupet Raju <sandeep.gundlupet-raju@amd.com>
	John Toomey <john.toomey@amd.com>

## Dependencies

This layer depends on:

	URI: https://git.yoctoproject.org/poky
	layers: meta, meta-poky
	branch: langdale

	URI: https://git.openembedded.org/meta-openembedded
	layers: meta-oe, meta-perl, meta-python, meta-filesystems, meta-gnome,
            meta-multimedia, meta-networking, meta-webserver, meta-xfce,
            meta-initramfs.
	branch: langdale

	URI:
        https://git.yoctoproject.org/meta-xilinx (official version)
        https://github.com/Xilinx/meta-xilinx (development and amd xilinx release)
	layers: meta-xilinx-core, meta-xilinx-microblaze, meta-xilinx-bsp,
            meta-xilinx-standalone, meta-xilinx-vendor.
	branch: langdale or amd xilinx release version (e.g. rel-v2023.1)

	URI:
        https://git.yoctoproject.org/meta-xilinx-tools (official version)
        https://github.com/Xilinx/meta-xilinx-tools (development and amd xilinx release)
	branch: langdale or amd xilinx release version (e.g. rel-v2023.1)

	URI: https://github.com/Xilinx/meta-jupyter
	branch: langdale or amd xilinx release version (e.g. rel-v2023.1)

	URI: https://git.yoctoproject.org/meta-mingw
	branch: langdale

	URI: https://github.com/OpenAMP/meta-openamp
	branch: langdale

	URI: https://github.com/meta-qt5/meta-qt5
	branch: langdale

	URI: https://github.com/Xilinx/meta-ros
	layers: meta-ros-common, meta-ros2, meta-ros2-humble
	branch: amd xilinx release version (e.g. rel-v2023.1)

	URI: https://git.yoctoproject.org/meta-security
	layers: meta-tpm
	branch: langdale

	URI: https://github.com/Xilinx/meta-kria
	branch: amd xilinx release version (e.g. rel-v2023.1)

	URI: https://git.yoctoproject.org/meta-virtualization
	branch: langdale

	URI: https://github.com/Xilinx/meta-vitis
	branch: amd xilinx release version (e.g. rel-v2023.1)

	URI: https://github.com/Xilinx/meta-xilinx-tsn
	branch: amd xilinx release version (e.g. rel-v2023.1)

	URI: https://git.yoctoproject.org/meta-aws
	branch: langdale
