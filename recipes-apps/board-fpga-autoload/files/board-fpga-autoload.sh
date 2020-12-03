#!/bin/sh

dev_eeprom=$(find /sys/bus/i2c/devices/*54/ -name eeprom | head -1)
if [ ! -z $dev_eeprom ] && [ -f $dev_eeprom ]; then
	board_name=$(dd if=$dev_eeprom bs=1 count=6 skip=208 2>/dev/null)
	board_rev=$(dd if=$dev_eeprom bs=1 count=3 skip=224 2>/dev/null)

	echo board_name:$board_name - board_rev:$board_rev
	BD_DTPATH="/lib/firmware/xilinx/${board_name}_${board_rev}"
	if [ -d ${BD_DTPATH} ];then
		BIN="$(find ${BD_DTPATH}/ -name *.bin | head -1)"
		DTBO="$(find ${BD_DTPATH}/ -name *.dtbo | head -1)"
	else
		echo -e "\033[1mValid Board Information Not Found, Loading rev1.0 bitstream and dtbo as default (see fpgautil -h for removing and loading different bitstream and dtbo)\033[0m"
		board_rev=1.0  # Loading Rev1.0 bitstream and dtbo in default case.
		BD_DTPATH="/lib/firmware/xilinx/*_${board_rev}"
		BIN="$(find ${BD_DTPATH}/ -name *.bin | head -1)"
		DTBO="$(find ${BD_DTPATH}/ -name *.dtbo | head -1)"
	fi
	if [ ! -z "${BIN}" ] && [ ! -z "${DTBO}" ]; then
		echo "Loading dtbo and bitstream from $(dirname $BIN)"
		fpgautil -b ${BIN} -o ${DTBO}
	fi
fi
