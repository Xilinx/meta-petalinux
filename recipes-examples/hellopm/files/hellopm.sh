#!/bin/sh

#*******************************************************************************
#
# Copyright (C) 2018 Xilinx, Inc. All rights reserved.
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
#
# Use of the Software is limited solely to applications:
#
# (a) running on a Xilinx device, or
# (b) that interact with a Xilinx device through a bus or interconnect.
#
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# XILINX CONSORTIUM BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
# OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
#
# Except as contained in this notice, the name of the Xilinx shall not be used
# in advertising or otherwise to promote the sale, use or other dealings in
# this Software without prior written authorization from Xilinx.
#
# Author:     Will Wong <willw@xilinx.com>
#
# ******************************************************************************

# Xilinx Power Management Demo

# Stop on errors
set -e

get_node_status () {

	echo get_node_status $1 > /sys/kernel/debug/zynqmp_pm/power
	dmesg | tail -n 5 > status.log
	STATUS=$(awk '/Status/ {print $4;}' status.log)
	REQUIREMENTS=$(awk '/Requirements/ {print $4;}' status.log)
	USAGE=$(awk '/Usage/ {print $4;}' status.log)
}


suspend_menu () {
	while true; do
		cat <<-EOF

		++++++++++++++++++
		+ Suspend/Resume +
		++++++++++++++++++

		EOF

		cat <<-EOF

		This operation suspends the kernel and powers off the processor.  All
		peripherals not used as a result of this operation will be powered
		down or put into retention mode.  (Note that peripherals that are still
		being used by the RPU, such as memory, will not be powered down.)

		If no peripherals on the FPD are being used as a result of this operation,
		the FPD will be powered off.

		While the processor is suspended, all the data and context information is
		stored in the DRAM.  If the FPD is powered off, the DRAM will be put into
		self-refresh mode.

		Options:
		1. Suspend now, wake-up on Real-time Clock (RTC)
		0. Go Back

		EOF
		echo -n "Input: "
		read choice
		echo ""


		case $choice in
		0)
			break
			;;
		1)
			cat <<-EOF

			Suspending now, wake-up on Real-time Clock (RTC)

			Enable RTC as the wake-up source.
			Command: echo +10 > /sys/class/rtc/rtc0/wakealarm

			EOF

			echo +10 > /sys/class/rtc/rtc0/wakealarm

			cat <<-EOF

			Invoke suspend sequence
			Command: echo mem > /sys/power/state
			Waking up in about 10 seconds ...

			EOF
			sleep 1
			echo mem > /sys/power/state

			echo "Press RETURN to continue ..."
			read dummy
			;;
		esac
	done
	echo ""
}


cpu_hotplug_menu () {
	while true; do
		cat <<-EOF
		+++++++++++++++
		+ CPU Hotplug +
		+++++++++++++++

		EOF

		cat <<-EOF
		This operation brings individual CPU cores online and offline.  Processes
		running on a CPU core will be moved over to another core before the core
		is taken offline."

		CPU Hotlplug is different from, but can be operating along with, CPU Idle.
		The latter is having the kernel power off CPU cores when they are idling.

		Options:
		1. Check CPU3 Status
		2. Take CPU3 Offline
		3. Bring CPU3 Online
		0. Go Back

		EOF
		echo -n "Input: "
		read choice
		echo ""


		case $choice in
		0)
			break
			;;
		1)
			cat <<-EOF
			Check CPU3 Status

			Command: cat /sys/devices/system/cpu/cpu3/online

			EOF

			echo `cat /sys/devices/system/cpu/cpu3/online`
			echo ""
			echo "Press RETURN to continue ..."
			read dummy
			echo ""
			;;
		2)
			cat <<-EOF
			Take CPU3 Offline

			Command: echo 0 > /sys/devices/system/cpu/cpu3/online
			EOF
			echo `echo 0 > /sys/devices/system/cpu/cpu3/online`
			echo ""
			echo "Press RETURN to continue ..."
			read dummy
			echo ""
			;;
		3)
			cat <<-EOF
			Bring CPU3 Online

			Command: echo 1 > /sys/devices/system/cpu/cpu3/online
			EOF
			echo `echo 1 > /sys/devices/system/cpu/cpu3/online`
			echo ""
			echo "Press RETURN to continue ..."
			read dummy
			echo ""
			;;
		esac
	echo ""
	done
}

