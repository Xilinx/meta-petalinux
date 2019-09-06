#!/bin/sh

###############################################################################
#
# Copyright (C) 2019 Xilinx, Inc.  All rights reserved.
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# Author:     Mounika Grace Akula <makula@xilinx.com>
#
###############################################################################

### BEGIN INIT INFO
# Provides:          watchdog-startup
# Required-Start:
# Required-Stop:
# Default-Start:     S
# Default-Stop:
# Short-Description: User specific startup functionality for mpsrm design
# Description:       This script starts the WDT and kicks it at regular
#                    intervals using Linux System calls. Failing to kick
#                    the WDT will trigger an interrupt to PMU when
#                    reset-on-timeout property is enabled. PMU will
#                    trigger restart escalation. This script also marks
#                    the current boot as healthy by setting healthy bit.
#		     Following arguments can be passed to this script:
#			start --> Set the healthy bit and start wdt
#			stop --> Stop wdt
#			restart --> stop followed by start
#			set_healthy -> mark healthy status as true
#			unset_healthy -> mark healthy status as false
#			start_wdt --> start wdt
#			stop_wdt --> stop wdt
#
### END INIT INFO

DESC="Watchdog script to start and kick the FPD WDT monitored by pmu-fw"
WDT_DEVICE=/dev/watchdog0
WDT_TIMEOUT=60
WDT_RESTART=30

HEALTHY_STATUS="/sys/firmware/zynqmp/health_status"
HEALTHY="1"
NOT_HEALTHY="0"


wdt_start() {

	[ -e $WDT_DEVICE ] || exit 1

	case "$1" in
		on)
			echo "Starting WDT"
			watchdog -T $WDT_TIMEOUT -t $WDT_RESTART $WDT_DEVICE
			;;
		off)
			echo "Stoping WDT"
			killall watchdog 2>/dev/null
			;;
		*)
			echo "Invalid arg to wdt_start $1"
			exit 1
			;;
	esac


}

do_healthy() {

	[ -e $HEALTHY_STS ] || exit 1

	case "$1" in
		set)
			# -- deprecated : /usr/local/bin/set_boot_healthy
			echo "Set healthy bit"
			echo $HEALTHY > $HEALTHY_STATUS
			;;
		unset)
			echo "Clear healthy bit"
			echo $NOT_HEALTHY > $HEALTHY_STATUS
			;;
		*)
			echo "Invalid arg to healthy $1"
			exit 1
			;;
	esac
}

do_start() {

	do_healthy "set"
	wdt_start "on"

}

do_stop() {

	#Note: We donot unset healthy bit, as the boot was successful.
	wdt_start "off"

}

case "$1" in
	start)
		do_start
		;;
	stop)
		do_stop
		;;
	restart)
		do_stop
		do_start
		;;
	set_healthy)
		do_healthy "set"
		;;
	unset_healthy)
		do_healthy "unset"
		;;
	start_wdt)
		wdt_start "on"
		;;
	stop_wdt)
		wdt_start "off"
		;;
	*)
		echo "Usage: $0 {start|stop|restart|set_healthy|unset_healthy|start_wdt|stop_wdt}"
		exit 1
		;;
esac
