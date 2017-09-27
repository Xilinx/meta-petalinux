#!/bin/bash
#
# Provides functions for doing QoS and DRM settings and also some basic utility functions
# to kill processes, display error message.
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

#Default Globals to be used for gstreamer elements
DEFAULT_INPUT_PATH="/usr/share/movies/bbb_sunflower_2160p_30fps_normal.mp4"
GST_LAUNCH="gst-launch-1.0"
OMXH264DEC="omxh264dec ip-mode=1 op-mode=1"
OMXH265DEC="omxh265dec ip-mode=1 op-mode=1"
H264PARSE="h264parse"
H265PARSE="h265parse"
QUEUE="queue"
QTDEMUX="qtdemux name=demux demux.video_0"
MTDEMUX="matroskademux name=demux demux.video_0"
VIDEOCONVERT="videoconvert"
OMXH264ENC="omxh264enc ip-mode=2 sliceHeight=64 stride=256"
OMXH265ENC="omxh265enc ip-mode=2 sliceHeight=64 stride=256"
RTPH264PAY="rtph264pay"
RTPH265PAY="rtph265pay"
UDPSINK="udpsink max-lateness=-1 qos-dscp=60 async=false max-bitrate=5000000"
FILE_SRC="filesrc location"
FILESINK="filesink location"
RTPH264DEPAY="rtph264depay"
RTPH265DEPAY="rtph265depay"
RTPJITTERBUFFER="rtpjitterbuffer latency=1000"
UDP_SRC="udpsrc"
V4L2SRC="v4l2src device=/dev/video0"
INTERNAL_ENTROPY_BUFFERS="2"
RTP_CAPS="application/x-rtp, media=video, clock-rate=90000, payload=96,"

############################################################################
# Name:		ErrorMsg
# Description:	To display error message
############################################################################
ErrorMsg() {
	echo "$1"
	usage
}

#####################################################################################
# Name:		QoSSetting
# Description:  Set QoS of the AFI ports to be best effort where VCU is connected
######################################################################################
QoSSetting () {
	devmem 0xfd390008 w 0x3
	devmem 0xfd39001c w 0x3
	devmem 0xfd3a0008 w 0x3
	devmem 0xfd3a001c w 0x3
	devmem 0xfd3b0008 w 0x3
	devmem 0xfd3b001c w 0x3
}

#####################################################################################
# Name:		killProcess
# Argument:	Name of the process to be killed
# Description:	Kills process passed as an argument if it is running
######################################################################################
killProcess () {
	pidof "$1" > "/dev/null"
	if [ $? -eq 0 ]; then
		if [ $1 == "Xorg" ]; then
			sleep 1 | killall -9 "$1"
		else
			killall -9 "$1"
		fi
	fi
}


#########################################################################################
# Name:		runGstPipeline
# Argument:	Gstreamer pipeline string
# Description:	Runs the gstreamer pipeline as per the element property values selected
#               by user or using default property value if not provided by user
#########################################################################################
runGstPipeline () {
	pipeline=$1
	echo $pipeline
	eval "$pipeline"&
	PID=$!
	wait $PID
}

#########################################################################################
# Name:		setDefaultifEmpty
# Argument:	Name of the property whose default value needs to be set if it's empty
# Description:	Sets default values for the properties not filled by user via commandline
#########################################################################################
setDefaultifEmpty () {
	PROPERTY=$1
	case $PROPERTY in
		inputPath )
			if [ -z $INPUT_PATH ]; then
			INPUT_PATH="/usr/share/movies/bbb_sunflower_2160p_30fps_normal.mp4"
			echo "No input path specified so using $INPUT_PATH as default input path"
			fi
			;;
		videoSize )
			if [ -z $VIDEO_SIZE ]; then
				VIDEO_SIZE="3840x2160"
				echo "Video Size is not specified in args hence using 3840x2160 as default value"
			fi
			;;
		sinkName )
			if [ -z $SINK_NAME ]; then
				SINK_NAME="kmssink"
			fi
			;;
		codecType )
			if [ -z $CODEC_TYPE ]; then
				echo "No codec type specified for $FILE_NAME hence assuming avc as default codec"
				CODEC_TYPE="avc"
			fi
			;;
		portNum )
			if [ -z $PORT_NUM ]; then
				PORT_NUM=50000
				echo "No port number specified hence using $PORT_NUM as default"
			fi
			;;
		bufferSize )
			if [ -z $BUFFER_SIZE ]; then
				BUFFER_SIZE="16000000"
				echo "No input buffer size specified hence using $BUFFER_SIZE as default size for kernel recieved buffer"
			fi
			;;
		targetBitrate )
			if [ -z $BIT_RATE ]; then
				BIT_RATE=10000
				echo "No bit-rate specified hence using $BIT_RATE as default"
			fi
			;;
		ipaddress )
			if [ -z $ADDRESS ]; then
				ADDRESS="192.168.0.2"
				echo "No host address specified hence using $ADDRESS as default host address"
			fi
			;;
		* )
			echo ' Invalid option';
	esac


}

#####################################################################################
# Name:		drmSetting
# Argument:     Resolution to set
# Description:	To do display setting required to render input stream using DP monitor
######################################################################################
drmSetting () {
	VIDEO_SIZE=$1
	if [ -z $VIDEO_SIZE ]; then
		VIDEO_SIZE="3840x2160"
		echo "Video Size is not specified in args hence using 3840x2160 as default value"
	fi

	killProcess "Xorg"
	killProcess "modetest"
	killProcess "sleep"

	sleep 9999d | modetest -M xilinx_drm -s 29:$VIDEO_SIZE@RG16 -w 25:alpha:0 &
}

