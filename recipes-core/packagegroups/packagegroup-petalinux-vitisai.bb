DESCRIPTION = "PetaLinux Vitis AI packages"

inherit packagegroup

RDEPENDS_${PN} = "\
    glog \
    googletest \
    json-c \
    protobuf \
    python3-pip \
    opencv \
    dnndk \
	"

RDEPENDS_${PN}-dev += "\
    protobuf-c \
    libeigen-dev \
    "