cpu_freq_menu () {
	while true; do
		cat <<-EOF
		++++++++++++
		+ CPU Freq +
		++++++++++++

		EOF

		cat <<-EOF
		This feature adjusts the CPU frequency on-the-fly.  All CPU cores are running
		at the same frequency.  A lower CPU frequency consumes less power, at the
		expense of performance.

		The CPU frequency can be adjusted automatically by a governor, which controls
		the CPU frequency based on its policy.  A special 'userspace' governor does
		not actually adjust the CPU frequency.  Instead, it allows the users to
		adjust the CPU frequency by themselves."

		Options:
		1. Show current CPU frequency
		2. List supported CPU frequencies
		3. Change CPU frequency
		0. Go Back

		EOF
		echo -n "Input: "
		read choice
		echo ""

		case $choice in
		0)
			break
			;;
		1)
			cat <<-EOF
			Show current CPU frequency

			Command: cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
			EOF

			echo `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`
			echo ""
			echo "Press RETURN to continue ..."
			read dummy
			echo ""
			;;
		2)
			cat <<-EOF
			List supported CPU frequencies

			Command: cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_available_frequencies
			EOF

			echo `cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_available_frequencies`
			echo ""
			echo "Press RETURN to continue ..."
			read dummy
			echo ""
			;;
		3)
			echo "Change CPU frequency"
			echo ""
			echo -n "Enter new frequency: "
			read freq
			echo "Command: echo $freq > /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed"
			echo `echo $freq > /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed`
			echo ""
			echo "Press RETURN to continue ..."
			read dummy
			echo ""
			;;
		esac
	done
	echo ""
}

reboot_menu () {
	while true; do
		cat <<-EOF
		++++++++++
		+ Reboot +
		++++++++++

		EOF

		cat <<-EOF
		There are 3 types of reboot: APU-only, PS-only and System reboot. APU-only
		reboot will only reboot the APU.  The RPU, PMU and PL will not be affected.

		PS-only reboot will reboot the PS, including the APU, RPU and PMU.
		The PL will not be affected by a PS-only reboot, provided that the PL
		is completely isolated from the PS.

		System reboot will reboot the entire system, including the PS and the PL.

		Options:
		1. Reboot APU
		2. Reboot PS
		3. Reboot System
		0. Go Back

		EOF
		echo -n "Input: "
		read choice
		echo ""

		case $choice in
		0)
			break
			;;
		1)
			echo "Reboot APU"
			echo ""
			echo -n "This will end the demo.  Continue (Y/n)? "

			read continue

			if [ "$continue" != "n" ] && [ "$continue" != "N" ]; then 
				cat <<-EOF
				Set reboot scope to APU
				Command: echo system_shutdown 2 0 > /sys/kernel/debug/zynqmp_pm/power
				EOF
				echo `echo system_shutdown 2 0 > /sys/kernel/debug/zynqmp_pm/power`
				echo ""
				echo "Command: reboot"
				echo ""
				reboot
				while true; do
					read dummy
				done
			fi
			;;
		2)
			echo "Reboot PS"
			echo ""
			echo -n "This will end the demo.  Continue (Y/n)? "

			read continue

			if [ "$continue" != "n" ] && [ "$continue" != "N" ]; then
				echo "Set reboot scope to PS"
				echo "Command: echo system_shutdown 2 1 > /sys/kernel/debug/zynqmp_pm/power"
				echo `echo system_shutdown 2 1 > /sys/kernel/debug/zynqmp_pm/power`
				echo ""

				echo "Command: reboot"
				echo ""
				reboot
				while true; do
					read dummy
				done
			fi
			;;
		3)
			echo "Reboot System"
			echo ""
			echo -n "This will end the demo.  Continue (Y/n)? "

			read continue
			echo ""
			if [ "$continue" != "n" ] && [ "$continue" != "N" ]; then
				cat <<-EOF
				Set reboot scope to System
				Command: echo system_shutdown 2 2 > /sys/kernel/debug/zynqmp_pm/power
				EOF

				echo `echo system_shutdown 2 2 > /sys/kernel/debug/zynqmp_pm/power`
				echo ""
				echo "Command: reboot"
				echo ""
				reboot
				while true; do
					read dummy
				done
			fi
			;;
		esac
	done
	echo ""
}

