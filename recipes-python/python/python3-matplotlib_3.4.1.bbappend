FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# This python module requires an internal copy of 'qhull'
SRC_URI += "http://www.qhull.org/download/qhull-2020-src-8.0.2.tgz;name=qhull;subdir=matplotlib-${PV}/build"
SRC_URI[qhull.sha256sum] = "b5c2d7eb833278881b952c8a52d20179eab87766b00b865000469a45c1838b7e"
# extract to build/qhull-2020.2

SRC_URI += "file://matplotlib-disable-download.patch"
