SUMMARY = "Gstreamer Interpipes 1.0.4"
DESCRIPTION = "GStreamer plug-in that allows communication between two independent pipelines"
HOMEPAGE = "https://developer.ridgerun.com/wiki/index.php?title=GstInterpipe"
SECTION = "multimedia"
LICENSE = "LGPL2.1"

LIC_FILES_CHKSUM = "file://COPYING;md5=3191ae9476980e87e3494d2d8ebe4584"

inherit autotools pkgconfig gettext

DEPENDS += "gstreamer1.0 gstreamer1.0-plugins-base"

SRCBRANCH ?= "master"
SRC_URI = " \
	git://github.com/RidgeRun/gst-interpipe.git;protocol=https;branch=${SRCBRANCH};name=base \
	git://github.com/GStreamer/common.git;protocol=https;destsuffix=git/common;name=common \
"

SRCREV_base ?= "9af5b40d106f35ce75f8baa5efc8c59fc5f7eda1"
SRCREV_common = "ac2f647695e7bd4b433ea108ee1d0e23901797d4"
SRCREV_FORMAT = "base"

S = "${WORKDIR}/git"

do_configure() {
	${S}/autogen.sh --noconfigure
	oe_runconf
}

FILES_${PN} += "${libdir}/gstreamer-1.0/libgstinterpipe.so"
