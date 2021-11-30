FILESEXTRAPATHS:prepend  := "${THISDIR}/files:"

USE_VT:microblaze ?= "0"

# We can share machines, so board is what specifies the differences
BOARDVARIANT_ARCH ??= "${MACHINE_ARCH}"
PACKAGE_ARCH = "${BOARDVARIANT_ARCH}"
