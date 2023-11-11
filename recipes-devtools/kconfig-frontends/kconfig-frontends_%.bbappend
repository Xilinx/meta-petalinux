FILESEXTRAPATHS:append := ":${THISDIR}/files"

SRC_URI += "file://ncurses-include-path.patch"

BBCLASSEXTEND += "nativesdk"
