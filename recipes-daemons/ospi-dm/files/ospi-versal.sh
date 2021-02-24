#!/bin/sh
LOGFILE="/var/log/ospi_logs"

function write_log() {
        now_time='['$(date +"%Y-%m-%d %H:%M:%S")']'
        echo $now_time $1 | tee -a "$LOGFILE"
}

write_log 'Start OSPI Versal Daemon'

SYSFSDIR="/sys/devices/platform/amba/20103008000.ospi_versal/"
READYFILE="${SYSFSDIR}pdi_ready"
DONEFILE="${SYSFSDIR}pdi_done"
PDIFILE="versal_pdi"
HOMEDIR="/home/root/"
MTD0="/dev/mtd0"

while true
do
	READYVALUE=$(cat $READYFILE)

	if [ $READYVALUE == 1 ]
	then
		write_log 'programing the flash...'
		write_log "cp ${SYSFSDIR}${PDIFILE} ${HOMEDIR}"
		cp ${SYSFSDIR}${PDIFILE} ${HOMEDIR}
		write_log "flashcp ${HOMEDIR}${PDIFILE} ${MTD0}"
		flashcp ${HOMEDIR}${PDIFILE} ${MTD0} 
		if [ $? == 0 ]
		then
			write_log 'program done'
			echo '1' > ${DONEFILE}
		else
			write_log 'program fail'
			echo '2' > ${DONEFILE}
		fi
	fi

	sleep 5
done
