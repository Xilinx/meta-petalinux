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
declare -a scriptArgs=("inputPath" "codecType" "showFps" "targetBitrate" "outputPath" "internalEntropyBuffers" "audioType" "gopLength" "periodicityIdr")
declare -a checkEmpty=("inputPath" "targetBitrate" "gopLength" "periodicityIdr")


############################################################################
#
# Name:		usage
# Description:	To display script's command line argument help
############################################################################
usage () {
	echo '	Usage : '$scriptName' -i <input_file_path> -b <--bit-rate> -c <codec_type> -a <audio_type> -o <output_path> -e <internal_entropy_buffers> --gop-length <gop_length> --periodicity-idr <periodicity_idr> -f'
	DisplayUsage "${scriptArgs[@]}"
	echo '  Example :'
	echo '  '$scriptName' -i /run/2160p_30.h264 -b 5000'
	echo '  '$scriptName' -i /run/2160p_30.h264 -b 5000 --gop-length 60 --periodicity-idr 60'
	echo '  '$scriptName' -i /run/2160p_30.h264 -b 5000 -f'
	echo '  '$scriptName' -i /run/2160p_60.h264 -o /mnt/sata/op.h265'
	echo '  '$scriptName' -i /run/2160p_60.h264 -f'
	echo '  '$scriptName' -i /mnt/sata/2160p_30.mp4 -c avc -a aac'
	echo '  '$scriptName' -i /mnt/sata/2160p_60.mp4 -c avc -e 7'
	echo '  '$scriptName' -i /mnt/sdcard/2160p_30.mkv -c hevc -a vorbis'
	echo '  "NOTE: This script depends on vcu-demo-functions.sh to be present in /usr/bin or its path set in $PATH"'
	exit
}

