#!/bin/sh

dev_eeprom=$(find /sys/bus/i2c/devices/*54/ -name eeprom | head -1)
if [ ! -z $dev_eeprom ] && [ -f $dev_eeprom ]; then
	board_name=$(dd if=$dev_eeprom bs=1 count=6 skip=208 2>/dev/null)
	board_rev=$(dd if=$dev_eeprom bs=1 count=3 skip=224 2>/dev/null)

	echo board_name:$board_name - board_rev:$board_rev
	BD_DTPATH="/lib/firmware/${board_name}_${board_rev}"
	if [ -d ${BD_DTPATH} ];then
		BIN="$(find ${BD_DTPATH}/ -name *.bin | head -1)"
		DTBO="$(find ${BD_DTPATH}/ -name *.dtbo | head -1)"
	fi
	if [ ! -z "${BIN}" ] && [ ! -z "${DTBO}" ]; then
		echo "Loading dtbo and bitstream for ${board_name}_${board_rev}"
		fpgautil -b ${BIN} -o ${DTBO}
	fi
fi
