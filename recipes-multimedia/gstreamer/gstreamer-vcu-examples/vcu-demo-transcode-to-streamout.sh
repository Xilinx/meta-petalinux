#!/bin/bash
#
# Transcode input h264 file to h265 and vice versa and stream it out to host
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
declare -a scriptArgs=("inputPath" "codecType" "targetBitrate" "ipaddress" "portNum" "internalEntropyBuffers" "gopLength" "periodicityIdr" "cpbSize" )
declare -a checkEmpty=("inputPath" "targetBitrate" "ipaddress" "portNum" "gopLength" "periodicityIdr" "cpbSize")

############################################################################
# Name:		usage
# Description:	To display script's command line argument help
############################################################################
usage () {
	echo '	Usage : '$scriptName' -i <input_file_path>  -b <bit_rate> -a <address_path> -c <codec_type> -p <port_num> -e <internal_entropy_buffers> --gop-length <gop_length_value> --periodicity-idr <periodicity_idr_value> --cpb-size <cpb_size_value>'
	DisplayUsage "${scriptArgs[@]}"
	echo '  Example :'
	echo '  '$scriptName' -i /run/2160p_30.h264 -b 6000 -p 5000'
	echo '  '$scriptName' -i /run/2160p_60.h264 -a 192.168.1.70'
	echo '  '$scriptName' -i /run/2160p_60.h264 -a 192.168.1.70 --periodicity-idr 20 --gop-length 20 --cpb-size 1000'
	echo '  '$scriptName' -i /mnt/sata/2160p_30.mp4 -c avc -a 192.168.1.70 -b 2000'
	echo '  '$scriptName' -i /mnt/sata/2160p_30.mp4 -c avc -a 192.168.1.70 -b 2000 -e 3'
	echo '  '$scriptName' -i /mnt/sdcard/2160p_30.mkv -c hevc -a 192.168.1.70'
	echo '  '$scriptName' -i /mnt/nfs/1080p_30.h265 -a 192.168.1.70'
	exit
}

############################################################################
# Name:		TranscodeFileandStreamOut
# Description:	Decode input file and transcode input avc to hevc or viceversa
############################################################################
TranscodeFileandStreamOut() {
	FILE_NAME=$(basename "$INPUT_PATH")
	EXT_TYPE="${FILE_NAME##*.}"

	if [ $EXT_TYPE == "mp4" -o $EXT_TYPE == "mkv" ] && [ -z $CODEC_TYPE ]; then
		echo "No codec type specified for $FILE_NAME hence assuming avc as default codec"
		CODEC_TYPE="avc"
	fi

	FILE_SRC="$FILE_SRC=$INPUT_PATH"
	OMXH264ENC="$OMXH264ENC num-slices=8 gop-length=$GOP_LENGTH periodicity-idr=$PERIODICITY_IDR control-rate=low-latency target-bitrate=$BIT_RATE cpb-size=$CPB_SIZE prefetch-buffer=true ! video/x-h264, profile=high"
	OMXH265ENC="$OMXH265ENC num-slices=8 gop-length=$GOP_LENGTH periodicity-idr=$PERIODICITY_IDR control-rate=low-latency target-bitrate=$BIT_RATE cpb-size=$CPB_SIZE prefetch-buffer=true ! video/x-h265, profile=main,level=\(string\)6.2,tier=main"
	UDPSINK="udpsink host=$ADDRESS port=$PORT_NUM max-lateness=-1 qos-dscp=60 async=false buffer-size=60000000 max-bitrate=120000000"

	if [ $EXT_TYPE == "h264" -o $EXT_TYPE == "avc" ]; then
		pipeline="$GST_LAUNCH $FILE_SRC ! $H264PARSE ! $OMXH264DEC ! $QUEUE ! $OMXH265ENC ! $H265PARSE ! $QUEUE ! $RTPH265PAY ! $UDPSINK"
	elif [ $EXT_TYPE == "h265" -o $EXT_TYPE == "hevc" ];then
		pipeline="$GST_LAUNCH $FILE_SRC ! $H265PARSE ! $OMXH265DEC ! $QUEUE ! $OMXH264ENC ! $H264PARSE ! $QUEUE ! $RTPH264PAY ! $UDPSINK"
	elif [ $EXT_TYPE == "mp4" ]; then
		if [ $CODEC_TYPE == "avc" ]; then
			pipeline="$GST_LAUNCH $FILE_SRC ! $QTDEMUX ! $H264PARSE ! $OMXH264DEC ! $QUEUE ! $OMXH265ENC ! $QUEUE ! $RTPH265PAY ! $UDPSINK"
		elif [ $CODEC_TYPE == "hevc" ]; then
			pipeline="$GST_LAUNCH $FILE_SRC ! $QTDEMUX ! $H265PARSE ! $OMXH265DEC ! $QUEUE ! $OMXH264ENC ! $QUEUE ! $RTPH264PAY ! $UDPSINK"
		else
			ErrorMsg "Please specify codec as either avc or hevc"
		fi
	elif [ $EXT_TYPE == "mkv" ]; then
		if [ $CODEC_TYPE == "avc" ]; then
			pipeline="$GST_LAUNCH $FILE_SRC ! $MTDEMUX ! $H264PARSE ! $OMXH264DEC ! $QUEUE ! $OMXH265ENC ! $QUEUE ! $RTPH265PAY ! $UDPSINK"
		elif [ $CODEC_TYPE == "hevc" ]; then
			pipeline="$GST_LAUNCH $FILE_SRC ! $MTDEMUX ! $H265PARSE ! $OMXH265DEC ! $QUEUE ! $OMXH264ENC ! $QUEUE ! $RTPH264PAY ! $UDPSINK"
		else
			ErrorMsg "Please specify codec as either avc or hevc"
		fi
	else
		ErrorMsg "Incorrect Input file path provided"
	fi

	runGstPipeline "$pipeline"
}

# Command Line Argument Parsing
args=$(getopt -o "i:c:a:b:p:e:h" --long "input-path:,codec-type:,address:,port-num:,bit-rate:,internal-entropy-buffers:,gop-length:,periodicity-idr:,cpb-size:,help" -- "$@")
[ $? -ne 0 ] && usage && exit -1

trap catchCTRL_C SIGINT
parseCommandLineArgs
if [ -z $BIT_RATE ]; then
	BIT_RATE=5000
	echo "No bit-rate specified hence using $BIT_RATE as default"
fi
checkforEmptyVar "${checkEmpty[@]}"
updateVar
TranscodeFileandStreamOut
