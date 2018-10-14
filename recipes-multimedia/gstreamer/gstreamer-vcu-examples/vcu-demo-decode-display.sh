#!/bin/bash
#
# Decode and display the input mp4/mkv/h264/h265
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
declare -a scriptArgs=("inputPath" "downloadUrl" "codecType" "sinkName" "showFps" "audioType" "proxyServer" "loopVideo" "internalEntropyBuffers" "displayDevice" "audioOutput" "pulseSink" "alsaSink")
declare -a checkEmpty=("inputPath" "downloadUrl" "sinkName" "displayDevice")

############################################################################
# Name:		usage
# Description:	To display script's command line argument help
############################################################################
usage() {
	echo '	Usage : '$scriptName' -i <input_file_path> -c <codec_type> -u <download_url or youtube link> -a <audio_type> -o <sink_name> -d <display_device> -e <internal_entropy_buffers> -p <proxy_server_url> -f <show_fps> -l <loop_video> --use-pulsesink --use-alsasink --audio-output'
	DisplayUsage "${scriptArgs[@]}"
	echo '  Example :'
	echo '  '$scriptName''
	echo '  '$scriptName' -i /run/2160p_30.h264'
	echo '  '$scriptName' -i /run/2160p_30.h264 --use-alsasink'
	echo '  '$scriptName' -i /run/2160p_30.h264 -o kmssink -d "fd4a0000.zynqmp-display"'
	echo '  '$scriptName' -i /run/2160p_30.h264 --display-device "fd4a0000.zynqmp-display"'
	echo '  '$scriptName' -i /run/2160p_60.h264 -o fakevideosink -f'
	echo '  '$scriptName' -i /run/2160p_60.h265 -o fakevideosink -e 9 -f'
	echo '  '$scriptName' -i /run/2160p_60.h264 -o fakevideosink -f -l'
	echo '  '$scriptName' -i /mnt/sata/2160p_30.mp4 -c avc'
	echo '  '$scriptName' -i /mnt/sata/2160p_30.mp4 -c avc -a aac'
	echo '  '$scriptName' -i /mnt/sata/2160p_30.ts -c avc -a aac'
	echo '  '$scriptName' -i /mnt/sdcard/2160p_30.mkv -c hevc'
	echo '  '$scriptName' -i /mnt/sdcard/2160p_30.mkv -c hevc -a vorbis'
	echo '  '$scriptName' -i /mnt/nfs/1080p_30.h264'
	echo '  '$scriptName' -i /mnt/usb/1280p_30.h264'
	echo '  '$scriptName' -u <download_url> -c hevc'
	echo '  '$scriptName' -u "https://www.youtube.com/watch?v=jIGqXIAacG8"'
	echo '  '$scriptName' -u "https://www.youtube.com/watch?v=jIGqXIAacG8 --use-pulsesink"'
	echo '  '$scriptName' -u "https://www.youtube.com/watch?v=jIGqXIAacG8 --use-alsasink --"'
	echo '  '$scriptName' -u "https://www.youtube.com/watch?v=jIGqXIAacG8" -p "http://proxy.<server>:8080"'
	echo '  "NOTE: This script depends on vcu-demo-functions.sh to be present in /usr/bin or its path set in $PATH"'
	exit
}


