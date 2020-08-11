#!/bin/sh
DAEMON=/usr/bin/cmc
start ()
{
	echo " Starting cmc daemon"
	start-stop-daemon -S -o --background -x $DAEMON
}
stop ()
{
	echo " Stoping cmc daemon"
	start-stop-daemon -K -x $DAEMON
}
restart()
{
	stop
	start
}
[ -e $DAEMON ] || exit 1
case "$1" in
	start)
		start; ;;
	stop)
		stop; ;;
	restart)
		restart; ;;
	*)
		echo "Usage: $0 {start|stop|restart}"
		exit 1
esac
exit $?
