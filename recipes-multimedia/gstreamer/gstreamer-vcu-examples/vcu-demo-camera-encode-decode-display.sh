#!/bin/bash
#
# Get RAW YUV frames from Camera, encode it, decode it and display it
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
declare -a scriptArgs=("videoSize" "codecType" "sinkName" "numFrames" "targetBitrate" "showFps" "internalEntropyBuffers" "v4l2Device" "displayDevice")
declare -a checkEmpty=("codecType" "sinkName" "targetBitrate" "v4l2Device" "displayDevice")


############################################################################
# Name:		usage
# Description:	To display script's command line argument help
############################################################################
usage () {
	echo '	Usage : '$scriptName' -v <video_capture_device> -s <video_size> -c <codec_type> -o <sink_name> -n <number_of_frames> -b <target_bitrate> -e <internal_entropy_buffers> -d <display_device> -f'
	DisplayUsage "${scriptArgs[@]}"
	echo '  Example :'
	echo '  '$scriptName''
	echo '  '$scriptName' -d "fd4a0000.zynqmp-display""'
	echo '  '$scriptName' --display-device "fd4a0000.zynqmp-display""'
	echo '  '$scriptName' -v "/dev/video1"'
	echo '  '$scriptName' -n 500'
	echo '  '$scriptName' -n 500 -b 1200'
	echo '  '$scriptName' -f'
	echo '  '$scriptName' -f -o fakevideosink'
	echo '  '$scriptName' -s 1920x1080 -c avc'
	echo '  '$scriptName' -s 1920x1080 -c avc -e 3'
	echo '  '$scriptName' -s 1280x720 -c avc'
	echo '  "NOTE: This script depends on vcu-demo-settings.sh to be present in /usr/bin or its path set in $PATH"'
	exit
}

############################################################################
# Name:		CameraToDisplay
# Description:	Get RAW data from camera, encode it, decode and display it
############################################################################
CameraToDisplay() {
	if [ $SHOW_FPS ]; then
		SINK="fpsdisplaysink name=fpssink text-overlay=false video-sink=\"$SINK_NAME\" sync=true -v"
	else
		SINK="$SINK_NAME"
	fi
	if [ $NUM_FRAMES ]; then
		V4L2SRC="$V4L2SRC num-buffers=$NUM_FRAMES"
	fi

	IFS='x' read WIDTH HEIGHT <<< "$VIDEO_SIZE"
	CAMERA_CAPS_AVC="video/x-raw,width=$WIDTH,height=$HEIGHT,framerate=30/1"
	CAMERA_CAPS_HEVC="video/x-raw,width=$WIDTH,height=$HEIGHT,framerate=30/1"
	VIDEOCONVERT="videoconvert"
	VIDEOCONVERT_CAPS="video/x-raw, format=\(string\)NV12"
	OMXH264ENC="omxh264enc control-rate="low-latency" target-bitrate=$BIT_RATE latency-mode="low-latency""
	OMXH265ENC="omxh265enc control-rate="low-latency" target-bitrate=$BIT_RATE latency-mode="low-latency""
	if [ -z $SET_ENTROPY_BUF ]; then
		INTERNAL_ENTROPY_BUFFERS="6"
	fi
	OMXH264DEC="$OMXH264DEC internal-entropy-buffers=$INTERNAL_ENTROPY_BUFFERS latency-mode="low-latency""
	OMXH265DEC="$OMXH265DEC internal-entropy-buffers=$INTERNAL_ENTROPY_BUFFERS latency-mode="low-latency""

	if [ $CODEC_TYPE == "avc" ]; then
		pipeline="$GST_LAUNCH $V4L2SRC ! $CAMERA_CAPS_AVC ! $VIDEOCONVERT ! $VIDEOCONVERT_CAPS ! $QUEUE max-size-bytes=0 ! $OMXH264ENC ! $QUEUE ! $OMXH264DEC ! $QUEUE max-size-bytes=0 ! $SINK"
	else
		pipeline="$GST_LAUNCH $V4L2SRC ! $CAMERA_CAPS_HEVC ! $VIDEOCONVERT ! $VIDEOCONVERT_CAPS ! $QUEUE max-size-bytes=0 ! $OMXH265ENC ! $QUEUE ! $OMXH265DEC ! $QUEUE max-size-bytes=0 ! $SINK"
	fi

	runGstPipeline "$pipeline"
}

# Command Line Argument Parsing
args=$(getopt -o "v:d:s:c:o:b:n:e:fh" --long "video-capture-device:,display-device:,video-size:,codec-type:,sink-name:,num-frames:,bit-rate:,internal-entropy-buffers:,show-fps,help" -- "$@")

[ $? -ne 0 ] && usage && exit -1

trap catchCTRL_C SIGINT
parseCommandLineArgs
checkforEmptyVar "${checkEmpty[@]}"
if [ -z $VIDEO_SIZE ]; then
	VIDEO_SIZE="640x480"
	echo "Video Size is not specified in args hence using 640x480 as default value"
fi

if [ -z $BIT_RATE ];then
	BIT_RATE=1000
fi

RegSetting
CameraToDisplay
