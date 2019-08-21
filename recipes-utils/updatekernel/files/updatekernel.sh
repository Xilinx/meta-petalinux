#!/bin/sh

boot_device=""
# get listing of all devices
for i in $(ls /sys/block/ | grep "mmcblk[0-9]\{1,\}$"); do
        # assume mmcblk devices have boot as the first partition
        if [ -e /dev/${i}p1 ]; then
                if [ -z "$boot_device" ]; then
                        boot_device="/dev/${i}p1"
                else
                        echo "Multiple valid boot devices discovered, please make sure the correct boot device is being used"
			exit 1
                fi
        fi
done

if [ -z "$boot_device" ]; then
	echo "mmcblk device not found"
	exit 1
fi

BOOT_DIR=/media
#mount boot device to $BOOT_DIR
if ! mount $boot_device $BOOT_DIR ; then
	echo "Failed to mount boot device ($boot_device)"
	exit 1
else
	NEW_IMAGE=/boot/@@KERNEL_IMAGETYPE@@
	OLD_IMAGE=$BOOT_DIR/@@KERNEL_IMAGETYPE@@
	md5new=$(md5sum "$NEW_IMAGE" | cut -d' ' -f1)
	md5old=$(md5sum "$OLD_IMAGE" | cut -d' ' -f1)

	if [ ! -f $OLD_IMAGE ]; then
		umount $BOOT_DIR
		echo "Boot partition does not have @@KERNEL_IMAGETYPE@@ as expected"
		exit 1
	#Check if @@KERNEL_IMAGETYPE@@ changed
	elif [ "$md5new" == "$md5old" ]; then
		umount $BOOT_DIR
		echo "@@KERNEL_IMAGETYPE@@ is already up to date"
		exit 1
	fi
fi


#Save old @@KERNEL_IMAGETYPE@@ and copy over new @@KERNEL_IMAGETYPE@@
mv -f $OLD_IMAGE ${OLD_IMAGE}_old
cp $NEW_IMAGE $OLD_IMAGE
umount $BOOT_DIR
echo "@@KERNEL_IMAGETYPE@@ updated, ready for restart. Old image is stored $boot_device as @@KERNEL_IMAGETYPE@@_old"
