#!/bin/bash
#
# Decode and display data from incoming packetized stream
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
declare -a scriptArgs=("portNum" "codecType" "audioType" "sinkName" "bufferSize" "showFps" "internalEntropyBuffers" "displayDevice" "audioOutput" "pulseSink" "alsaSink")
declare -a checkEmpty=("portNum" "codecType" "sinkName" "bufferSize" "displayDevice")

############################################################################
# Name:		usage
# Description:	To display script's command line argument help
############################################################################
usage () {
	echo '	Usage : '$scriptName' -p <port_number>  -c <codec_type> -o <sink_name> -b <kernel_reciever_buffer_size> -e <internal_entropy_buffers> -d <display_device> -a <input_audio_type> -f --use-alsasink --use-pulsesink'
	DisplayUsage "${scriptArgs[@]}"
	echo '  Example :'
	echo '  '$scriptName''
	echo '  '$scriptName' -d "fd4a0000.zynqmp-display"'
	echo '  '$scriptName' -d "fd4a0000.zynqmp-display" -a aac'
	echo '  '$scriptName' --display-device "fd4a0000.zynqmp-display"'
	echo '  '$scriptName' -f'
	echo '  '$scriptName' -f -o fakevideosink'
	echo '  '$scriptName' -p 40000 -c avc'
	echo '  '$scriptName' -p 40000 -c avc -e 9'
	echo '  '$scriptName' -p 40000 -c avc -b 14000000 '
	echo '  "NOTE: This script depends on vcu-demo-functions.sh to be present in /usr/bin or its path set in $PATH"'
	exit
}

############################################################################
# Name:		streaminDecodeDisplay
# Description:	Decode incoming packetized stream
##########################################################################
streaminDecodeDisplay() {
	if [ $SHOW_FPS ]; then
		SINK="fpsdisplaysink name=fpssink text-overlay=false video-sink=\"$SINK_NAME\" -v"
	else
		SINK="$SINK_NAME"
	fi

	QUEUE="$QUEUE max-size-bytes=0"
	UDP_SRC="$UDP_SRC port=$PORT_NUM buffer-size=$BUFFER_SIZE"
	case $AUDIODEC_TYPE in
	"aac")
		AUDIODEC="faad";;
	"vorbis")
		AUDIODEC="vorbisdec";;
	 *)
		if ! [ -z $AUDIODEC_TYPE ]; then
			ErrorMsg "Invalid audio codec type specified, please specify either vorbis or aac"
		fi
	esac

	restartPulseAudio

	case $CODEC_TYPE in
	"avc")
		RTP_CAPS="$RTP_CAPS encoding-name=H264";;
	"hevc")
		RTP_CAPS="$RTP_CAPS encoding-name=H265";;
	esac

	if [ $CODEC_TYPE == "avc" ]; then
		if ! [ -z $AUDIODEC_TYPE ]; then
			pipeline="$GST_LAUNCH $UDP_SRC caps=\"application/x-rtp\" ! $RTPJITTERBUFFER ! queue ! $RTPMP2TDEPAY ! $TSPARSE ! $MPEGTS_CAPS ! $TSDEMUX ! queue ! $H264PARSE ! $OMXH264DEC latency-mode="reduced-latency" ! $QUEUE ! $SINK demux. ! queue ! $AUDIODEC ! $AUDIOCONVERT ! $AUDIO_SINK"
		else
			pipeline="$GST_LAUNCH $UDP_SRC caps=\"$RTP_CAPS\" ! $RTPJITTERBUFFER ! queue ! $RTPH264DEPAY ! $H264PARSE ! $OMXH264DEC latency-mode="reduced-latency" ! $QUEUE ! $SINK"
		fi
	else
		if ! [ -z $AUDIODEC_TYPE ]; then
			pipeline="$GST_LAUNCH $UDP_SRC caps=\"application/x-rtp\" ! $RTPJITTERBUFFER ! queue ! $RTPMP2TDEPAY ! $TSPARSE ! $MPEGTS_CAPS ! $TSDEMUX ! queue ! $H265PARSE ! $OMXH265DEC latency-mode="reduced-latency" ! $QUEUE ! $SINK demux. ! queue ! $AUDIODEC ! $AUDIOCONVERT ! $AUDIO_SINK"
		else
			pipeline="$GST_LAUNCH $UDP_SRC caps=\"$RTP_CAPS\" ! $RTPJITTERBUFFER ! queue ! $RTPH265DEPAY ! $H265PARSE ! $OMXH265DEC latency-mode="reduced-latency" ! $QUEUE ! $SINK"
		fi
	fi

	runGstPipeline "$pipeline"
}

# Command Line Argument Parsing
args=$(getopt -o "c:p:b:o:e:d:a:fh" --long "codec-type:,port-num:,buffer-size:,sink-name:,internal-entropy-buffers:,display-device:,audio-type:,use-alsasink,use-pulsesink,show-fps,help" -- "$@")

[ $? -ne 0 ] && usage && exit -1

trap catchCTRL_C SIGINT
parseCommandLineArgs
if [ -z $CODEC_TYPE ];then
	CODEC_TYPE="hevc"
fi
checkforEmptyVar "${checkEmpty[@]}"
updateVar
RegSetting
DisableDPMS
streaminDecodeDisplay
restoreContext
