DESCRIPTION = "Jupyter notebook examples for VCU in ZynqMP-EV devices"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=268f2517fdae6d70f4ea4c55c4090aa8"

inherit jupyter-examples

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
	   file://vcu-demo-videotestsrc-hdr-to-file.ipynb \
	   file://pictures/block-diagram-camera-decode-diaplay.png \
	   file://pictures/block-diagram-camera-encode-decode-diaplay.png \
	   file://pictures/block-diagram-camera-encode-file.png \
	   file://pictures/block-diagram-camera-encode-streamout.png \
	   file://pictures/block-diagram-decode-display.png \
	   file://pictures/block-diagram-streamin-decode.png \
	   file://pictures/block-diagram-transcode-file.png \
	   file://pictures/block-diagram-transcode-streamout.png \
	   file://pictures/block-diagram-videotestsrc-hdr-to-file.png "

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp-ev = "zynqmp-ev"

RDEPENDS_${PN} = "packagegroup-petalinux-jupyter packagegroup-petalinux-gstreamer gstreamer-vcu-examples start-jupyter"

do_install() {
    install -d ${D}/${JUPYTER_DIR}/vcu-notebooks
    install -d ${D}/${JUPYTER_DIR}/vcu-notebooks/pictures

    install -m 0755 ${S}/pictures/*.png ${D}/${JUPYTER_DIR}/vcu-notebooks/pictures
    install -m 0755 ${S}/common.py ${D}/${JUPYTER_DIR}/vcu-notebooks/common.py
    install -m 0755 ${S}/*.ipynb ${D}/${JUPYTER_DIR}/vcu-notebooks

}

PACKAGE_ARCH_zynqmp = "${SOC_VARIANT_ARCH}"
