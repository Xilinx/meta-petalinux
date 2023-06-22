#!/bin/bash

eeprom=$(ls /sys/bus/i2c/devices/*50/eeprom 2> /dev/null)
som=$(ipmi-fru --fru-file=${eeprom} --interpret-oem-data | awk -F": " '/^  *FRU Board Product*/ { print tolower ($2) }')
eeprom=$(ls /sys/bus/i2c/devices/*51/eeprom 2> /dev/null)
cc=$(ipmi-fru --fru-file=${eeprom} --interpret-oem-data | awk -F": " '/^  *FRU Board Product*/ { print tolower ($2) }')

BOARD="$(echo "${som}" | awk -F'-' '{print $2"_"$1}')"
BOARD_VARIANT="${BOARD}_$(echo "${cc}" | awk -F'-' '{print $2}')"

#check if dnf configs already updated based off BOARD_VARIANT value
if ! grep "${BOARD_VARIANT}" /etc/dnf/vars/arch > /dev/null
then
    if grep "${BOARD}" /etc/dnf/vars/arch > /dev/null
    then
	#Add board_variant right after first level hiearchy which is MACHINE (Board is assumed to be present as SOM bsps are now built with BOARD defined)
        sed -i "s/:/:${BOARD_VARIANT}:/" /etc/dnf/vars/arch
        #Add board_variant arch to arch_compat (order doesnt matter here)
        sed -i "s/^arch_compat.*/& ${BOARD_VARIANT}/"  /etc/rpmrc

	PACKAGE_FEED_URIS="@@PACKAGE_FEED_URIS@@"
        for URI in ${PACKAGE_FEED_URIS}
        do
                FILE_NAME=$(echo ${URI} | awk -F"petalinux.xilinx.com/" '{print $2}' | sed 's./.-.g')
		REPO_NAME=$(echo ${URI} | awk -F"petalinux.xilinx.com/" '{print $2}' | sed 's./. .g')
                echo -e "[oe-remote-repo-${FILE_NAME}-${BOARD_VARIANT}]\nname=OE Remote Repo: ${REPO_NAME} ${BOARD_VARIANT}\nbaseurl=${URI}/${BOARD_VARIANT}\ngpgcheck=0\n" | tee -a /etc/yum.repos.d/*${FILE_NAME}.repo >/dev/null 2>&1
        done
    else
	echo "Not adding board variant to config as board is not present"
    fi
fi
