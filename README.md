# meta-petalinux

This layer is a distro layer on supported architectures MicroBlaze, Zynq, ZynqMP
and Versal.

> **Note:** Additional information on AMD Adaptive SoC's and FPGA's can be found at:
	https://www.amd.com/en/products/adaptive-socs-and-fpgas.html

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

For more details follow the Yocto Project community patch submission guidelines,
as described in:

https://docs.yoctoproject.org/dev/contributor-guide/submit-changes.html#

`git send-email --to meta-xilinx@lists.yoctoproject.org *.patch`

> **Note:** When creating patches, please use below format. To follow best practice,
> if you have more than one patch use `--cover-letter` option while generating the
> patches. Edit the `0000-cover-letter.patch` and change the title and top of the
> body as appropriate.

**Syntax:**
`git format-patch -s --subject "meta-petalinux][<BRANCH_NAME>][PATCH" -1`

**Example:**
`git format-patch -s --subject "meta-petalinux][rel-v2025.1][PATCH" -1`

**Maintainers:**

	Mark Hatle <mark.hatle@amd.com>
	Sandeep Gundlupet Raju <sandeep.gundlupet-raju@amd.com>
	John Toomey <john.toomey@amd.com>
	Trevor Woerner <trevor.woerner@amd.com>

## Dependencies

This layer depends on:

	URI: https://git.yoctoproject.org/poky
	layers: meta, meta-poky
	branch: scarthgap

	URI: https://git.openembedded.org/meta-openembedded
	layers: meta-oe, meta-perl, meta-python, meta-filesystems, meta-gnome,
            meta-multimedia, meta-networking, meta-webserver, meta-xfce,
            meta-initramfs.
	branch: scarthgap

	URI:
        https://git.yoctoproject.org/meta-xilinx (official version)
        https://github.com/Xilinx/meta-xilinx (development and AMD release)
	layers: meta-xilinx-core, meta-xilinx-microblaze, meta-xilinx-bsp,
            meta-xilinx-standalone, meta-xilinx-vendor, meta-xilinx-virtualization.
	branch: scarthgap or AMD release version (e.g. rel-v2025.1)

	URI:
        https://git.yoctoproject.org/meta-xilinx-tools (official version)
        https://github.com/Xilinx/meta-xilinx-tools (development and AMD release)
	branch: scarthgap or AMD release version (e.g. rel-v2025.1)

	URI: https://github.com/Xilinx/meta-jupyter
	branch: scarthgap or AMD release version (e.g. rel-v2025.1)

	URI: https://git.yoctoproject.org/meta-mingw
	branch: scarthgap

	URI: https://github.com/OpenAMP/meta-openamp
	branch: scarthgap

	URI: https://github.com/meta-qt5/meta-qt5
	branch: scarthgap

	URI: https://github.com/Xilinx/meta-ros
	layers: meta-ros-common, meta-ros2, meta-ros2-jazzy
	branch: AMD release version (e.g. rel-v2025.1)

	URI: https://git.yoctoproject.org/meta-security
	layers: meta-tpm
	branch: scarthgap

	URI: https://github.com/Xilinx/meta-kria
	branch: AMD release version (e.g. rel-v2025.1)

	URI: https://git.yoctoproject.org/meta-virtualization
	branch: scarthgap

	URI: https://github.com/Xilinx/meta-vitis
	branch: AMD release version (e.g. rel-v2025.1)

	URI: https://github.com/Xilinx/meta-xilinx-tsn
	branch: AMD release version (e.g. rel-v2025.1)

	URI: https://git.yoctoproject.org/meta-aws
	branch: scarthgap

	URI: https://git.yoctoproject.org/meta-arm
	layers: meta-arm, meta-arm-toolchain
	branch: scarthgap