#####################################################################################
# Name:		DisplayUsage
# Argument:     Usecase property for which usage has to be print
# Description:	Display usage for argument passed to the function
######################################################################################
DisplayUsage () {
	declare -a arr=("${@}")
	for i in "${arr[@]}"
	do
		DisplayUsageFor "$i"
	done
}

#####################################################################################
# Name:		checkforEmptyVar
# Argument:     Array containing names of properties to be checked
# Description:	Check if user has provided any value for each element in the array,
#		and set some default value if it is empty
######################################################################################
checkforEmptyVar () {
	declare -a arr=("${@}")
	for i in "${arr[@]}"
	do
		setDefaultifEmpty "$i"
	done
}
#####################################################################################
# Name:		DisplayUsageFor
# Argument:     Usecase property for which usage has to be print
# Description:	Display usage for argument passed to the function
######################################################################################
DisplayUsageFor () {
	PROPERTY=$1
	case $PROPERTY in
		inputPath )
			echo '	-i or --input-path	: Path to input file '
			echo '				: Possible Values: <Path_to_input_file>'
			echo '				: Default Value: "/usr/share/movies/bbb_sunflower_2160p_30fps_normal.mp4"'
			;;
		outputPath )
			echo '	-o or --output-path	: Give path to output file '
			echo '				: Possible Values: <Path_to_output_file>'
			echo '				: Default Value: "Present working directory"'
			;;
		videoSize )
			echo '	-s or --video-size	: Size of input video'
			echo '				: Possible Values: 1920x1080,3840x2160,1280x720 e.t.c'
			;;
		sinkName )
			echo '	-o or --sink-name	: Type of sink to use'
			echo '				: Possible Values: kmssink,fakesink'
			echo '				: Default Value: kmssink'
			;;
		showFps )
			echo '	-f or --show-fps	: Enable logs to display frames per second'
			echo '				: Enabled: Display fps when -f option is passed '
			echo '				: Disabled: fps are not displayed'
			;;
		codecType )
			echo '	-c or --codec-type	: Type of codec used for the input mp4/mkv file'
			echo '				: Possible Values: avc/hevc'
			echo '				: Default Value: avc'
			;;
		numFrames )
			echo '	-n or --num-frames	: Number of frames to be processed by VCU'
			echo '				: Possible Values: 1000, 2000 e.t.c'
			echo '				: Default Value: infinite'
			;;
		portNum )
			echo '	-p or --port		: The port number to which packetized stream has to be sent '
			echo '				: Possible Values: 50000, 42000 e.t.c'
			echo '				: Default Value: "50000"'
			;;

		bufferSize )
			echo '	-b or --buffer-size	: Size of kernel recieved buffer in bytes '
			echo '				: Possible Values: 16000000, 17000000, 18000000 e.t.c'
			echo '				: Default Value: 16000000"'
			;;
		targetBitrate )
			echo '	-b or --bit-rate	: Bitrate with which encoder should encode input raw data using constant bitrate mode'
			echo '				: Possible Values: 1000 (for 1Mbits/sec)'
			echo '				 		 : 20000 (for 20Mbits/sec)'
			echo '				                 : 30000 (for 30Mbits/sec)'
			echo '				                 : 40000 (for 40Mbits/sec)'
			echo '				                 : 50000 (for 50Mbits/sec)'
			echo '				                 : and likewise'
			;;
		ipaddress )
			echo '	-a or --address		: Addess of host/ip/multicast group to send the packets to'
			echo '				: Possible Values: "192.168.1.101, 192.168.1.71, 192.168.2.112, 127.0.0.1 for loopback"'
			echo '				: Default Value: "192.168.0.2"'
			;;
		* )
			echo ' Invalid option';
	esac

}

#####################################################################################
# Name:		DisplayUsage
# Argument:     Usecase property for which usage has to be print
# Description:	Display usage for argument passed to the function
######################################################################################
parseCommandLineArgs () {
eval set -- "${args}"
while true; do
	case $1 in
		-h | --help)
			usage; exit 0;
			shift;
			;;
		-i | --input-path)
			INPUT_PATH=$2;
                        shift; shift;
                        ;;
		-c | --codec-type)
                        CODEC_TYPE=$2;
                        shift; shift;
                        ;;
		-s | --video-size)
			VIDEO_SIZE=$2;
			echo $VIDEO_SIZE
                        shift; shift;
                        ;;
		-o)
			SINK_NAME=$2;
			OUTPUT_PATH=$2;
                        shift; shift;
                        ;;
		--output-path)
			OUTPUT_PATH=$2;
                        shift; shift;
                        ;;
		--sink-name)
			SINK_NAME=$2;
                        shift; shift;
                        ;;
		-f | --show-fps)
			SHOW_FPS=1;
                        shift;
                        ;;
		-n | --num-frames)
			NUM_FRAMES=$2;
                        shift;shift;
                        ;;
		-b)
                        BIT_RATE=$2;
			BUFFER_SIZE=$2
                        shift; shift;
                        ;;
		--buffer-size)
			BUFFER_SIZE=$2
                        shift; shift;
                        ;;
		--bit-rate)
			BIT_RATE=$2
			shift; shift;
			;;
		-a | --address)
                        ADDRESS=$2;
                        shift; shift;
                        ;;
		-p | --port-num)
                        PORT_NUM=$2;
                        shift; shift;
                        ;;
		--)
                        shift; break;
                        ;;
                *)
                        usage; exit -1;

	esac
done
}
