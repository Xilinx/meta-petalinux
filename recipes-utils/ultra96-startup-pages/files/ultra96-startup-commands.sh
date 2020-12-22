#!/bin/sh

cp /sbin/launch-ultra96-startup-page.desktop /etc/xdg/autostart/
python3 /usr/share/ultra96-startup-pages/webapp/webserver.py
