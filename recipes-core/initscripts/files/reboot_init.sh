#!/bin/sh
### BEGIN INIT INFO
# Provides:          set_reboot
# Required-Start:
# Required-Stop:
# Default-Start:     S
# Default-Stop:
# Short-Description: Set reboot type based on /etc/default/reboot
### END INIT INFO

[ -f /etc/default/reboot ] &&
	set_reboot `cat /etc/default/reboot`
