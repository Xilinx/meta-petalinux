#! /bin/sh

### BEGIN INIT INFO
# Provides: Ultra96 power button monitoring script
# Required-Start:
# Required-Stop:
# Default-Start:S
# Default-Stop:
# Short-Description: Monitors the power button and powers off the board
# Description:       This script runs a utility that monitors GPIO pin 364 and
#                    powers off the Ultra96 board when the button is pushed.
### END INIT INFO

DESC="ultra96-power-button.sh powers off the board when the power button is pushed"
PWRUTIL="/sbin/ultra96-power-button-check"
PWRUTIL_CMD="/sbin/poweroff"
PWRUTIL_BASE=$(grep -il zynqmp_gpio /sys/class/gpio/gpiochip*/label | grep -o "[0-9]*")
PWRUTIL_PIN=$[PWRUTIL_BASE+26]
PWRUTIL_PID_NAME="ultra96-power-button"

test -x "$PWRUTIL" || exit 0
test -x "$PWRUTIL_CMD" || exit 0
[ ! -z $PWRUTIL_BASE ] || exit 0

PWRUTIL_OPTS="$PWRUTIL_PIN $PWRUTIL_CMD"

case "$1" in
  start)
    echo -n "Starting Ultra96 Power Button daemon"
    start-stop-daemon --start --quiet --background --make-pidfile --pidfile /var/run/$PWRUTIL_PID_NAME.pid --exec $PWRUTIL -- $PWRUTIL_OPTS
    echo "."
    ;;
  stop)
    echo -n "Stopping Ultra96 Power Button daemon"
    start-stop-daemon --stop --quiet --pidfile /var/run/$PWRUTIL_PID_NAME.pid
    ;;
  *)
    echo "Usage: /etc/init.d/ultra96-power-button.sh {start|stop}"
    exit 1
esac

exit 0

