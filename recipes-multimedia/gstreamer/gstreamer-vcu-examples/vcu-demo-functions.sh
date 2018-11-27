#!/bin/bash
#
# Provides functions for register settings for performance and DRM settings and
# also some basic utility functions to kill processes, display error message e.t.c
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
#Default Globals
DEFAULT_INPUT_PATH="/usr/share/movies/"
GST_LAUNCH="gst-launch-1.0"
OMXH264DEC="omxh264dec"
OMXH265DEC="omxh265dec"
H264PARSE="h264parse"
H265PARSE="h265parse"
QUEUE="queue"
MULTIQUEUE="multiqueue"
QTDEMUX="qtdemux name=demux demux.video_0"
MTDEMUX="matroskademux name=demux demux.video_0"
TSDEMUX="tsdemux name=demux"
TSPARSE="tsparse"
VIDEOCONVERT="videoconvert"
OMXH264ENC="omxh264enc"
OMXH265ENC="omxh265enc"
RTPH264PAY="rtph264pay"
RTPH265PAY="rtph265pay"
RTPMP2TPAY="rtpmp2tpay"
UDPSINK="udpsink max-lateness=-1 qos-dscp=60 async=false max-bitrate=5000000"
FILE_SRC="filesrc location"
FILESINK="filesink location"
RTPH264DEPAY="rtph264depay"
RTPH265DEPAY="rtph265depay"
RTPMP2TDEPAY="rtpmp2tdepay"
RTPJITTERBUFFER="rtpjitterbuffer latency=1000"
UDP_SRC="udpsrc"
V4L2SRC="v4l2src"
INTERNAL_ENTROPY_BUFFERS="2"
RTP_CAPS="application/x-rtp, media=video, clock-rate=90000, payload=96,"
MPEGTS_CAPS="video/mpegts"
AUDIO_SINK="autoaudiosink"
AUDIO_SINK_BASE="unknown"
AUDIOCONVERT="audioconvert"
AUDIORESAMPLE="audioresample"
AUDIO_CAPS="audio/x-raw, channels=2, rate=48000"
MPEG_CAPS="video/mpegts"
CODEC_TYPE="avc"
NEED_DOWNLOAD=0
DEFAULT_URL_AVC="petalinux.xilinx.com/sswreleases/video-files/bbb_sunflower_2160p_30fps_normal_avc_new.mp4"
DEFAULT_URL_HEVC="petalinux.xilinx.com/sswreleases/video-files/bbb_sunflower_2160p_30fps_normal_hevc.mkv"
YOUTUBE_LINK=0
SOUPHTTP_SRC="souphttpsrc location"
COMPRESSED_MODE=0
AUDIO_SRC="autoaudiosrc"
AUDIO_SRC_BASE="unknown"
DISPLAY_DEVICE="fd4a0000.zynqmp-display"
DPMS="unknown"
PULSEAUDIO="unknown"

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


############################################################################
# Name:		ErrorMsg
# Description:	To display error message
############################################################################
ErrorMsg() {
	echo "$1"
	usage
}

#############################################################################################
# Name:		catchCTRL_C
# Description:	Cleanup all the processes spawned by script when user interrupts using CTRL+C
#############################################################################################
catchCTRL_C() {
	export DISPLAY=:0.0
	xset dpms force on
	modetest -D fd4a0000.zynqmp-display -w 35:alpha:255
	restoreContext
	exit 0
}

##############################################################################################
# Name:		RegSetting
# Description:  Set QoS of the AFI ports to be best effort where VCU is connected and
#		set outstanding read/write requests for AFI ports where VCU is connected to 16
##############################################################################################
RegSetting () {
	# Qos = 3 for VCU
	devmem 0xfd380008 w 0x3
	devmem 0xfd38001c w 0x3
	devmem 0xfd3b0008 w 0x3
	devmem 0xfd3b001c w 0x3

	# 16 outstanding request for VCU
	devmem 0xfd380004 w 0xF
	devmem 0xfd3B0004 w 0xF
	devmem 0xfd380018 w 0xF
	devmem 0xfd3B0018 w 0xF
}

