#! /bin/sh

### BEGIN INIT INFO
# Provides: wl18xx startup script
# Required-Start:
# Required-Stop:
# Default-Start:S
# Default-Stop:
# Short-Description: startup functionality for wl18xx driver
# Description:       This script runs the daemon for providing wl18xx required
#                    for bluetooth and wifi.
### END INIT INFO

DESC="wl18xx provides required driver for bluetooth and Wifi"
HCIATTACH="/usr/bin/hciattach"
HCI_OPTS="-n /dev/ttyPS1 texas"
WL18XX_PID_NAME="wl18xx"
WL18XX_PWR_LED="/sys/class/leds/bt_power/brightness"

test -x "$HCIATTACH" || exit 0

case "$1" in
  start)
    echo -n "Starting wl18xx Bluetooth daemon"
    echo 255 > $WL18XX_PWR_LED
    sleep 1
    start-stop-daemon --start --quiet --background --make-pidfile --pidfile /var/run/$WL18XX_PID_NAME.pid --exec $HCIATTACH -- $HCI_OPTS
    echo "."
    ;;
  stop)
    echo -n "Stopping wl18xx Bluetooth daemon"
    start-stop-daemon --stop --quiet --pidfile /var/run/$WL18XX_PID_NAME.pid
    echo 0 > $WL18XX_PWR_LED
    sleep 1
    echo 255 > $WL18XX_PWR_LED
    sleep 1
    echo 0 > $WL18XX_PWR_LED
    echo "."
    ;;
  *)
    echo "Usage: /etc/init.d/wl18xx {start|stop}"
    exit 1
esac

exit 0