############################################################################
# Name:		DecodeFile
# Description:	Decode input encoded file and display it
############################################################################
DecodeFile() {
	if [ $SHOW_FPS ]; then
		SINK="fpsdisplaysink name=fpssink text-overlay=false video-sink=\"$SINK_NAME\" sync=true -v"
	else
		SINK="$SINK_NAME"
	fi

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

	AUDIO_SINK_BASE="$AUDIO_SINK"
	restartPulseAudio

	FILE_NAME=$(basename "$INPUT_PATH")
	EXT_TYPE="${FILE_NAME##*.}"
	if [ $LOOP_VIDEO ]; then
		if [[ "$EXT_TYPE" == "h264" || "$EXT_TYPE" == "avc" || "$EXT_TYPE" == "hevc"  || $EXT_TYPE == "h265" ]]; then
			FILE_SRC="multifilesrc location="$INPUT_PATH" loop=1"
		else
			ErrorMsg "Loop video option is not supported for input file format specified, instead it's only supported for raw H264/H265 file formats"
		fi
	else
		FILE_SRC=$FILE_SRC"=$INPUT_PATH"
	fi

	if  ! [ -z $AUDIO_OUTPUT ] && [ $AUDIO_SINK != "autoaudiosink" ]; then
		AUDIO_SINK="$AUDIO_SINK device=\"$AUDIO_OUTPUT\""
	fi

	if [ $AUDIO_SINK_BASE != "autoaudiosink" ]; then
		AUDIO_SINK="$AUDIO_SINK provide-clock=false"
	fi

	if [ $EXT_TYPE == "mp4" -o $EXT_TYPE == "mkv" ] && [ -z $CODEC_TYPE ]; then
		echo "No codec type specified for $FILE_NAME hence assuming avc as default codec"
		CODEC_TYPE="avc"
	fi

	if [ $EXT_TYPE == "h264" -o $EXT_TYPE == "avc" ]; then
		pipeline="$GST_LAUNCH $FILE_SRC ! $H264PARSE ! $OMXH264DEC ! $QUEUE max-size-bytes=0 ! $SINK"
	elif [ $EXT_TYPE == "h265" -o $EXT_TYPE == "hevc" ];then
		pipeline="$GST_LAUNCH $FILE_SRC ! $H265PARSE ! $OMXH265DEC ! $QUEUE max-size-bytes=0 ! $SINK"
	elif [ $EXT_TYPE == "mp4" ]; then
		if [ $CODEC_TYPE == "avc" ]; then
			if [ -z $AUDIODEC ]; then
				pipeline="$GST_LAUNCH $FILE_SRC ! $QTDEMUX ! $H264PARSE ! $OMXH264DEC ! $QUEUE max-size-bytes=0 ! $SINK"
			else
				pipeline="$GST_LAUNCH $FILE_SRC ! $QTDEMUX ! $H264PARSE ! $OMXH264DEC ! $QUEUE max-size-bytes=0 ! $SINK demux.audio_0 ! $QUEUE ! $AUDIODEC ! $AUDIOCONVERT ! $AUDIORESAMPLE ! $AUDIO_CAPS ! $AUDIO_SINK"
			fi
		else
			if [ -z $AUDIODEC ]; then
				pipeline="$GST_LAUNCH $FILE_SRC ! $QTDEMUX ! $H265PARSE ! $OMXH265DEC ! $QUEUE max-size-bytes=0 ! $SINK"
			else
				pipeline="$GST_LAUNCH $FILE_SRC ! $QTDEMUX ! $H265PARSE ! $OMXH265DEC ! $QUEUE max-size-bytes=0 ! $SINK demux.audio_0 ! $QUEUE ! $AUDIODEC ! $AUDIOCONVERT ! $AUDIORESAMPLE ! $AUDIO_CAPS ! $AUDIO_SINK"
			fi
		fi
	elif [ $EXT_TYPE == "mkv" ]; then
		if [ $CODEC_TYPE == "avc" ]; then
			if [ -z $AUDIODEC ]; then
				pipeline="$GST_LAUNCH $FILE_SRC ! $MTDEMUX ! $H264PARSE ! $OMXH264DEC ! $QUEUE max-size-bytes=0 ! $SINK"
			else
				pipeline="$GST_LAUNCH $FILE_SRC ! $MTDEMUX ! $H264PARSE ! $OMXH264DEC ! $QUEUE max-size-bytes=0 ! $SINK demux.audio_0 ! $QUEUE ! $AUDIODEC ! $AUDIOCONVERT ! $AUDIORESAMPLE ! $AUDIO_CAPS ! $AUDIO_SINK"
			fi
		else
			if [ -z $AUDIODEC ]; then
				pipeline="$GST_LAUNCH $FILE_SRC ! $MTDEMUX ! $H265PARSE ! $OMXH265DEC ! $QUEUE max-size-bytes=0 ! $SINK"
			else
				pipeline="$GST_LAUNCH $FILE_SRC ! $MTDEMUX ! $H265PARSE ! $OMXH265DEC ! $QUEUE max-size-bytes=0 ! $SINK demux.audio_0 ! $QUEUE ! $AUDIODEC ! $AUDIOCONVERT ! $AUDIORESAMPLE ! $AUDIO_CAPS ! $AUDIO_SINK"
			fi
		fi
	elif [ $EXT_TYPE == "ts" ]; then
		if [ $CODEC_TYPE == "avc" ]; then
			if [ -z $AUDIODEC ]; then
				pipeline="$GST_LAUNCH $FILE_SRC ! $MPEG_CAPS ! $TSDEMUX ! $H264PARSE ! $OMXH264DEC ! $QUEUE max-size-bytes=0 ! $SINK"
			else
				pipeline="$GST_LAUNCH $FILE_SRC ! $MPEG_CAPS ! $TSDEMUX demux. ! $QUEUE! $H264PARSE ! $OMXH264DEC ! $QUEUE max-size-bytes=0 ! $SINK demux. ! $QUEUE ! $AUDIODEC ! $AUDIOCONVERT ! $AUDIORESAMPLE ! $AUDIO_CAPS ! $AUDIO_SINK"
			fi
		else
			if [ -z $AUDIODEC ]; then
				pipeline="$GST_LAUNCH $FILE_SRC ! $MPEG_CAPS ! $TSDEMUX ! $H265PARSE ! $OMXH265DEC ! $QUEUE max-size-bytes=0 ! $SINK"
			else
				pipeline="$GST_LAUNCH $FILE_SRC ! $MPEG_CAPS ! $TSDEMUX demux. ! $QUEUE ! $H265PARSE ! $OMXH265DEC ! $QUEUE max-size-bytes=0 ! $SINK demux. ! $QUEUE ! $AUDIODEC ! $AUDIOCONVERT ! $AUDIORESAMPLE ! $AUDIO_CAPS ! $AUDIO_SINK"
			fi
		fi
	else
		ErrorMsg "Incorrect Input file path provided"
	fi

	runGstPipeline "$pipeline"
}

