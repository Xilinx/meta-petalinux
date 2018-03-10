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
declare -a scriptArgs=("videoSize" "codecType" "sinkName" "numFrames" "showFps" "internalEntropyBuffers" "v4l2Device")
declare -a checkEmpty=("codecType" "sinkName" "v4l2Device")


############################################################################
# Name:		usage
# Description:	To display script's command line argument help
############################################################################
usage () {
	echo '	Usage : '$scriptName' -v <video_capture_device> -s <video_size> -c <codec_type> -o <sink_name> -n <number_of_frames> -e <internal_entropy_buffers> -f'
	DisplayUsage "${scriptArgs[@]}"
	echo '  Example :'
	echo '  '$scriptName''
	echo '  '$scriptName' -v "/dev/video1"'
	echo '  '$scriptName' -n 500'
	echo '  '$scriptName' -f'
	echo '  '$scriptName' -f -o fakevideosink'
	echo '  '$scriptName' -s 1920x1080 -c avc'
	echo '  '$scriptName' -s 1920x1080 -c avc -e 2'
	echo '  '$scriptName' -s 1280x720 -c avc'
	echo '  "NOTE: This script depends on vcu-demo-functions.sh to be present in /usr/bin or its path set in $PATH"'
	exit
}

############################################################################
# Name:		CameraToDisplay
# Description:	Display encoded data coming from camera
############################################################################
CameraToDisplay() {
	if [ $SHOW_FPS ]; then
		SINK="fpsdisplaysink name=fpssink text-overlay=false video-sink="$SINK_NAME" sync=true -v"
	else
		SINK="$SINK_NAME"
	fi
	if [ $NUM_FRAMES ]; then
		V4L2SRC="$V4L2SRC num-buffers=$NUM_FRAMES"
	fi

	IFS='x' read WIDTH HEIGHT <<< "$VIDEO_SIZE"
	CAMERA_CAPS_AVC="video/x-h264,width=$WIDTH,height=$HEIGHT,framerate=30/1,profile=constrained-baseline,level=\(string\)4.0"
	CAMERA_CAPS_HEVC="video/x-h265,width=$WIDTH,height=$HEIGHT,framerate=30/1"

	OMXH264DEC="$OMXH264DEC latency-mode=reduced-latency internal-entropy-buffers=$INTERNAL_ENTROPY_BUFFERS"
	OMXH265DEC="$OMXH265DEC latency-mode=reduced-latency internal-entropy-buffers=$INTERNAL_ENTROPY_BUFFERS"

	if [ $CODEC_TYPE == "avc" ]; then
		pipeline="$GST_LAUNCH $V4L2SRC ! $CAMERA_CAPS_AVC ! $H264PARSE ! $OMXH264DEC ! $QUEUE ! $SINK"
	else
		pipeline="$GST_LAUNCH $V4L2SRC ! $CAMERA_CAPS_HEVC ! $H265PARSE ! $OMXH265DEC ! $QUEUE ! $SINK"
	fi

	runGstPipeline "$pipeline"
	killProcess "modetest"
	killProcess "sleep"
}

# Command Line Argument Parsing
args=$(getopt -o "v:s:c:o:n:e:fh" --long "video-capture-device:,video-size:,codec-type:,sink-name:,num-frames:,internal-entropy-buffers:,show-fps,help" -- "$@")

[ $? -ne 0 ] && usage && exit -1

trap catchCTRL_C SIGINT
parseCommandLineArgs
checkforEmptyVar "${checkEmpty[@]}"
if [ -z $VIDEO_SIZE ]; then
	VIDEO_SIZE="1920x1080"
	echo "Video Size is not specified in args hence using 1920x1080 as default value"
fi

RegSetting
CameraToDisplay
