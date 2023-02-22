FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

ENABLE_XEN_DTSI ?= ""
ENABLE_XEN_QEMU_DTSI ?= ""

XEN_EXTRA_OVERLAYS = ""
XEN_EXTRA_QEMU_OVERLAYS = ""

XEN_EXTRA_OVERLAYS:zynqmp = "zynqmp-xen.dtsi"
XEN_EXTRA_QEMU_OVERLAYS:zynqmp = "zynqmp-xen.dtsi zynqmp-xen-qemu.dtsi"

XEN_EXTRA_OVERLAYS:versal = "versal-xen.dtsi"
XEN_EXTRA_QEMU_OVERLAYS:versal = "versal-xen.dtsi versal-xen-qemu.dtsi"

XEN_EXTRA_OVERLAYS:versal-net = "versal-net-xen.dtsi"
XEN_EXTRA_QEMU_OVERLAYS:versal-net = "versal-net-xen.dtsi versal-net-xen-qemu.dtsi"

EXTRA_OVERLAYS:append = "${@' ${XEN_EXTRA_OVERLAYS}' if d.getVar('ENABLE_XEN_DTSI') == '1' else ''}"
EXTRA_OVERLAYS:append = "${@' ${XEN_EXTRA_QEMU_OVERLAYS}' if d.getVar('ENABLE_XEN_QEMU_DTSI') == '1' else ''}"
