# workaround for a systemd service startedup error
#
#2023-11-30T12:51:42+0000 SUBDEBUG Installed: gstd-1.0+really0.15.00+a011affa67-r0.0.cortexa72_cortexa53
#2023-11-30T12:51:42+0000 INFO %post(gstd-1.0+really0.15.00+a011affa67-r0.0.cortexa72_cortexa53): scriptlet start
#%post(gstd-1.0+really0.15.00+a011affa67-r0.0.cortexa72_cortexa53): execv(/bin/sh) pid 3485514
#+ set -e
#+ systemctl
#+ OPTS=
#+ [ -n .../build/tmp/work/zynqmp_generic-xilinx-linux/petalinux-image-minimal/1.0/rootfs ]
#+ OPTS=--root=.../build/tmp/work/zynqmp_generic-xilinx-linux/petalinux-image-minimal/1.0/rootfs
#+ [ enable = enable ]
#+ systemctl --root=.../build/tmp/work/zynqmp_generic-xilinx-linux/petalinux-image-minimal/1.0/rootfs enable gstd.service
#Error: Systemctl main enable issue in gstd.service (gstd.service)
#%post(gstd-1.0+really0.15.00+a011affa67-r0.0.cortexa72_cortexa53): waitpid(3485514) rc 3485514 status 100
#warning: %post(gstd-1.0+really0.15.00+a011affa67-r0.0.cortexa72_cortexa53) scriptlet failed, exit status 1
#
#2023-11-30T12:51:42+0000 ERROR Error in POSTIN scriptlet in rpm package gstd
#2023-11-30T12:51:42+0000 SUBDEBUG Installed: meson-1.2.2-r0.0.cortexa72_cortexa53
#2023-11-30T12:51:42+0000 SUBDEBUG Installed: can-utils-2023.03-r0.0.cortexa72_cortexa53
#2023-11-30T12:51:42+0000 INFO %post(can-utils-2023.03-r0.0.cortexa72_cortexa53): scriptlet start
#%post(can-utils-2023.03-r0.0.cortexa72_cortexa53): execv(/bin/sh) pid 3485517

SYSTEMD_SERVICE:${PN} = ""
