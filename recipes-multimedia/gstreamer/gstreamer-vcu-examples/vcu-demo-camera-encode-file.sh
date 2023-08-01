#!/bin/bash
#
#Get RAW YUV frames from Camera, encode it
#
# Copyright (C) 2019 Xilinx
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
declare -a scriptArgs=("inputPath" "v4l2Device" "videoSize" "codecType" "outputPath" "numFrames" "targetBitrate" "audioType" "showFps" "compressedMode" "alsaSrc" "pulseAudiosrc" "frameRate" "gopLength" "periodicityIdr")
declare -a checkEmpty=("v4l2Device" "codecType" "targetBitrate" "sinkName" "frameRate" "gopLength" "periodicityIdr")


############################################################################
# Name:		usage
# Description:	To display script's command line argument help
############################################################################
usage () {
	echo '	Usage : '$scriptName' -i <device_id_string> -v <video_capture_device> -s <video_size> -c <codec_type> -o <output_path> -n <number_of_frames> -b <target_bitrate> -a <audio_type> -r <capture_device_rate> -f --compressed-mode --use-alsasrc --use-pulseaudiosrc --gop-length <gop_length> --periodicity-idr <periodicity_idr>'
	DisplayUsage "${scriptArgs[@]}"
	echo '  Example :'
	echo '  '$scriptName''
	echo '  '$scriptName' -o /mnt/sata/op.ts'
	echo '  '$scriptName' -v "/dev/video1"'
	echo '  '$scriptName' -v "/dev/video1" --gop-length 45'
	echo '  '$scriptName' -v "/dev/video1" --gop-length 45 --periodicity-idr 45'
	echo '  '$scriptName' --use-alsasrc -i "hw:1" -n 500 -a aac'
	echo '  '$scriptName' --use-alsasrc -i "hw:1" -n 500 -b 1200 -a aac'
	echo '  '$scriptName' --use-alsasrc -i "hw:1" -f -a aac'
	echo '  '$scriptName' --use-pulseaudiosrc -i "alsa_input.usb-046d_C922_Pro_Stream_Webcam_FCD7727F-02.analog-stereo" -f -a aac'
	echo '  '$scriptName' -f -o fakevideosink'
	echo '  '$scriptName' -s 1920x1080 -c avc'
	echo '  '$scriptName' --use-alsasrc -i "hw:1" -s 1280x720 -c avc -a aac'
	echo '  '$scriptName' --use-alsasrc -i "hw:1" -a aac'
	echo '  '$scriptName' --use-alsasrc -i "hw:1" --compressed-mode -a vorbis'
	echo '  '$scriptName' --use-pulseaudiosrc -i "alsa_input.usb-046d_C922_Pro_Stream_Webcam_FCD7727F-02.analog-stereo" --compressed-mode -a vorbis'
	echo '  "NOTE: This script depends on vcu-demo-settings.sh to be present in /usr/bin or its path set in $PATH"'
	exit
}

############################################################################
# Name:		CameraToFile
# Description:	Get RAW data from camera, encode it
############################################################################
CameraToFile() {
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

	OMXH264ENC="$OMXH264ENC control-rate=constant b-frames=2 gop-length=$GOP_LENGTH periodicity-idr=$PERIODICITY_IDR prefetch-buffer=true target-bitrate=$BIT_RATE  ! video/x-h264, alignment=au"
	OMXH265ENC="$OMXH265ENC control-rate=constant b-frames=2 gop-length=$GOP_LENGTH periodicity-idr=$PERIODICITY_IDR prefetch-buffer=true target-bitrate=$BIT_RATE ! video/x-h265, alignment=au"
	IFS='x' read WIDTH HEIGHT <<< "$VIDEO_SIZE"

	case $CODEC_TYPE in
	"avc")
		ENC_PARSER=$H264PARSE
		DEC_PARSER=$H264PARSE
		ENCODER=$OMXH264ENC
		CAMERA_CAPS_ENC="video/x-h264,width=$WIDTH,height=$HEIGHT,framerate=$FRAME_RATE/1";;
	"hevc")
		ENC_PARSER=$H265PARSE
		DEC_PARSER=$H265PARSE
		ENCODER=$OMXH265ENC
		CAMERA_CAPS_ENC="video/x-h265,width=$WIDTH,height=$HEIGHT,framerate=$FRAME_RATE/1";;
	esac

	if [ -z $OUTPUT_PATH ]; then
		DIR_NAME=$(pwd)
		OUTPUT_PATH="$DIR_NAME/camera_output.ts"
	fi

	SINK="$FILESINK=$OUTPUT_PATH"
	OUTPUT_FILE_NAME=$(basename "$OUTPUT_PATH")
	OUTPUT_EXT_TYPE="${OUTPUT_FILE_NAME##*.}"
	if [ $SHOW_FPS ]; then
		SINK="fpsdisplaysink name=fpssink text-overlay=false video-sink=fakesink sync=true -v"
	fi

	MUX="mpegtsmux name=mux"

        if [ $NUM_FRAMES ]; then
                V4L2SRC="$V4L2SRC num-buffers=$NUM_FRAMES"
                AUDIO_BUFFERS=$(($NUM_FRAMES*100/$FRAME_RATE))
        fi

	setAudioSrcProps
	CAMERA_CAPS="video/x-raw,width=$WIDTH,height=$HEIGHT,framerate=$FRAME_RATE/1"
	VIDEOCONVERT="videoconvert"
	VIDEOCONVERT_CAPS="video/x-raw, format=\(string\)NV12"

	restartPulseAudio
	GST_LAUNCH="$GST_LAUNCH -e"

	if [ -z $AUDIODEC_TYPE ]; then
		if [ $COMPRESSED_MODE -eq 1 ]; then
			pipeline="$GST_LAUNCH $V4L2SRC ! $CAMERA_CAPS_ENC ! $DEC_PARSER ! $QUEUE ! $MUX mux. ! $SINK"
		else
			pipeline="$GST_LAUNCH $V4L2SRC ! $CAMERA_CAPS ! $VIDEOCONVERT ! $VIDEOCONVERT_CAPS ! $ENCODER ! $ENC_PARSER ! $QUEUE ! $MUX mux. ! $SINK"
		fi
	else
		if [ $COMPRESSED_MODE -eq 1 ]; then
			pipeline="$GST_LAUNCH $V4L2SRC ! $CAMERA_CAPS_ENC ! $DEC_PARSER ! $QUEUE ! mux. $AUDIO_SRC ! $AUDIOCONVERT ! $AUDIOENC ! $QUEUE ! $MUX mux. ! $SINK"
		else
			pipeline="$GST_LAUNCH $V4L2SRC ! $CAMERA_CAPS ! $VIDEOCONVERT ! $VIDEOCONVERT_CAPS ! $ENCODER ! $ENC_PARSER ! $QUEUE ! mux. $AUDIO_SRC ! $AUDIOCONVERT ! $AUDIOENC ! $QUEUE ! $MUX mux. ! $SINK"
		fi
	fi

	runGstPipeline "$pipeline"
}

# Command Line Argument Parsing
args=$(getopt -o "i:v:s:c:o:n:r:b:a:fh" --long "input-path:,video-capture-device:,video-size:,codec-type:,output-path:,num-frames:,bit-rate:,audio-type:,frame-rate:,gop-length:,show-fps,help,compressed-mode,use-alsasrc,use-pulseaudiosrc" -- "$@")

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
CameraToFile
