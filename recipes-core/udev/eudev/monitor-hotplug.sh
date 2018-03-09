#!/bin/sh
#Adapt this script to your needs.

DEVICES=$(find /sys/class/drm/*/status)

#inspired by /etc/acpd/lid.sh and the function it sources

displaynum=`ls /tmp/.X11-unix/* | sed s#/tmp/.X11-unix/X##`
display=":$displaynum.0"
export DISPLAY=":$displaynum.0"

# from https://wiki.archlinux.org/index.php/Acpid#Laptop_Monitor_Power_Off
export XAUTHORITY=$(ps -C Xorg -f --no-header | sed -n 's/.*-auth //; s/ -[^ ].*//; p')

for i in /sys/class/drm/*/*/status ; do
status=$(cat $i);
connector=${i%/status*};
connector=${connector#*-};
if [ "$status" == "disconnected" ];
then
	xset dpms force off
elif [ "$status" == "connected" ];
then
	xset dpms force on
	if [ "$(xrandr | grep '\*')" = "" ];
	then
		xrandr --output $connector --auto
	fi
fi
done
