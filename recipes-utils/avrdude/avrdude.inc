DESCRIPTION = "AVRDUDE is software for programming Atmel AVR Microcontrollers."
SUMMARY = "AVRDUDE is a utility to download/upload/manipulate the ROM and EEPROM contents of AVR microcontrollers using the in-system programming technique (ISP)."

HOMEPAGE = "http://www.nongnu.org/avrdude/"

LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=4f51bb496ef8872ccff73f440f2464a8"

DEPENDS = "virtual/libusb0 ncurses bison-native"

SRC_URI = "http://savannah.nongnu.org/download/avrdude/avrdude-${PV}.tar.gz"

inherit autotools
