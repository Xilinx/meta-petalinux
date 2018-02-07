#!/bin/bash
#
# Transcode input h264 file to h265 format and vice versa
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
declare -a scriptArgs=("inputPath" "codecType" "showFps" "targetBitrate" "outputPath" "internalEntropyBuffers")
declare -a checkEmpty=("inputPath" "targetBitrate")


############################################################################
#
# Name:		usage
# Description:	To display script's command line argument help
############################################################################
usage () {
	echo '	Usage : '$scriptName' -i <input_file_path> -b <--bit-rate> -c <codec_type> -o <output_path> -e <internal_entropy_buffers> -f'
	DisplayUsage "${scriptArgs[@]}"
	echo '  Example :'
	echo '  '$scriptName' -i /run/2160p_30.h264 -b 5000'
	echo '  '$scriptName' -i /run/2160p_30.h264 -b 5000 -f'
	echo '  '$scriptName' -i /run/2160p_60.h264 -o /mnt/sata/op.h265'
	echo '  '$scriptName' -i /run/2160p_60.h264 -f'
	echo '  '$scriptName' -i /mnt/sata/2160p_30.mp4 -c avc'
	echo '  '$scriptName' -i /mnt/sata/2160p_60.mp4 -c avc -e 7'
	echo '  '$scriptName' -i /mnt/sdcard/2160p_30.mkv -c hevc'
	echo '  "NOTE: This script depends on vcu-demo-functions.sh to be present in /usr/bin or its path set in $PATH"'
	exit
}

############################################################################
#
# Name:		TranscodeFile
# Description:	Decode input encoded file to YUV
############################################################################
TranscodeFile() {
	checkforEmptyVar "${checkEmpty[@]}"
	updateVar

	if [ ! -f $INPUT_PATH ]; then
		ErrorMsg "Input file doesn't exist"
	fi

	FILE_NAME=$(basename "$INPUT_PATH")
	EXT_TYPE="${FILE_NAME##*.}"

	if [ $EXT_TYPE == "mp4" -o $EXT_TYPE == "mkv" ] && [ -z $CODEC_TYPE ]; then
		echo "No codec type specified for $FILE_NAME hence assuming avc as default codec"
		CODEC_TYPE="avc"
	fi

	if [ -z $OUTPUT_PATH ]; then
		DIR_NAME=$(pwd)
		FILE_NAME_WITHOUTEXT="${FILE_NAME%.*}"
		if [ $EXT_TYPE == "mp4" -o $EXT_TYPE == "mkv" ] && [ $CODEC_TYPE == "avc" ]; then
			OUTPUT_PATH="$DIR_NAME/$FILE_NAME_WITHOUTEXT".h265""
		elif [ $EXT_TYPE == "mp4" -o $EXT_TYPE == "mkv" ] && [ $CODEC_TYPE == "hevc" ]; then
			OUTPUT_PATH="$DIR_NAME/$FILE_NAME_WITHOUTEXT".h264""
		elif [ $EXT_TYPE == "h264" -o $EXT_TYPE == "avc" ]; then
			OUTPUT_PATH="$DIR_NAME/$FILE_NAME_WITHOUTEXT".h265""
		else
			OUTPUT_PATH="$DIR_NAME/$FILE_NAME_WITHOUTEXT".h264""
		fi

		echo "No output path specified hence using $OUTPUT_PATH as default"
	fi

	OUT_FILE_NAME=$(basename "$OUTPUT_PATH")
	OUT_EXT_TYPE="${OUT_FILE_NAME##*.}"

	FILE_SRC="$FILE_SRC=$INPUT_PATH"
	QUEUE="$QUEUE max-size-bytes=0"
	SINK="$FILESINK=$OUTPUT_PATH"

	if [ $SHOW_FPS ]; then
		SINK="fpsdisplaysink name=fpssink text-overlay=false video-sink=fakesink sync=true -v"
	fi

	OMXH264ENC="$OMXH264ENC control-rate=2 num-slices=4 prefetch-buffer-size=504 target-bitrate=$BIT_RATE ! video/x-h264, profile=high"
	OMXH265ENC="$OMXH265ENC control-rate=2 num-slices=4 prefetch-buffer-size=504 target-bitrate=$BIT_RATE ! video/x-h265, profile=main,level=\(string\)6.2,tier=main"

	if [ $EXT_TYPE == "h264" -o $EXT_TYPE == "avc" ]; then
		pipeline="$GST_LAUNCH $FILE_SRC ! $H264PARSE ! $OMXH264DEC ! $QUEUE ! $OMXH265ENC ! $SINK"
	elif [ $EXT_TYPE == "h265" -o $EXT_TYPE == "hevc" ];then
		pipeline="$GST_LAUNCH $FILE_SRC ! $H265PARSE ! $OMXH265DEC ! $QUEUE ! $OMXH264ENC ! $SINK"
	elif [ $EXT_TYPE == "mp4" ]; then
		if [ $CODEC_TYPE == "avc" ]; then
			pipeline="$GST_LAUNCH $FILE_SRC ! $QTDEMUX ! $H264PARSE ! $OMXH264DEC ! $QUEUE ! $OMXH265ENC ! $SINK"
		else
			pipeline="$GST_LAUNCH $FILE_SRC ! $QTDEMUX ! $H265PARSE ! $OMXH265DEC ! $QUEUE ! $OMXH264ENC ! $SINK"
		fi
	elif [ $EXT_TYPE == "mkv" ]; then
		if [ $CODEC_TYPE == "avc" ]; then
			pipeline="$GST_LAUNCH $FILE_SRC ! $MTDEMUX ! $H264PARSE ! $OMXH264DEC ! $QUEUE ! $OMXH265ENC ! $SINK"
		else
			pipeline="$GST_LAUNCH $FILE_SRC ! $MTDEMUX ! $H265PARSE ! $OMXH265DEC ! $QUEUE ! $OMXH264ENC ! $SINK"
		fi
	else
		ErrorMsg "Incorrect Input file path provided"
	fi

	runGstPipeline "$pipeline"
}

# Command Line Argument Parsing
args=$(getopt -o "i:c:b:o:e:fh" --long "input-path:,codec-type:,bit-rate:,output-path:,internal-entropy-buffers:,show-fps,help" -- "$@")

[ $? -ne 0 ] && usage && exit -1

trap catchCTRL_C SIGINT
parseCommandLineArgs
TranscodeFile