##############################################################################################
# Name:		restoreContext
# Description:  Restore the display and audio settings to previous state
##############################################################################################
restoreContext () {
	if [ $DPMS == "off" ] ; then
		xset s on +dpms
	fi
	if [ $PULSEAUDIO == "off" ]; then
		pulseaudio --start -D
	fi
}

##############################################################################################
# Name:		DisableDPMS
# Description:  Disable Display power management subsystem and screen saver
##############################################################################################
DisableDPMS () {
	pidof "Xorg" > "/dev/null" 2>&1
	if [ $? -eq 0 ]; then
		export DISPLAY=:0.0
		xset s off -dpms
		DPMS="off"
	fi
}


#############################################################################################
# Name:		restartPulseAudio
# Description:  Restarts the PulseAudioDaemon so that previous handles to device are released
##############################################################################################
restartPulseAudio () {
        if ! [ -z $AUDIODEC_TYPE ]; then
                which pulseaudio > "/dev/null" 2>&1
                if [ $? -eq 0 ]; then
			pulseaudio --check
			if [ $? -eq 0 ]; then
				pulseaudio -k
				PULSEAUDIO="off"
			fi
			if [ $AUDIO_SRC_BASE == "pulsesrc" ] || [ $AUDIO_SINK_BASE == "pulsesink" ]; then
                        	pulseaudio --start -D
				PULSEAUDIO="on"
			fi
                fi
        fi
}


