#!/bin/bash
#
# Get RAW YUV frames from videotestsrc and encode it with HDR10 metadata
#
# Copyright (C) 2020 Xilinx
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
declare -a scriptArgs=("videoSize" "codecType" "outputPath" "numFrames" "targetBitrate" "showFps" "frameRate" "gopLength" "periodicityIdr" "colorFormat" "displayPrimaries" "whitePoint" "displayLuminance" "maxCLL" "maxFALL")
declare -a checkEmpty=("codecType" "targetBitrate" "sinkName" "frameRate" "gopLength" "periodicityIdr" "colorFormat" "displayPrimaries" "whitePoint" "displayLuminance" "maxCLL" "maxFALL")


############################################################################
# Name:		usage
# Description:	To display script's command line argument help
############################################################################
usage () {
	echo '	Usage : '$scriptName' -s <video_size> -c <codec_type> -o <output_path> -n <number_of_frames> -b <target_bitrate> -r <frame_rate> -f --gop-length <gop_length> --periodicity-idr <periodicity_idr> --color-format <color_format> --display-primaries <red_x>:<red_y>:<green_x>:<green_y>:<blue_x>:<blue_y> --white-point <x>:<y> --display-luminance <max>:<min> --max-cll <max_cll> --max-fall <max_fall>'
	DisplayUsage "${scriptArgs[@]}"
	echo '  Example :'
	echo '  '$scriptName''
	echo '  '$scriptName' -o /mnt/sata/op.ts'
	echo '  '$scriptName' --gop-length 45'
	echo '  '$scriptName' --gop-length 45 --periodicity-idr 45'
	echo '  '$scriptName' -n 500'
	echo '  '$scriptName' -n 500 -b 1200'
	echo '  '$scriptName' -f'
	echo '  '$scriptName' -s 1920x1080 -c avc'
	echo '  "NOTE: This script depends on vcu-demo-settings.sh to be present in /usr/bin or its path set in $PATH"'
	exit
}

############################################################################
# Name:		VideoTestSrcToFile
# Description:	Get RAW YUV frames from videotestsrc and encode it with HDR metadata
############################################################################
VideoTestSrcToFile() {
	OMXH264ENC="$OMXH264ENC control-rate=constant b-frames=2 gop-length=$GOP_LENGTH periodicity-idr=$PERIODICITY_IDR prefetch-buffer=true target-bitrate=$BIT_RATE  ! video/x-h264, alignment=au"
	OMXH265ENC="$OMXH265ENC control-rate=constant b-frames=2 gop-length=$GOP_LENGTH periodicity-idr=$PERIODICITY_IDR prefetch-buffer=true target-bitrate=$BIT_RATE ! video/x-h265, alignment=au"
	IFS='x' read WIDTH HEIGHT <<< "$VIDEO_SIZE"

	case $CODEC_TYPE in
	"avc")
		ENC_PARSER=$H264PARSE
		DEC_PARSER=$H264PARSE
		ENCODER=$OMXH264ENC
		if [ -z $OUTPUT_PATH ]; then
			DIR_NAME=$(pwd)
			OUTPUT_PATH="$DIR_NAME/output.avc"
		fi
		;;
	"hevc")
		ENC_PARSER=$H265PARSE
		DEC_PARSER=$H265PARSE
		ENCODER=$OMXH265ENC
		if [ -z $OUTPUT_PATH ]; then
			DIR_NAME=$(pwd)
			OUTPUT_PATH="$DIR_NAME/output.hevc"
		fi
		;;
	esac


	SINK="$FILESINK=$OUTPUT_PATH"
	OUTPUT_FILE_NAME=$(basename "$OUTPUT_PATH")
	OUTPUT_EXT_TYPE="${OUTPUT_FILE_NAME##*.}"
	if [ $SHOW_FPS ]; then
		SINK="fpsdisplaysink name=fpssink text-overlay=false video-sink=fakesink sync=true -v"
	fi

	if [ $NUM_FRAMES ]; then
		VIDEOTESTSRC="$VIDEOTESTSRC num-buffers=$NUM_FRAMES"
	fi

	YUV_CAPS="video/x-raw,width=$WIDTH,height=$HEIGHT,framerate=$FRAME_RATE/1, format=\(string\)$COLOR_FORMAT, colorimetry=\(string\)bt2100-pq, mastering-display-info=\(string\)$DISPLAY_PRIMARIES:$WHITE_POINT:$DISPLAY_LUMINANCE, content-light-level=\(string\)$MAX_CLL:$MAX_FALL"

	GST_LAUNCH="$GST_LAUNCH -e"

	pipeline="$GST_LAUNCH $VIDEOTESTSRC ! $YUV_CAPS ! $ENCODER ! $ENC_PARSER ! $QUEUE ! $SINK"

	runGstPipeline "$pipeline"
}

# Command Line Argument Parsing
args=$(getopt -o "s:c:o:n:r:b:fh" --long "video-size:,codec-type:,output-path:,num-frames:,bit-rate:,frame-rate:,gop-length:,periodicity-idr:,color-format:,display-primaries:,white-point:,display-luminance:,max-cll:,max-fall:,show-fps,help" -- "$@")

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
VideoTestSrcToFile