############################################################################
#
# Name:		TranscodeFile
# Description:	Decode input encoded file to YUV
############################################################################
TranscodeFile() {
	INPUT_FILE_NAME=$(basename "$INPUT_PATH")
	INPUT_EXT_TYPE="${INPUT_FILE_NAME##*.}"

	if [ $INPUT_EXT_TYPE == "mp4" -o $INPUT_EXT_TYPE == "mkv" ] && [ -z $CODEC_TYPE ]; then
		echo "No codec type specified for $INPUT_FILE_NAME hence assuming avc as default codec"
		CODEC_TYPE="avc"
	fi

        case $AUDIODEC_TYPE in
        "aac")
		AUDIODEC="faad"
		AUDIOPARSE="vorbisparse"
		AUDIOENC="vorbisenc";;
        "vorbis")
		AUDIODEC="vorbisdec"
		AUDIOPARSE="aacparse"
		AUDIOENC="faac";;
         *)
                if ! [ -z $AUDIODEC_TYPE ]; then
                        ErrorMsg "Invalid audio codec type specified, please specify either vorbis or aac"
                fi
        esac

	if [ -z $OUTPUT_PATH ]; then
		DIR_NAME=$(pwd)
		FILE_NAME_WITHOUTEXT="${INPUT_FILE_NAME%.*}"
		if [ $INPUT_EXT_TYPE == "mp4" ]; then
			OUTPUT_PATH="$DIR_NAME/$FILE_NAME_WITHOUTEXT".mkv""
		elif [ $INPUT_EXT_TYPE == "mkv" ]; then
			OUTPUT_PATH="$DIR_NAME/$FILE_NAME_WITHOUTEXT".mp4""
		elif [ $INPUT_EXT_TYPE == "h264" ]; then
			OUTPUT_PATH="$DIR_NAME/$FILE_NAME_WITHOUTEXT".h265""
		elif [ $INPUT_EXT_TYPE == "h265" ]; then
			OUTPUT_PATH="$DIR_NAME/$FILE_NAME_WITHOUTEXT".h264""
		elif [ $INPUT_EXT_TYPE == "avc" ]; then
			OUTPUT_PATH="$DIR_NAME/$FILE_NAME_WITHOUTEXT".hevc""
		else
			OUTPUT_PATH="$DIR_NAME/$FILE_NAME_WITHOUTEXT".aac""
		fi
		echo "No output path specified hence using $OUTPUT_PATH as default"
	fi

	OUTPUT_FILE_NAME=$(basename "$OUTPUT_PATH")
	OUTPUT_EXT_TYPE="${OUTPUT_FILE_NAME##*.}"

	case $OUTPUT_EXT_TYPE in
        "h264" | "avc")
                CODEC_TYPE="hevc";;
        "h265" | "hevc")
                CODEC_TYPE="avc";;
	"mp4")
		MUX="qtmux name=mux";;
	"mkv")
		MUX="matroskamux name=mux";;
	esac

	case $INPUT_EXT_TYPE in
	"mp4")
		DMUX=$QTDEMUX;;
	"mkv")
		DMUX=$MTDEMUX;;
	esac

	FILE_SRC="$FILE_SRC=$INPUT_PATH"
	SINK="$FILESINK=$OUTPUT_PATH"

	if [ $SHOW_FPS ]; then
		SINK="fpsdisplaysink name=fpssink text-overlay=false video-sink=fakesink sync=true -v"
	fi

	OMXH264ENC="$OMXH264ENC num-slices=8 control-rate=2 b-frames=2 gop-length=$GOP_LENGTH periodicity-idr=$PERIODICITY_IDR prefetch-buffer=true target-bitrate=$BIT_RATE ! video/x-h264, profile=high"
	OMXH265ENC="$OMXH265ENC num-slices=8 control-rate=2 b-frames=2 gop-length=$GOP_LENGTH periodicity-idr=$PERIODICITY_IDR prefetch-buffer=true target-bitrate=$BIT_RATE ! video/x-h265, profile=main,level=\(string\)6.2,tier=main"

	case $CODEC_TYPE in
	"avc")
		DEC_PARSER=$H264PARSE
		DECODER=$OMXH264DEC
		ENC_PARSER=$H265PARSE
		ENCODER=$OMXH265ENC;;
	"hevc")
		DEC_PARSER=$H265PARSE
		DECODER=$OMXH265DEC
		ENC_PARSER=$H264PARSE
		ENCODER=$OMXH264ENC;;
	esac

	GST_LAUNCH="$GST_LAUNCH -e"
	if [[ $DMUX && $MUX && $AUDIODEC_TYPE ]]; then #e.g .mp4 to .mkv with audio transcode
		pipeline="$GST_LAUNCH $FILE_SRC ! $DMUX ! $MULTIQUEUE name=mq ! $DEC_PARSER ! $DECODER ! $QUEUE max-size-bytes=0 ! $ENCODER ! $ENC_PARSER ! $QUEUE name=vq ! $MUX ! $SINK demux.audio_0 ! mq.sink_1 mq.src_1 ! $AUDIODEC ! $AUDIOCONVERT ! $AUDIORESAMPLE ! $AUDIOENC ! $AUDIOPARSE ! $QUEUE name=aq ! mux.audio_0"
	elif [[ $DMUX && $MUX && ! $AUDIODEC_TYPE ]]; then #e.g .mp4 to .mkv without audio transcode
		pipeline="$GST_LAUNCH $FILE_SRC ! $DMUX ! $DEC_PARSER ! $DECODER ! $QUEUE max-size-bytes=0 ! $ENCODER ! $ENC_PARSER ! $MUX ! $SINK"
	elif [[ $DMUX && ! $MUX ]]; then #e.g .mp4 to .h264 transcode
		pipeline="$GST_LAUNCH $FILE_SRC ! $DMUX ! $DEC_PARSER ! $DECODER ! $QUEUE max-size-bytes=0 ! $ENCODER ! $SINK"
        elif [[ ! $DMUX && $MUX ]]; then #e.g .h264 to .mp4 transcode
                pipeline="$GST_LAUNCH $FILE_SRC ! $DEC_PARSER ! $DECODER ! $QUEUE max-size-bytes=0 ! $ENCODER ! $ENC_PARSER ! $MUX ! $SINK"
	elif [[ ! $DMUX && ! $MUX ]]; then #e.g .h264 to .h265 transcode
		pipeline="$GST_LAUNCH $FILE_SRC ! $DEC_PARSER ! $DECODER ! $QUEUE max-size-bytes=0 ! $ENCODER ! $SINK"
	else
		ErrorMsg "Incorrect output file provided"
	fi

	runGstPipeline "$pipeline"
	if [ $? -ne 0 ]; then
		ErrorMsg "Incorrect input/output file format"
	fi
}

# Command Line Argument Parsing
args=$(getopt -o "i:c:b:a:o:e:fh" --long "input-path:,codec-type:,bit-rate:,audio-type:,output-path:,internal-entropy-buffers:,gop-length:,periodicity-idr:,show-fps,help" -- "$@")

[ $? -ne 0 ] && usage && exit -1

trap catchCTRL_C SIGINT
parseCommandLineArgs
checkforEmptyVar "${checkEmpty[@]}"
updateVar
TranscodeFile