#####################################################################################
# Name:		audioSetting
# Description:  Set the volume for DP codec to maximum
######################################################################################
audioSetting () {
	devmem 0xFD4AC000 32 0xffffffff
        which amixer > /dev/null
	if [ $? -eq 0 ]; then
		amixer sset 'Master' 100%
		amixer sset 'Capture' 100%
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
# Name:		download
# Argument:	Input file to download
# Description:	Downloads the file passed as an argument using retries if needed
#########################################################################################

download() {
if ! [ -f $INPUT_PATH ]; then
	if [ -f ~/.bashrc ]; then
		source ~/.bashrc
	fi
	download_complete=0
	for i in `seq 1 6`; do
		echo "Try #$i for download"
		wget -c -T7 $1 -P $DEFAULT_INPUT_PATH
		if [ $? -eq 0 ];then
			echo "Download completed"
			download_complete=1
			break;
		else
			echo "No connection, Retrying..."
		fi
	done
	if [ $download_complete -eq 0 ]; then
		if [ -f $INPUT_PATH ]; then
			echo "Deleting partially downloaded file"
			rm $INPUT_PATH
			sync
		fi
		ErrorMsg "File $INPUT_PATH was not found and downloading it from server also failed"
	fi
else
	echo "Previously downloaded file present in $INPUT_PATH"
fi
}

#########################################################################################
# Name:		installYoutubeDl
# Argument:	None
# Description:  Install youtube_dl if not found on board
#########################################################################################
installYoutubeDl () {
	which youtube-dl
	if [ $? -ne 0 ]; then
		which pip3
		if [ $? -ne 0 ]; then
			ErrorMsg "pip3 command not found, Please install pip3"
		fi
		if [ -z $PROXY ]; then
			pip3 install youtube_dl
		else
			pip3 install youtube_dl --proxy $PROXY
		fi
		if [ $? -ne 0 ]; then
			ErrorMsg "Unable to download youtube_dl, Please check network connectivity"
		fi
	fi
}

#########################################################################################
# Name:		getInputFile
# Argument:	None
# Description:  Downloads input file from server if not found in default paths
#########################################################################################
getInputFile () {
	if [ $NEED_DOWNLOAD -eq 1 ]; then
		if [[ $DEFAULT_URL = *www.youtube.com* ]]; then
			YOUTUBE_LINK=1
			installYoutubeDl
		else
			download $DEFAULT_URL
		fi
	fi
}

#########################################################################################
# Name:		setAudioSrcProps
# Argument:	None
# Description:  Set AudioSrc properties like capture device and buffers to be played
#########################################################################################
setAudioSrcProps () {
	if ! [ -z $AUDIO_BUFFERS ]; then
                if  [ $AUDIO_SRC == "autoaudiosrc" ]; then
                        echo "NOTE: You may have to exit manually as -n/num-frames only supported with use-alsasrc or use-pulsesink options"
                fi
        fi

        if [ $AUDIO_SRC != "autoaudiosrc" ]; then
                if ! [ -z $INPUT_PATH ]; then
                        AUDIO_SRC="$AUDIO_SRC device=\"$INPUT_PATH\""
                fi
                if ! [ -z $AUDIO_BUFFERS ]; then
                        AUDIO_SRC="$AUDIO_SRC num-buffers=$AUDIO_BUFFERS"
                fi
        fi

	AUDIO_SRC="$AUDIO_SRC do-timestamp=true"
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
				INPUT_PATH="$DEFAULT_INPUT_PATH/bbb_sunflower_2160p_30fps_normal.mp4"
				echo "No input file path was specified so trying to use $INPUT_PATH as default input file"
			fi
		;;
		downloadUrl )
			if [ -z $DEFAULT_URL ]; then
				#Download by default only if no input file present in rootfs at /usr/share/movies
				if ! [ -f $INPUT_PATH ]; then
					echo "File $INPUT_PATH was not found, so trying to download from server..."
					DEFAULT_INPUT_PATH="/home/root"
					if [ $CODEC_TYPE == "avc" ]; then
						DEFAULT_URL=$DEFAULT_URL_AVC
					else
						DEFAULT_URL=$DEFAULT_URL_HEVC
					fi
					FILENAME="${DEFAULT_URL##*/}"
					INPUT_PATH="$DEFAULT_INPUT_PATH/$FILENAME"
					NEED_DOWNLOAD=1
				fi
			fi
			;;
		videoSize )
			if [ -z $VIDEO_SIZE ]; then
				VIDEO_SIZE="3840x2160"
				echo "Video Size is not specified in args hence using 3840x2160 as default value"
			fi
			;;
		v4l2Device )
			if [ -z $V4L2_DEVICE ]; then
				V4L2_DEVICE="/dev/video0"
				V4L2SRC="$V4L2SRC device=$V4L2_DEVICE"
				echo "V4L2 device node is not specified in args hence assuming $V4L2_DEVICE as default capture device"
			fi
			if ! [ -e $V4L2_DEVICE ]; then
				ErrorMsg "No camera device found at $V4L2_DEVICE, please give correct path and try again"
			else
				echo "No input file path was specified so using $V4L2_DEVICE as default input file"
			fi
			;;
		displayDevice )
			if [ -z $DISPLAY_DEVICE ]; then
				DISPLAY_DEVICE="fd4a0000.zynqmp-display"
			echo "DRM display device is not specified in args hence assuming $DISPLAY_DEVICE as default DRM device"
			fi
			;;

		sinkName )
			if [ -z $SINK_NAME ]; then
				SINK_NAME="kmssink bus-id="$DISPLAY_DEVICE" fullscreen-overlay=1"
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
		frameRate )
			if [ -z $FRAME_RATE ]; then
				FRAME_RATE=30
				echo "No frame rate specified hence assuming $FRAME_RATE as default"
			fi
			;;
		bufferSize )
			if [ -z $BUFFER_SIZE ]; then
				BUFFER_SIZE="60000000"
				echo "No input buffer size specified hence using $BUFFER_SIZE as default size for kernel recieved buffer"
			fi
			;;
		gopLength )
			if [ -z $GOP_LENGTH ]; then
				GOP_LENGTH="60"
				echo "No "gop-length" parameter value specified hence using $GOP_LENGTH as default for encoding the input stream"
			fi
			;;
		periodicityIdr )
			if [ -z $PERIODICITY_IDR ]; then
				PERIODICITY_IDR="60"
				echo "No "periodicity-idr" parameter value specified hence using $PERIODICITY_IDR as default for encoding input stream"
			fi
			;;
		cpbSize )
			if [ -z $CPB_SIZE ]; then
				CPB_SIZE="3000"
				echo "No "cpbSize" parameter value specified hence using $CPB_SIZE as default for encoding input stream"
			fi
			;;
		targetBitrate )
			if [ -z $BIT_RATE ]; then
				if [ $CODEC_TYPE == "avc" ]; then
					BIT_RATE=5500
				else
					BIT_RATE=8000
				fi
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
# Name:		updateVar
# Argument:     None
# Description:	Update Variables whose properties required to be changed as per parsed args
######################################################################################
updateVar () {
	if [[ $VIDEO_SIZE == "7680x4320" || -n $SET_ENTROPY_BUF ]]; then
		OMXH265DEC="$OMXH265DEC internal-entropy-buffers=$INTERNAL_ENTROPY_BUFFERS"
		OMXH264DEC="$OMXH264DEC internal-entropy-buffers=$INTERNAL_ENTROPY_BUFFERS"
	fi
}


