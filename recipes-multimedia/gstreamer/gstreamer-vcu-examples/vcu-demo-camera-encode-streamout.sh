#!/bin/bash
#
#Get RAW YUV frames from Camera, encode it and stream it to a client
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
declare -a scriptArgs=("inputPath" "v4l2Device" "videoSize" "codecType" "outputPath" "numFrames" "targetBitrate" "audioType" "showFps" "compressedMode" "alsaSrc" "pulseSrc" "gopLength" "periodicityIdr" "cpbSize" "ipaddress" "portNum" "internalEntropyBuffers" "frameRate")
declare -a checkEmpty=("v4l2Device" "codecType" "targetBitrate" "sinkName" "gopLength" "periodicityIdr" "cpbSize" "ipaddress" "portNum" "frameRate")


############################################################################
# Name:		usage
# Description:	To display script's command line argument help
############################################################################
usage () {
	echo '	Usage : '$scriptName' -i <audio_device_id_string> -v <video_capture_device> -s <video_size> -c <codec_type> -o <output_path> -n <number_of_frames> -r <frame_rate> -b <target_bitrate> -a <audio_type> -f --periodicity-idr <periodicity_idr> --gop-length <gop_length> --compressed-mode --use-alsasrc --use-pulseaudiosrc'
	DisplayUsage "${scriptArgs[@]}"
	echo '  Example :'
	echo '  '$scriptName''
	echo '  '$scriptName' --address 192.168.0.2 --audio-type aac --use-alsasrc -i "hw:1"'
	echo '  '$scriptName' -v "/dev/video1"'
	echo '  '$scriptName' --use-alsasrc -i "hw:1" -n 500 --audio-type aac'
	echo '  '$scriptName' --use-alsasrc -i "hw:1" -n 500 -b 1200 --audio-type aac'
	echo '  '$scriptName' --use-alsasrc -i "hw:1" -f --audio-type aac'
	echo '  '$scriptName' --use-pulseaudiosrc -i "alsa_input.usb-046d_C922_Pro_Stream_Webcam_FCD7727F-02.analog-stereo" -f -a aac'
	echo '  '$scriptName' -f -o fakevideosink'
	echo '  '$scriptName' -s 1920x1080 -c avc'
	echo '  '$scriptName' --use-alsasrc -i "hw:1" -s 1280x720 -c avc --audio-type aac'
	echo '  '$scriptName' --use-alsasrc -i "hw:1" --audio-type aac'
	echo '  '$scriptName' --use-alsasrc -i "hw:1" --compressed-mode -a vorbis'
	echo '  '$scriptName' --use-pulseaudiosrc -i "alsa_input.usb-046d_C922_Pro_Stream_Webcam_FCD7727F-02.analog-stereo" --compressed-mode -a vorbis'
	echo '  "NOTE: This script depends on vcu-demo-settings.sh to be present in /usr/bin or its path set in $PATH"'
	exit
}

