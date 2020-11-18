#!/bin/bash

dev_eeprom=$(find /sys/bus/i2c/devices/*54/ -name eeprom | head -1)
if [ ! -z $dev_eeprom ] && [ -f $dev_eeprom ]; then
#TODO will need to update the following info to match som board eeprom info
	BOARD=$(dd if=$dev_eeprom bs=1 count=6 skip=208 2>/dev/null)
	BOARD_VARIANT=$(dd if=$dev_eeprom bs=1 count=3 skip=224 2>/dev/null)
fi
#TODO Possibly check BOARD/BOARD_VARIANT values before changing arch file
#(but will only affect if the values match up to a repo arch value)

#Add board_variant and board archs right after first level hiearchy which is MACHINE
sed -i "s/:/:${BOARD_VARIANT}:${BOARD}:/" /etc/dnf/vars/arch

#Add board_variant and board archs to arch_compat (order doesnt matter here)
sed -i "s/^arch_compat.*/& ${BOARD} ${BOARD_VARIANT}/"  /etc/rpmrc