DecodeYoutubeFile () {
	if ! [ -z $AUDIODEC_TYPE ]; then
		echo "-a or --audio-type is not supported for youtube link, so ignoring it"
	fi

	if ! [ -z $SET_ENTROPY_BUF ]; then
		echo "-e or --internal-entropy-buffers is not supported for youtube link, so ignoring it"
	fi

	if [ $SHOW_FPS ]; then
		SINK="fpsdisplaysink name=fpssink text-overlay=false video-sink=\"$SINK_NAME\" sync=true -v"
	else
		SINK="$SINK_NAME"
	fi

	FILE_SRC=$SOUPHTTP_SRC"=\$(youtube-dl -f 22 -g "$DEFAULT_URL")"

	pipeline="$GST_LAUNCH $FILE_SRC ! decodebin name=demux demux. ! $QUEUE max-size-bytes=0 ! $SINK demux. ! $QUEUE ! $AUDIOCONVERT ! $AUDIORESAMPLE ! $AUDIO_SINK"

	runGstPipeline "$pipeline"
	if [ $? -ne 0 ]; then
		ErrorMsg "Please check network connectivity or give valid URL"
	fi
}

args=$(getopt -o "i:u:c:a:o:p:d:e:flh" --long "input-path:,url:,codec-type:,sink-name:,audio-type:,internal-entropy-buffers:,proxy:,display-device:,show-fps,loop-video,audio-output:,use-pulsesink,use-alsasink,help" -- "$@")
[ $? -ne 0 ] && usage && exit -1

trap catchCTRL_C SIGINT
parseCommandLineArgs
checkforEmptyVar "${checkEmpty[@]}"
killDuplicateProcess
getInputFile
updateVar
RegSetting
DisableDPMS
if ! [ -z $AUDIODEC_TYPE ]; then
	audioSetting
fi
if [ $YOUTUBE_LINK -eq 1 ]; then
	DecodeYoutubeFile
else
	DecodeFile
fi
restoreContext
