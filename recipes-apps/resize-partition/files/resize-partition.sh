#!/bin/sh

# Expand the sd card partition to 100% from unpartitioned space.
#
# Usage: resize-part "/dev/mmcblk0p3"

partition="/dev/mmcblk0p3"

echo "Expanding the Partition:${partition} to 100%"
/usr/bin/resize-part ${partition}
