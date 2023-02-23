FILESEXTRAPATHS:prepend  := "${THISDIR}/files:"

USE_VT:microblaze ?= "0"

# In order to support serial autologin, we need a real getty not busybox
RDEPENDS:${PN} += "util-linux-agetty"
