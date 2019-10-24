#!/bin/bash
#*******************************************************************************
#
# Copyright (C) 2019 Xilinx, Inc.  All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies  of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#**********************************************************************
echo "netip is " > /var/log/jupyter.log net_ip=$(ip route | grep src | awk '{print $NF; exit}') echo $net_ip >> /var/log/jupyter.log

i=0
while [ -z "$net_ip" ]
do
        echo "CONNECTING... $i seconds" >> /var/log/jupyter.log
        net_ip=$(ip route | grep src | awk '{print $NF; exit}')
        echo "netip is " >> /var/log/jupyter.log
        echo $net_ip >> /var/log/jupyter.log
        sleep 2
        i=$(( $i + 2 ))
done

jupyter nbextension enable --py widgetsnbextension
notebook_args="--no-browser --allow-root --ip=$net_ip"
jupyter notebook $notebook_args >> /var/log/jupyter.log
