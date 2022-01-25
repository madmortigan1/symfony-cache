#!/bin/bash

#ipAddress=`ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'`
XdebugFile='/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini'
if [[ "$ENABLE_XDEBUG" == "1" ]] ; then
  echo "XDebug is enabled, creating setup file at: " + $XdebugFile
  echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > $XdebugFile
	echo "xdebug.remote_enable=1"  >> $XdebugFile
	echo "xdebug.remote_log=/tmp/xdebug.log"  >> $XdebugFile
	echo "xdebug.remote_autostart=0"  >> $XdebugFile
	echo "xdebug.remote_handler = \"dbgp\"" >> $XdebugFile
	echo "xdebug.remote_connect_back = 0" >> $XdebugFile
	echo "xdebug.max_nesting_level = 500" >> $XdebugFile
	echo "xdebug.profiler_append = 0" >> $XdebugFile
	echo "xdebug.profiler_enable = 0" >> $XdebugFile
	echo "xdebug.profiler_enable_trigger = 1" >> $XdebugFile
	echo "xdebug.remote_host = host.docker.internal" >> $XdebugFile
	echo "xdebug.remote_mode = req" >> $XdebugFile
	echo "xdebug.idekey = 'PHPSTORM'" >> $XdebugFile
	echo "xdebug.remote_cookie_expire_time = -9999" >> $XdebugFile
	echo "# xdebug.remote_host = ''" >> $XdebugFile
	echo "# xdebug.remote_port = 9000"  >> $XdebugFile
	

	touch /tmp/xdebug.log
	chmod 777 /tmp/xdebug.log
fi

hwclock -su

# Adding cron job to cronta
# echo "* * * * * php /var/www/html/bin/console ts:run >> /dev/null 2>&1" > /etc/crontabs/root
# crond -b -l 8

echo "Completed executing init scripts !!!"