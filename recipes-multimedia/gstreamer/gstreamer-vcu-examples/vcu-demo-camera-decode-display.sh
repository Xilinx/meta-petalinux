#!/bin/bash
#
# Decode and display incoming frames from input camera providing encoded data
#
# Copyright (C) 2017 Xilinx
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

type vcu-demo-functions.sh > "/dev/null"
if [ $? -ne 0 ]; then
	echo "Copy vcu-demo-functions.sh to /usr/bin/ or append it's path to PATH variable and re-run the script" && exit -1
fi

source vcu-demo-functions.sh

scriptName=`basename $0`
declare -a scriptArgs=("videoSize" "codecType" "sinkName" "numFrames" "showFps")
declare -a checkEmpty=("codecType" "sinkName")


############################################################################
# Name:		usage
# Description:	To display script's command line argument help
############################################################################
usage () {
	echo '	Usage : '$scriptName' -s <video_size> -c <codec_type> -o <sink_name> -n <number_of_frames> -f'
	DisplayUsage "${scriptArgs[@]}"
	echo '  Example :'
	echo '  '$scriptName''
	echo '  '$scriptName' -n 500'
	echo '  '$scriptName' -f'
	echo '  '$scriptName' -f -o fakesink'
	echo '  '$scriptName' -s 1920x1080 -c avc'
	echo '  '$scriptName' -s 1280x720 -c avc'
	echo '  "NOTE: This script depends on vcu-demo-functions.sh to be present in /usr/bin or its path set in $PATH"'
	exit
}

############################################################################
# Name:		CameraToDisplay
# Description:	Display encoded data coming from camera
############################################################################
CameraToDisplay() {
	checkforEmptyVar "${checkEmpty[@]}"
	if [ $SHOW_FPS ]; then
		SINK="fpsdisplaysink name=fpssink text-overlay=false video-sink=$SINK_NAME sync=true -v"
	else
		SINK="$SINK_NAME"
	fi
	if [ $NUM_FRAMES ]; then
		V4L2SRC="$V4L2SRC num-buffers=$NUM_FRAMES"
	fi

	IFS='x' read WIDTH HEIGHT <<< "$VIDEO_SIZE"
	CAMERA_CAPS_AVC="video/x-h264,width=$WIDTH,height=$HEIGHT,framerate=30/1,profile=constrained-baseline"
	CAMERA_CAPS_HEVC="video/x-h265,width=$WIDTH,height=$HEIGHT,framerate=30/1"
	OMXH264DEC="$OMXH264DEC latency-mode=low-latency internal-entropy-buffers=$INTERNAL_ENTROPY_BUFFERS"
	OMXH265DEC="$OMXH265DEC latency-mode=low-latency internal-entropy-buffers=$INTERNAL_ENTROPY_BUFFERS"

	if [ $CODEC_TYPE == "avc" ]; then
		eval "$GST_LAUNCH $V4L2SRC ! $CAMERA_CAPS_AVC ! $H264PARSE ! $OMXH264DEC ! $QUEUE ! $SINK"&
	else
		eval "$GST_LAUNCH $V4L2SRC ! $CAMERA_CAPS_HEVC ! $H265PARSE ! $OMXH265DEC ! $QUEUE ! $SINK"&
	fi

	PID=$!
	wait $PID

	killProcess "modetest"
	killProcess "sleep"
}

# Command Line Argument Parsing
args=$(getopt -o "s:c:o:n:fh" --long "video-size:,codec-type:,sink-name:,num-frames:,show-fps,help" -- "$@")

[ $? -ne 0 ] && usage && exit -1

parseCommandLineArgs
if [ -z $VIDEO_SIZE ]; then
	VIDEO_SIZE="1920x1080"
	echo "Video Size is not specified in args hence using 1920x1080 as default value"
fi

QoSSetting
drmSetting $VIDEO_SIZE
CameraToDisplay
