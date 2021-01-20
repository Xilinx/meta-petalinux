DESCRIPTION = "SOM related packages"

inherit packagegroup

SOM_PACKAGES = " \
        ntp \
        tpm2-tools \
	"

RDEPENDS_${PN} = "${SOM_PACKAGES}"
