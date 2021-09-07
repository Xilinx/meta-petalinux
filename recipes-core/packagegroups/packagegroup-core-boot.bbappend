# The boot is impacted by the MACHINE_ESSENTIAL_EXTRA_RDEPENDS, so
# we need to ensure this package is board specific

# Specify a default in case boardvariant isn't available
BOARDVARIANT_ARCH ??= "${MACHINE_ARCH}"
PACKAGE_ARCH = "${BOARDVARIANT_ARCH}"