shutdown_menu () {
	while true; do
		cat <<-EOF
		++++++++++++
		+ Shutdown +
		++++++++++++

		EOF

		cat <<-EOF
		The command will shut down the APU. The RPU and PL will not be affected.

		Options:
		1. Shutdown APU
		0. Go Back

		EOF

		echo -n "Input: "
		read choice
		echo ""

		case $choice in
		0)
			break
			;;
		1)
			echo "Shutdown APU"
			echo ""
			echo -n "This will end the demo.  Continue (Y/n)? "
			read continue
			echo ""
			if [ "$continue" != "n" ] && [ "$continue" != "N" ]; then
				echo "Command: shutdown -h now"
				echo ""
				shutdown -h now
				while true; do
					read dummy
				done
			fi
			;;
		esac
	done
	echo ""
}


node_status_menu () {
	while true; do
		cat <<-EOF
		+++++++++++++++
		+ Node Status +
		+++++++++++++++

		EOF

                cat <<-EOF
		The command will give the list of all the available nodes, status of one or all the nodes

		Options:
		1. List all nodes
		2. Get Status of particular node
		3. Get Status of all nodes
		0. Go Back

		EOF

		echo -n "Input: "
		read choice
		echo ""

		case $choice in
		0)
			break
			;;
		1)
			cat <<-'EOF'
			List of All the available nodes

			1 "APU"
			2 "APU_0"
			3 "APU_1"
			4 "APU_2"
			5 "APU_3"
			6 "RPU"
			7 "RPU_0"
			8 "RPU_1"
			9 "PLD"
			10 "FPD"
			11 "OCM_BANK0"
			12 "OCM_BANK1"
			13 "OCM_BANK2"
			14 "OCM_BANK3"
			15 "TCM_0_A"
			16 "TCM_0_B"
			17 "TCM_1_A"
			18 "TCM_1_B"
			19 "L2"
			20 "GPU_PP_0"
			21 "GPU_PP_1"
			22 "USB_0"
			23 "USB_1"
			24 "TTC_0"
			25 "TTC_1"
			26 "TTC_2"
			27 "TTC_3"
			28 "SATA"
			29 "ETH_0"
			30 "ETH_1"
			31 "ETH_2"
			32 "ETH_3"
			33 "UART_0"
			34 "UART_1"
			35 "SPI_0"
			36 "SPI_1"
			37 "I2C_0"
			38 "I2C_1"
			39 "SD_0"
			40 "SD_1"
			41 "DP"
			42 "GDMA"
			43 "ADMA"
			44 "NAND"
			45 "QSPI"
			46 "GPIO"
			47 "CAN_0"
			48 "CAN_1"
			49 "EXTERN"
			50 "APLL"
			51 "VPLL"
			52 "DPLL"
			53 "RPLL"
			54 "IOPLL"
			55 "DDR"
			56 "IPI_APU"
			57 "IPI_RPU_0"
			58 "GPU"
			59 "PCIE"
			60 "PCAP"
			61 "RTC"
			62 "LPD"
			63 "VCU"
			64 "IPI_RPU_1"
			65 "IPI_PL_0"
			66 "IPI_PL_1"
			67 "IPI_PL_2"
			68 "IPI_PL_3"
			69 "PL"

			Press RETURN to continue ...

			EOF
			read dummy
			;;


		2)
			echo "Get Status of Node of the particular Node"
			echo ""
			echo  -n "Enter Node Number: "
			read node
			echo $node
			echo ""
			echo "get_node_status $node > /sys/kernel/debug/zynqmp_pm/power"
			echo ""
			echo get_node_status $node > /sys/kernel/debug/zynqmp_pm/power
			echo ""
			echo "Press RETURN to continue ..."
			read dummy
			;;
		3)
			echo "Get Status of All nodes"
			echo ""
			get_node_status  1 "APU"
			get_node_status  2 "APU_0"
			get_node_status  3 "APU_1"
			get_node_status  4 "APU_2"
			get_node_status  5 "APU_3"
			get_node_status  6 "RPU"
			get_node_status  7 "RPU_0"
			get_node_status  8 "RPU_1"
			get_node_status  9 "PLD"
			get_node_status 10 "FPD"
			get_node_status 11 "OCM_BANK0"
			get_node_status 12 "OCM_BANK1"
			get_node_status 13 "OCM_BANK2"
			get_node_status 14 "OCM_BANK3"
			get_node_status 15 "TCM_0_A"
			get_node_status 16 "TCM_0_B"
			get_node_status 17 "TCM_1_A"
			get_node_status 18 "TCM_1_B"
			get_node_status 19 "L2"
			get_node_status 20 "GPU_PP_0"
			get_node_status 21 "GPU_PP_1"
			get_node_status 22 "USB_0"
			get_node_status 23 "USB_1"
			get_node_status 24 "TTC_0"
			get_node_status 25 "TTC_1"
			get_node_status 26 "TTC_2"
			get_node_status 27 "TTC_3"
			get_node_status 28 "SATA"
			get_node_status 29 "ETH_0"
			get_node_status 30 "ETH_1"
			get_node_status 31 "ETH_2"
			get_node_status 32 "ETH_3"
			get_node_status 33 "UART_0"
			get_node_status 34 "UART_1"
			get_node_status 35 "SPI_0"
			get_node_status 36 "SPI_1"
			get_node_status 37 "I2C_0"
			get_node_status 38 "I2C_1"
			get_node_status 39 "SD_0"
			get_node_status 40 "SD_1"
			get_node_status 41 "DP"
			get_node_status 42 "GDMA"
			get_node_status 43 "ADMA"
			get_node_status 44 "NAND"
			get_node_status 45 "QSPI"
			get_node_status 46 "GPIO"
			get_node_status 47 "CAN_0"
			get_node_status 48 "CAN_1"
			get_node_status 49 "EXTERN"
			get_node_status 50 "APLL"
			get_node_status 51 "VPLL"
			get_node_status 52 "DPLL"
			get_node_status 53 "RPLL"
			get_node_status 54 "IOPLL"
			get_node_status 55 "DDR"
			get_node_status 56 "IPI_APU"
			get_node_status 57 "IPI_RPU_0"
			get_node_status 58 "GPU"
			get_node_status 59 "PCIE"
			get_node_status 60 "PCAP"
			get_node_status 61 "RTC"
			get_node_status 62 "LPD"
			get_node_status 63 "VCU"
			get_node_status 64 "IPI_RPU_1"
			get_node_status 65 "IPI_PL_0"
			get_node_status 66 "IPI_PL_1"
			get_node_status 67 "IPI_PL_2"
			get_node_status 68 "IPI_PL_3"
			get_node_status 69 "PL"
			echo ""
			echo "Press RETURN to continue ..."
			read dummy
			echo ""
			;;
		esac
	done
	echo ""


}



main_menu () {
	while true; do

		cat <<-EOF

		+++++++++++++
		+ Main Menu +
		+++++++++++++

		EOF

                cat <<-EOF

		These are Linux-based power management features available for the
		Zynq (c) UltraScale+ MPSoC.  These examples assume you are using
		the ZCU102 board, although most of them are independent of the
		board type.

		Options:
		1. Suspend/Resume
		2. CPU Hotplug
		3. CPU Freq
		4. Reboot
		5. Shutdown
		6. Node Status
		0. Quit

		EOF

		echo -n "Input: "
		read choice
		echo ""

		case $choice in
		0)
			break
			;;
		1)
			suspend_menu
			;;
		2)
			cpu_hotplug_menu
			;;
		3)
			cpu_freq_menu
			;;
		4)
			reboot_menu
			;;
		5)
			shutdown_menu
			;;
		6)
		    node_status_menu

		esac
	done
	echo ""
}

echo ""
cat <<-EOF
============================
      Hello PM World
Xilinx Power Management Demo
============================
EOF
echo ""

main_menu
echo ""