############################################################################
# Name:		CameraToStreamout
# Description:	Get RAW data from camera, encode it and stream it to a second board
############################################################################
CameraToStreamout() {
	case $AUDIODEC_TYPE in
	"aac")
		AUDIODEC="faad"
		AUDIOENC="faac";;
	"vorbis")
		AUDIODEC="vorbisdec"
		AUDIOENC="vorbisenc";;
	*)
		if ! [ -z $AUDIODEC_TYPE ]; then
			ErrorMsg "Invalid audio codec type specified, please specify either vorbis or aac"
		fi
	esac

	OMXH264ENC="$OMXH264ENC control-rate=low-latency num-slices=8 prefetch-buffer=true target-bitrate=$BIT_RATE cpb-size=$CPB_SIZE gop-mode=basic periodicity-idr=$PERIODICITY_IDR gop-length=$GOP_LENGTH"
	OMXH265ENC="$OMXH265ENC control-rate=low-latency num-slices=8 prefetch-buffer=true target-bitrate=$BIT_RATE gop-mode=basic cpb-size=$CPB_SIZE periodicity-idr=$PERIODICITY_IDR gop-length=$GOP_LENGTH"
	IFS='x' read WIDTH HEIGHT <<< "$VIDEO_SIZE"

	case $CODEC_TYPE in
	"avc")
		ENC_PARSER=$H264PARSE
		DEC_PARSER=$H264PARSE
		ENCODER=$OMXH264ENC
		CAMERA_CAPS_ENC="video/x-h264,width=$WIDTH,height=$HEIGHT,framerate=30/1";;
	"hevc")
		ENC_PARSER=$H265PARSE
		DEC_PARSER=$H265PARSE
		ENCODER=$OMXH265ENC
		CAMERA_CAPS_ENC="video/x-h265,width=$WIDTH,height=$HEIGHT,framerate=30/1";;
	esac

	if [ -z $OUTPUT_PATH ]; then
		DIR_NAME=$(pwd)
		OUTPUT_PATH="$DIR_NAME/camera_output.ts"
	fi

	UDPSINK="udpsink host=$ADDRESS port=$PORT_NUM max-lateness=-1 qos-dscp=60 async=false max-bitrate=120000000"

	MUX="mpegtsmux name=mux alignment=7 name=mux"

        if [ $NUM_FRAMES ]; then
                V4L2SRC="$V4L2SRC num-buffers=$NUM_FRAMES"
                AUDIO_BUFFERS=$(($NUM_FRAMES*100/$FRAME_RATE))
        fi

	CAMERA_CAPS="video/x-raw,width=$WIDTH,height=$HEIGHT,framerate=30/1"
	VIDEOCONVERT="videoconvert"
	VIDEOCONVERT_CAPS="video/x-raw, format=\(string\)NV12"
	restartPulseAudio
	setAudioSrcProps

	if [ -z $AUDIODEC_TYPE ]; then
		if [ $COMPRESSED_MODE -eq 1 ]; then
			pipeline="$GST_LAUNCH $V4L2SRC ! $CAMERA_CAPS_ENC ! $DEC_PARSER ! $MUX ! $RTPMP2TPAY ! $UDPSINK"
		else
			pipeline="$GST_LAUNCH $V4L2SRC ! $CAMERA_CAPS ! $VIDEOCONVERT ! $VIDEOCONVERT_CAPS ! $ENCODER ! $ENC_PARSER ! $MUX ! $RTPMP2TPAY ! $UDPSINK"
		fi
	else
		if [ $COMPRESSED_MODE -eq 1 ]; then
			pipeline="$GST_LAUNCH $V4L2SRC ! $CAMERA_CAPS_ENC ! $DEC_PARSER ! mux. $AUDIO_SRC ! $AUDIOCONVERT ! $QUEUE ! $AUDIOENC ! $MUX ! $RTPMP2TPAY ! $UDPSINK"
		else
			pipeline="$GST_LAUNCH $V4L2SRC ! $CAMERA_CAPS ! $VIDEOCONVERT ! $VIDEOCONVERT_CAPS ! $ENCODER ! $ENC_PARSER ! mux. $AUDIO_SRC do-timestamp=1 ! $AUDIOCONVERT ! $QUEUE ! $AUDIOENC ! $MUX ! $RTPMP2TPAY ! $UDPSINK"
		fi
	fi

	runGstPipeline "$pipeline"
}

# Command Line Argument Parsing
args=$(getopt -o "i:v:s:c:a:o:n:b:e:p:fh" --long "input-path:,video-capture-device:,video-size:,codec-type:,output-path:,num-frames:,bit-rate:,port-num:,audio-type:,address:,internal-entropy-buffers:,gop-length:,periodicity-idr:,cpb-size:,help,compressed-mode,use-alsasrc,use-pulseaudiosrc" -- "$@")

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
CameraToStreamout
