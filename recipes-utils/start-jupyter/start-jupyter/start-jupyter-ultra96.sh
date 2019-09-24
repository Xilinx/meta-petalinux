#!/bin/bash
#*******************************************************************************
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
#
#*******************************************************************************
ifconfig lo up
cd /usr/share/notebooks
notebook_args="--no-browser --allow-root --ip=192.168.2.1 --port=8888"

export BOARD="PLACEHOLDER"

#check if jupyter notebook is already started,if so then dont start
ip=$(ifconfig wlan1 | grep "inet addr" | cut -d : -f 2 | cut -d ' ' -f 1)
i=0
while [ "${ip:0:3}" != "192" ]
do
        echo "CONNECTING... $i seconds" >> /var/log/jupyter.log
        sleep 2
        i=$(( $i + 2 ))
        ip=$(( ifconfig wlan1 | grep "inet addr" | cut -d : -f 2 | cut -d ' ' -f ))
done
sleep 10
echo "Connected to WLAN1" >> /var/log/jupyter.log
f_ip=$(ifconfig wlan1 | grep "inet addr" | cut -d : -f 2 | cut -d ' ' -f 1)
echo $f_ip >> /var/log/jupyter.log
jupyter notebook $notebook_args >> /var/log/jupyter.log  2>&1 &
