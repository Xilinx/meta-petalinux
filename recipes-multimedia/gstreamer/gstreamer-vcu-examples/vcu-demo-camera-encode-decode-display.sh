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
declare -a scriptArgs=("inputPath" "videoSize" "codecType" "sinkName" "numFrames" "targetBitrate" "showFps" "audioType" "internalEntropyBuffers" "v4l2Device" "displayDevice" "alsaSrc" "pulseSrc" "audioOutput" "alsaSink" "pulseSink" "frameRate")
declare -a checkEmpty=("codecType" "sinkName" "targetBitrate" "v4l2Device" "displayDevice" "frameRate")


############################################################################
# Name:		usage
# Description:	To display script's command line argument help
############################################################################
usage () {
	echo '	Usage : '$scriptName' -i <device_id_string> -v <video_capture_device> -s <video_size> -c <codec_type> -a <audio_type> -o <sink_name> -n <number_of_frames> -b <target_bitrate> -e <internal_entropy_buffers> -r <capture_device_rate> -d <display_device> -f --use-alsasrc --use-pulsesrc --audio-output <Audio output device> --use-pulsesink --use-alsasink'
	DisplayUsage "${scriptArgs[@]}"
	echo '  Example :'
	echo '  '$scriptName''
	echo '  '$scriptName' -a aac'
	echo '  '$scriptName' --use-alsasrc -i "hw:1" -d "fd4a0000.zynqmp-display" -a aac'
	echo '  '$scriptName' -v "/dev/video1"'
	echo '  '$scriptName' -n 500 --use-alsasrc'
	echo '  '$scriptName' --use-alsasrc -i "hw:1" -n 500 --use-alsasrc -b 1200 -a aac'
	echo '  '$scriptName' --use-pulsesrc -i "alsa_input.usb-046d_C922_Pro_Stream_Webcam_FCD7727F-02.analog-stereo" -n 500 -b 1200 -a aac'
	echo '  '$scriptName' -f'
	echo '  '$scriptName' -o fakevideosink'
	echo '  '$scriptName' --use-alsasrc -i "hw:1" -s 1920x1080 -c avc -a aac'
	echo '  '$scriptName' -s 1920x1080 -c avc -e 3'
	echo '  '$scriptName' -s 1280x720 -c avc'
	echo '  '$scriptName' --use-alsasrc -i "hw:1" -s 1280x720 -c avc -a aac'
	echo '  '$scriptName' --use-alsasrc -i "hw:1" -s 1280x720 -c avc -a vorbis'
	echo '  '$scriptName' -s 1280x720'
	echo '  '$scriptName' --use-alsasrc -i "hw:1" -s 1280x720 -c avc -a aac'
	echo '  '$scriptName' --use-alsasrc -i "hw:1" -s 1280x720 -c avc -a aac --audio-output "hw:0"'
	echo '  '$scriptName' --use-pulsesrc -i "alsa_input.usb-046d_C922_Pro_Stream_Webcam_FCD7727F-02.analog-stereo" -n 500 -b 1200 -a aac'
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
                AUDIO_BUFFERS=$(($NUM_FRAMES*100/$FRAME_RATE))
        fi

	AUDIO_SRC_BASE="$AUDIO_SRC"
	AUDIO_SINK_BASE="$AUDIO_SINK"

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

	IFS='x' read WIDTH HEIGHT <<< "$VIDEO_SIZE"
	CAMERA_CAPS="video/x-raw,width=$WIDTH,height=$HEIGHT,framerate=$FRAME_RATE/1"
	VIDEOCONVERT="videoconvert"
	VIDEOCONVERT_CAPS="video/x-raw, format=\(string\)NV12"
	if [ -z $SET_ENTROPY_BUF ]; then
		INTERNAL_ENTROPY_BUFFERS="6"
	fi

	OMXH264ENC="omxh264enc num-slices=8 control-rate="low-latency" target-bitrate=$BIT_RATE prefetch-buffer=true"
	OMXH265ENC="omxh265enc num-slices=8 control-rate="low-latency" target-bitrate=$BIT_RATE prefetch-buffer=true"
	OMXH264DEC="$OMXH264DEC internal-entropy-buffers=$INTERNAL_ENTROPY_BUFFERS latency-mode="reduced-latency""
	OMXH265DEC="$OMXH265DEC internal-entropy-buffers=$INTERNAL_ENTROPY_BUFFERS latency-mode="reduced-latency""

        case $CODEC_TYPE in
        "avc")
		PARSER=$H264PARSE
		ENCODER=$OMXH264ENC
		DECODER=$OMXH264DEC
		CAMERA_CAPS_ENC="video/x-h264,width=$WIDTH,height=$HEIGHT,framerate=$FRAME_RATE/1";;
	"hevc")
		PARSER=$H265PARSE
		ENCODER=$OMXH265ENC
		DECODER=$OMXH265DEC
		CAMERA_CAPS_ENC="video/x-h265,width=$WIDTH,height=$HEIGHT,framerate=$FRAME_RATE/1";;
	esac
	restartPulseAudio
	setAudioSrcProps

	if ! [ -z $AUDIO_OUTPUT ] && [ $AUDIO_SINK_BASE != "autoaudiosink" ]; then
		AUDIO_SINK="$AUDIO_SINK device=\"$AUDIO_OUTPUT\""
	fi

	if [ -z $AUDIODEC_TYPE ]; then
			pipeline="$GST_LAUNCH $V4L2SRC ! $CAMERA_CAPS ! $VIDEOCONVERT ! $VIDEOCONVERT_CAPS ! $ENCODER ! $QUEUE ! $DECODER ! $QUEUE max-size-bytes=0 ! $SINK"
	else
		if [ "$AUDIO_SRC_BASE" == "pulsesrc" ] && [ "$AUDIO_SINK_BASE" == "pulsesink" ]; then
			pipeline="$GST_LAUNCH $V4L2SRC ! $CAMERA_CAPS ! $VIDEOCONVERT ! $VIDEOCONVERT_CAPS ! $ENCODER ! $QUEUE ! $DECODER ! $QUEUE max-size-bytes=0 ! $SINK $AUDIO_SRC ! $QUEUE ! $AUDIOENC ! $AUDIODEC ! $AUDIO_SINK"
		else
			pipeline="$GST_LAUNCH $V4L2SRC ! $CAMERA_CAPS ! $VIDEOCONVERT ! $VIDEOCONVERT_CAPS ! $ENCODER ! $QUEUE ! $DECODER ! $QUEUE max-size-bytes=0 ! $SINK $AUDIO_SRC ! $QUEUE ! $AUDIOCONVERT ! $AUDIOENC ! $QUEUE ! $AUDIODEC ! $AUDIOCONVERT ! $AUDIORESAMPLE ! $AUDIO_CAPS ! $AUDIO_SINK"
		fi
	fi

	runGstPipeline "$pipeline"
}

# Command Line Argument Parsing
args=$(getopt -o "i:v:d:s:c:o:a:b:n:e:r:fh" --long "input-path:,video-capture-device:,display-device:,video-size:,audio-type:,codec-type:,sink-name:,num-frames:,bit-rate:,internal-entropy-buffers:,audio-output:,frame-rate:,show-fps,help,use-alsasrc,use-pulsesrc,use-alsasink,use-pulsesink" -- "$@")

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
if ! [ -z $AUDIODEC_TYPE ]; then
        audioSetting
fi

RegSetting
DisableDPMS
CameraToDisplay
restoreContext