#####################################################################################
# Name:		killDuplicateProcess
# Argument:     None
# Description:	Kill Duplicate process spawned before with same args
######################################################################################
killDuplicateProcess () {
	partial_download=0
	if [ -f $INPUT_PATH ]; then
		fuser $INPUT_PATH
		if [ $? -eq 0 ]; then
			partial_download=1
			echo "Found partially downloaded file, forcing a redownload..."
		fi
	fi
	#Exit if same process was spawned already
	for pid in $(pidof -x $0); do
	if [ $pid != $$ ]; then
		pgid=`ps -o pid,pgid | grep $pid | awk -F ' ' '{print $2}'`
		ps -o pid | grep -v grep | grep "$pgid" > "/dev/null"
		if [ $? -eq 0 ]; then
			if ! [ -z $pgid ]; then
				echo "Killing duplicate VCU demo example"
				kill -9 $pgid
			fi
		fi
	fi
	done
	if [ $partial_download -eq 1 ]; then
		rm $INPUT_PATH
		sync
	fi
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
			echo '	-i or --input-path		 : Path to input file '
			echo '					 : Possible Values: <Path_to_input_file>'
			echo '					 : Default Value: "/usr/share/movies/bbb_sunflower_2160p_30fps_normal.mp4"'
			;;
		downloadUrl )
			echo '	-u or --url			 : Path to download URL for input file '
			echo '					 : Possible Values: <http URL for input file>'
			echo '					 : Default Value: petalinux.xilinx.com/sswreleases/video-files/bbb_sunflower_2160p_30fps_normal_avc_new.mp4 '
			;;
		outputPath )
			echo '	-o or --output-path		 : Give path to output file '
			echo '					 : Possible Values: <Path_to_output_file>'
			echo '					 : Default Value: "Present working directory"'
			;;
		videoSize )
			echo '	-s or --video-size		 : Size of input video'
			echo '					 : Possible Values: 1920x1080,3840x2160,1280x720 e.t.c'
			;;
		sinkName )
			echo '	-o or --sink-name		 : Type of sink to use'
			echo '					 : Possible Values: kmssink,fakevideosink'
			echo '					 : Default Value: kmssink'
			;;
		showFps )
			echo '	-f or --show-fps		 : Enable logs to display frames per second'
			echo '					 : Enabled: Display fps when -f option is passed '
			echo '					 : Disabled: fps are not displayed'
			;;
		v4l2Device )
			echo '	-v or --video-capture-device	 : Set Video device node to be used as capture source'
			echo '					 : Possible Values: "/dev/video0", "/dev/video1",..,/dev/videox" '
			echo '					 : Default Value  : "/dev/video0"'
			;;
		displayDevice )
			echo '	-d or --display-device	 	 : Set DRM display device'
			echo '					 : Possible Values: "fd4a0000.zynqmp-display"'
			echo '					 : Default Value  : "fd4a0000.zynqmp-display"'
			;;
		loopVideo )
			echo '	-l or --loop-video		 : Loop the pipeline to process video again from start after EOF'
			echo '					 : Enabled: Seek back again to start of file after each iteration and decode'
			echo '					 : Disabled: Input file is read and decoded only once'
			echo '					 : NOTE: This option is only available for raw encoded streams like .h265/h264 data'
			;;
		internalEntropyBuffers )
			echo '	-e or --internal-entropy-buffers : Number of internal buffers used by the decoder'
			echo '					   to smooth out entropy decoding performance.'
			echo '					   Increasing this will improve performance while decoding high bitrate streams,'
			echo '					   Decreasing this (to a minimum of 2) will decrease the memory footprint.'
			echo '					 : Possibe values : 2 - 16'
			echo '					 : Default: 5 (Set internally)'
			;;
		codecType )
			echo '	-c or --codec-type		 : Type of codec used for the input mp4/mkv file'
			echo '					 : Possible Values: avc/hevc'
			echo '					 : Default Value: avc'
			;;
		audioType )
			echo '	-a or --audio-type		 : Type of audio codec used for the input mp4/mkv file'
			echo '					 : Possible Values: vorbis/aac'
			echo '					 : Default Value: None'
			;;
		numFrames )
			echo '	-n or --num-frames		 : Number of frames to be processed by VCU'
			echo '					 : Possible Values: 1000, 2000 e.t.c'
			echo '					 : Default Value: infinite'
			;;
		portNum )
			echo '	-p or --port			 : The port number to which packetized stream has to be sent '
			echo '					 : Possible Values: 50000, 42000 e.t.c'
			echo '					 : Default Value: "50000"'
			;;
		gopLength )
			echo '	--gop-length		 	 : Specifies the number of frames between two consecutive I frames '
			echo '					 : Possible Values: 30, 40, 50 e.t.c'
			echo '					 : Default Value: 240"'
			;;
		periodicityIdr )
			echo '	--periodicity-idr		 : Specifies the number of frames between two consequtive IDR pictures '
			echo '					 : Possible Values: 30, 40, 50  e.t.c'
			echo '					 : Default Value: 240"'
			;;
		cpbSize )
			echo '	--cpb-size			 : Specifies the Coded Picture Buffer size as specified in the HRD model in msec '
			echo '					 : Possible Values: 1000,2000,3000 e.t.c'
			echo '					 : Default Value: 1000"'
			;;
		bufferSize )
			echo '	-b or --buffer-size		 : Size of kernel recieved buffer in bytes '
			echo '					 : Possible Values: 16000000, 17000000, 18000000 e.t.c'
			echo '					 : Default Value: 16000000"'
			;;
		frameRate )
			echo '	-r or --frame-rate		: Set the frame rate of the pipeline '
			echo '					: Possible Values: 15, 30, 60 e.t.c'
			echo '					: Default Value: "30"'
			;;
		targetBitrate )
			echo '	-b or --bit-rate		 : Bitrate with which encoder should encode input raw data using constant bitrate mode'
			echo '					 : Possible Values: 1000 (for 1Mbits/sec)'
			echo '				 			  : 20000 (for 20Mbits/sec)'
			echo '				                 	  : 30000 (for 30Mbits/sec)'
			echo '				                 	  : 40000 (for 40Mbits/sec)'
			echo '				                 	  : 50000 (for 50Mbits/sec)'
			echo '				                 	  : and likewise'
			;;
		ipaddress )
			echo '	--address			 : Addess of host/ip/multicast group to send the packets to'
			echo '					 : Possible Values: "192.168.1.101, 192.168.1.71, 192.168.2.112, 127.0.0.1 for loopback"'
			echo '					 : Default Value: "192.168.0.2"'
			;;
		proxyServer )
			echo '	-p or --proxy			 : Specify a proxy in form [user:passwd@]proxy.server:port, (user:passwd to be set only if required by your server)'
			echo '					 : Possible Values: "http://proxy.<server>:<port_num>"'
			;;
		compressedMode )
			echo '	--compressed-mode		 : Captures raw video from camera'
			;;
		alsaSink )
			echo '	--use-alsasink                   : Play audio using ALSA library API'
			;;
		pulseSink )
			echo '	--use-pulsesink			 : Play audio using pulseaudio library API'
			;;
		alsaSrc )
			echo '	--use-alsasrc                    : Capture audio using ALSA API'
			;;
		pulseSrc )
			echo '	--use-pulsesrc              : Captures audio using pulseaudio library API'
			;;
		audioOutput )
			echo '	--audio-output              : Selects audio output device'
			;;
		mpegTs )
			echo '	--use-mpegts                : Use MPEG-TS as container'
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
		-u | --url)
			DEFAULT_URL=$2;
			FILENAME="${DEFAULT_URL##*/}"
			DEFAULT_INPUT_PATH="/home/root"
			INPUT_PATH="$DEFAULT_INPUT_PATH/$FILENAME"
			NEED_DOWNLOAD=1;
                        shift; shift;
                        ;;
		--audio-type)
                        AUDIODEC_TYPE=$2;
                        shift; shift;
                        ;;
		-s | --video-size)
			VIDEO_SIZE=$2;
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

		-l | --loop-video)
			LOOP_VIDEO=1;
			shift;
                        ;;
		-e | --internal-entropy-buffers)
			SET_ENTROPY_BUF="true"
			INTERNAL_ENTROPY_BUFFERS=$2;
                        shift;shift;
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
		-a)
			ADDRESS=$2;
			AUDIODEC_TYPE=$2
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
		--address)
                        ADDRESS=$2;
                        shift; shift;
                        ;;
		--gop-length)
                        GOP_LENGTH=$2;
                        shift; shift;
                        ;;
		--periodicity-idr)
                        PERIODICITY_IDR=$2;
                        shift; shift;
                        ;;
		--cpb-size)
                        CPB_SIZE=$2;
                        shift; shift;
                        ;;
		-p)
			PORT_NUM=$2;
			PROXY=$2
			shift; shift;
			;;
		--port-num)
                        PORT_NUM=$2;
                        shift; shift;
                        ;;
		-r | --frame-rate)
                        FRAME_RATE=$2;
                        shift; shift;
                        ;;
		--proxy)
                        PROXY=$2;
                        shift; shift;
                        ;;
		-v | --video-capture-device)
                        V4L2_DEVICE=$2;
			V4L2SRC="$V4L2SRC device=$V4L2_DEVICE"
                        shift; shift;
                        ;;
		-d | --display-device)
                        DISPLAY_DEVICE=$2;
			KMSSINK="kmssink bus-id=$DISPLAY_DEVICE fullscreen-overlay=1"
                        shift; shift;
                        ;;
		--compressed-mode)
			COMPRESSED_MODE=1;
                        shift;
                        ;;
		--use-alsasink)
			AUDIO_SINK="alsasink";
			shift;
			;;
		--use-pulsesink)
			AUDIO_SINK="pulsesink";
			shift;
			;;
		--use-alsasrc)
			AUDIO_SRC="alsasrc";
			shift;
			;;
		--use-pulsesrc)
			AUDIO_SRC="pulsesrc"
			shift;
			;;
		--use-mpegts)
			MPEGTS=1
			shift;
			;;
		--audio-output)
			AUDIO_OUTPUT=$2;
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
