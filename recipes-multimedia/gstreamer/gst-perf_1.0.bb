SUMMARY = "GStreamer Perf 1.0"
DESCRIPTION = "GStreamer element to measure fps and performance"
HOMEPAGE = "https://github.com/RidgeRun/gst-perf-autotools"
SECTION = "multimedia"
LICENSE = "LGPLv2"

LIC_FILES_CHKSUM = "file://plugins/gstperf.c;beginline=4;endline=17;md5=38d6fe788111af776f33448451c008b8"

inherit autotools pkgconfig gettext

DEPENDS += "gstreamer1.0 gstreamer1.0-plugins-base gstreamer1.0-plugins-bad"

SRCBRANCH ?= "master"
SRCREV ?= "939eee167c6e95ed1c2f2013246b1f0b671a378b"
SRC_URI = "git://github.com/RidgeRun/gst-perf.git;protocol=https;branch=${SRCBRANCH}"

S = "${WORKDIR}/git"

FILES_${PN} += "${libdir}/gstreamer-1.0/libgstperf.so"

