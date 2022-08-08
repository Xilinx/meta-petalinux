FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

ENABLE_XEN_DTSI ?= ""
ENABLE_XEN_QEMU_DTSI ?= ""

EXTRA_OVERLAYS:append:versal = "${@'versal-xen.dtsi' if d.getVar('ENABLE_XEN_DTSI') == '1' else ''}"
EXTRA_OVERLAYS:append:versal = "${@'versal-xen.dtsi versal-xen-qemu.dtsi' if d.getVar('ENABLE_XEN_QEMU_DTSI') == '1' else ''}"
EXTRA_OVERLAYS:append:zynqmp = "${@'zynqmp-xen.dtsi' if d.getVar('ENABLE_XEN_DTSI') == '1' else ''}"
EXTRA_OVERLAYS:append:zynqmp = "${@'zynqmp-xen.dtsi zynqmp-xen-qemu.dtsi' if d.getVar('ENABLE_XEN_QEMU_DTSI') == '1' else ''}"
