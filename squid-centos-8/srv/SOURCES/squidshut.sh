#!/usr/bin/env sh
SQUID_TIMEOUT=34
SQUID=/usr/sbin/squid
echo -n $"Stopping Squid: "
$SQUID -k check >> /var/log/squid/squid.out 2>&1
RETVAL=$?
if [ $RETVAL -eq 0 ] ; then
		$SQUID -k shutdown
		timeout=0
		while : ; do
				[ -f /var/run/squid.pid ] || break
				if [ $timeout -ge $SQUID_TIMEOUT ]; then
						echo "Squid shutdown timeout ran out"
						exit 1
				fi
				sleep 2 && echo -n "."
				timeout=$((timeout+2))
		done
		echo "Finished shutting down squid"
else
		echo "Squid settings file Falied the check"
fi
exit $RETVAL
