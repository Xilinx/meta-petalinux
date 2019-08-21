DESCRIPTION = "Jupyter notebook examples for VCU in ZynqMP-EV devices"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=268f2517fdae6d70f4ea4c55c4090aa8"

SRC_URI = "file://LICENSE \
	   file://common.py \
           file://vcu-demo-camera-decode-display.ipynb \
           file://vcu-demo-camera-encode-decode-display.ipynb \
           file://vcu-demo-camera-encode-file.ipynb \
           file://vcu-demo-camera-encode-streamout.ipynb \
           file://vcu-demo-decode-display.ipynb \
           file://vcu-demo-streamin-decode-display.ipynb \
           file://vcu-demo-transcode-to-file.ipynb \
           file://vcu-demo-transcode-to-streamout.ipynb \
	   file://pictures/block-diagram-camera-decode-diaplay.png \
	   file://pictures/block-diagram-camera-encode-decode-diaplay.png \
	   file://pictures/block-diagram-camera-encode-file.png \
	   file://pictures/block-diagram-camera-encode-streamout.png \
	   file://pictures/block-diagram-decode-display.png \
	   file://pictures/block-diagram-streamin-decode.png \
	   file://pictures/block-diagram-transcode-file.png \
	   file://pictures/block-diagram-transcode-streamout.png "

S = "${WORKDIR}"

FILES_${PN} += "${datadir}"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmpev = "zynqmpev"

RDEPENDS_${PN} = "packagegroup-petalinux-jupyter packagegroup-petalinux-gstreamer gstreamer-vcu-examples"

do_install() {
    install -d ${D}/${datadir}/vcu-notebooks
    install -d ${D}/${datadir}/vcu-notebooks/pictures

    install -m 0755 ${S}/pictures/*.png ${D}/${datadir}/vcu-notebooks/pictures
    install -m 0755 ${S}/common.py ${D}/${datadir}/vcu-notebooks/common.py
    install -m 0755 ${S}/*.ipynb ${D}/${datadir}/vcu-notebooks

}

# These libraries shouldn't get installed in world builds unless something
# explicitly depends upon them.

EXCLUDE_FROM_WORLD = "1"

PACKAGE_ARCH_zynqmp = "${SOC_FAMILY}${SOC_VARIANT}"
