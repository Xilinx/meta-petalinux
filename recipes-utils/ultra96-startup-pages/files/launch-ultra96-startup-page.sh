#!/bin/bash

source /usr/share/ultra96-startup-pages/webapp/static/ultra96-startup-page.conf
if [ $webapp_on_boot = 1 ]; then
	echo -e "Opening webpage"
	chromium --use-egl --user-data-dir  "http://localhost:80"
else
	echo -e "Not opening webpage"
fi
