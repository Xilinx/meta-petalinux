Zynq Ultrascale+ MPSoC:VideoCodecUnit-ReadMe
============================================

Table of Contents
=================
• Supported VCU-Features and Specification
• VCU out-of-box Examples Description
• Conguration settings for standalone pipelines
• Sample Gstreamer Pipelines
• Sample Control-Software/Openmax Pipelines

=========================================
I. Supported Features and Specification
=========================================
Refer to PG252 (H.264/H.265 VideoCodec Unit v1.0) document at "https://www.xilinx.com/support.html#documentation"

========================================
II. VCU out-of-box Examples Description
========================================

 Supported VCU out of box examples are mentioned below, Desktop application shows two VCU examples (4K AVC Decode and 4K HEVC Decode)  icons corresponding to VCU-Decode->Display usecase, more details are mentioned in Example-1.

 1. VCU-Decode → Display: Decodes AVC/HEVC encoded container stream and Displays on DP monitor. It supports aac/vorbis audio decode along with video.
 2. USB-Camera → Encode → Decode → Display: Captures raw video frames from Camera and Encode/Decode using VCU and display using DP monitor.
 3. USB-Camera → Decode → Display: Captures encoded video content from Camera, Decode using VCU  and display using DP monitor.
 4. Transcode → to File: Transcodes input AVC/HEVC encoded bitstream into HEVC/AVC format and stores on disk.
 5. Transcode → Stream out using Ethernet  ... Streaming In → Decode → Display: Transcodes input AVC/HEVC encoded bitstream into HEVC/AVC format and streams out to another board using RTP/UDP , and second board receives the data Decode using VCU, Display using DP monitor.
 6. USB-Camera → Audio/Video Encode → File: Video recording use-case.
 7. USB-Camera → Encode → streamout ... stream-in → Decode → Display: Video conference use-case.

===============================
III.  Steps to Verify Examples:
===============================

 1. Boot the Board (ZCU106/ZCU104) using petalinux pre-builts.
     • Make sure the Board is connected to Ethernet, this is required to download sample video content from Xilinx web server.
     • If Board is connected to private network, then export proxy settings in /home/root/.bashrc file as below,
	     i.  create/open a bashrc file using "vi ~/.bashrc"
	     ii. Insert below line to bashrc file
		     export http_proxy="<private network proxy address>"
		     export https_proxy="<private network proxy address>"
     • If the board is not connected to internet, then compressed video files can be downloaded using host machine and copy input files into
       "/home/root/" folder. Use below commands to download the content on host linux-machine.
     • Download AVC sample file:  wget petalinux.xilinx.com/sswreleases/video-files/bbb_sunflower_2160p_30fps_normal_avc_new.mp4
     • Download HEVC sample file: wget petalinux.xilinx.com/sswreleases/video-files/bbb_sunflower_2160p_30fps_normal_hevc.mkv

 2. Example-1: (Decode → Display)
    • Matchbox Desktop will have below two applications
    • 4K AVC Decode:
	i. Click on this application, it will download sample AVC/AAC encoded bitstream and run VCU Example-1 (Decode → Display).
	ii. If the sample avc content is already present in /home/root then it will just decode→display the content.
    • 4K HEVC Decode: same as above but it uses HEVC/Voribis encoded bitstream.
    • Decode→ Display can be executed using command line option as well, use below command to run this example.
      Running the script with "-h" option shows all possible options.
	i.  vcu-demo-decode-display.sh -i /home/root/bbb_sunflower_2160p_30fps_normal_avc_new.mp4 -c avc -a aac
	ii. vcu-demo-decode-display.sh -i /home/root/bbb_sunflower_2160p_30fps_normal_hevc.mkv -c hevc -a vorbis
    • Run below command to play youtube video, make sure ethernet is connected to board.
	i. vcu-demo-decode-display.sh -u "youtube-URL"
    • Run below command for help
	i. vcu-demo-decode-display.sh -h

 3. Example-2: (USB-Camera → Encode → Decode → Display)
    • Connect USB camera to the board (Verified Cameras: Logitech HD camera, C920).
    • Run below command for USB video capture serial pipeline
	i. vcu-demo-camera-encode-decode-display.sh -s 640x480
    • Run below command for USB video capture serial pipeline with audio
	i.  Using ALSA Library API
	    vcu-demo-camera-encode-decode-display.sh -s 640x480 -a aac --use-alsasrc -i "hw:1,0" --use-alsasink --audio-output "hw:0,0"

	ii. Using Pulse Library API
	    vcu-demo-camera-encode-decode-display.sh -s 640x480 -a aac -i "alsa_input.usb-046d_HD_Pro_Webcam_C920_C06272EF-02.analog-stereo" \
	     --use-pulsesrc --use-pulsesink --audio-output "alsa_output.platform-fd4a0000.zynqmp-display:zynqmp_dp_snd_card.analog-stereo"

	NOTE: For selecting the values of arguments to be passed to -i and ---audio-output option, please refer section IV.

	iii. Using Gstreamer Autoaudiosrc and Autoaudiosink plugins
	     vcu-demo-camera-encode-decode-display.sh -s 640x480 -a aac

	NOTE: In above example using gstreamer auto plugins,  gstreamer will select the API and devices to be used for capture and playback
	      automatically. It will usually try to use default devices enumerated at bootup by pulseaudioserver or as mentioned in alsa configuration
	      file. So it might not choose the device you want to use sometimes, in which case you can use scripts arguments as mentioned in i and ii.


 4. Example-3: (USB-Camera → Decode → Display)
    • Connect USB camera to the board (Verified Cameras: Logitech HD camera, C920).
    • Run below command for USB video decode display pipeline
	i. vcu-demo-camera-decode-display.sh -s 1920x1080
    • Run below command for USB video decode pipeline with audio
	i.  Using ALSA Library API
	    vcu-demo-camera-decode-display.sh -a aac --use-alsasrc -i "hw:1,0" --use-alsasink --audio-output "hw:0,0"

	ii. Using Pulse Library API
	    vcu-demo-camera-decode-display.sh -s 640x480 -a aac -i "alsa_input.usb-046d_HD_Pro_Webcam_C920_C06272EF-02.analog-stereo" \
	     --use-pulsesrc --use-pulsesink --audio-output "alsa_output.platform-fd4a0000.zynqmp-display:zynqmp_dp_snd_card.analog-stereo"

	NOTE: For "How To Guide" on selecting the values of arguments to be passed to -i and ---audio-output option, please refer section IV.

	iii. Using Gstreamer Autoaudiosrc and Autoaudiosink plugins
	     vcu-demo-camera-decode-display.sh -a aac

    Note: Resolutions for Example 2&3 need to set based on USB Camera Capabilities.
	• Capabilities can be found using "v4l2-ctl --list-formats-ext".
        • V4lutils if not installed in the pre-built image, need to install using dnf or rebuild petalinux image including v4lutils.

 5 .Example-4: (Transcode → to File)
    • This example requires input sample files. If Example-1 is executed already, then sample videos are stored in "/home/root" folder.
    • Use below command to transcode sample avc file into hevc file.
	i. vcu-demo-transcode-to-file.sh -i /home/root/bbb_sunflower_2160p_30fps_normal_avc_new.mp4 -c avc -a aac -o /home/root/transcode.mkv
    • Use Example-1 to view the transcoded file on the Display, sample command is mentioned below:
	i. vcu-demo-decode-display.sh -i /home/root/transcode.mkv -c hevc -a vorbis --use-alsasink --audio-output "hw:0"
 6. Example-5 : (Transcode → Stream out using Ethernet  ... Streaming In → Decode → Display)
    • This example requires two boards, board-1 is used for transcode and stream-out (as a server) and board 2 is used for streaming-in and
      decode purpose (as a client) or VLC player on the host machine can be used as client instead of board-2.
    • Make sure input video file is copied to board-1 for streaming.
    • Connect two boards back to back with Ethernet cable or make sure both the boards are connected to same Ethernet hub.
    • If VLC player is used as client then make sure host machine and server (board-1) are connected to same Ethernet hub or Connect them back to
      back using Ethernet cable
    • Client settings
	i. Set client IP address and execute stream-in → Decode example on board 2, if board-2 is used as client and connected the boards back to
	   back with ethernet cable.
	   • ifconfig eth0 192.168.0.2 (Note: setting of ip is not required if the boards already connected to same LAN)
	   • vcu-demo-streamin-decode-display.sh -c avc (Note: This means client is receiving AVC bitstream from server,
	     Use -c hevc if server is sending HEVC bitstream)
	ii.If VLC player is used as client then,
	   • Set the host machine IP address to 192.168.0.2, if it is connected to board directly with ethernet cable.
	     (Note: Setting of IP address is not required if the boards already connected to same LAN)
	   • Create test.sdp file on host with below content (Add separate line in test.sdp for each item below) and play
		     test.sdp on host machine.
			     1.	v=0 c=IN IP4 <Client machine IP address>
			     2.	m=video 50000 RTP/AVP 96
			     3.	a=rtpmap:96 H264/90000
			     4.	a=framerate=30
	   • Trouble-shoot for VLC player setup:
		 o IP4 is client-IP address
		 o H264/H265 is used based on received codec type on the client
		 o Turn-off firewall in host machine if packets are not received to VLC.
     • Set server IP and execute Transcode → stream-out example on board-1
	i.  ifconfig eth0 192.168.0.1 (note: setting of ip is not required if the boards already connected to same LAN)
	ii. vcu-demo-transcode-to-streamout.sh  -i /home/root/bbb_sunflower_2160p_30fps_normal_hevc.mkv -c hevc -b 5000 -a <Client Machine/Board IP address>

7.  Example-6: (Camera Audio/Video -> Encode -> File A/V Record)
    • Connect USB camera to the board (Verified Cameras: Logitech HD camera C920).
    • Execute below command for USB video video recording.
	i. vcu-demo-camera-encode-file.sh -a aac -n 1000 --use-alsasrc -i "hw:1"
	ii. Output file camera_output.ts will be generated on current directory which will have recorded Audio/Video file in mpegts container.
	iii.The file can be played on media players like VLC.

8.  Example-7 : (Camera Audio/Video → Stream out using Ethernet  ... Streaming In → Decode → Display with Audio)
    • This example requires two boards, board-1 is used for encoding live A/V feed from camera and stream-out (as a server) and board 2 is
      used for streaming-in and decode purpose to play received Audio/Video stream (as a client)
    • Connect two boards back to back with Ethernet cable or make sure both the boards are connected to same Ethernet hub.
    • Client settings
	i. Set Client IP address and execute stream-in → Decode example on board-2.
	   • ifconfig eth0 192.168.0.2 (note: setting of ip is not required if the boards already connected to same LAN)
 	   • vcu-demo-streamin-decode-display.sh -c avc --audio-type aac (Note: This means client is receiving AVC bitstream from server, use -c hevc If server is sending HEVC bitstream)
	   • set server IP and run Camera -> Encode -> stream-out on board-1
		i. ifconfig eth0 192.168.0.1 (Note: setting of ip is not required if the boards already connected to same LAN)
		ii. vcu-demo-camera-encode-streamout.sh --audio-type aac --use-alsasrc -i "hw:1" --address 192.168.0.2


=======================================================
IV. Determining PulseAudio and AlSA Sound device names
=======================================================
  The audio device name (to provide with -i option) of audio source and playback device (to provide with --audio-output) can be found using arecord and aplay utilities respectively.

1. ALSA sound device names for capture devices
  i. arecord -l
	  **** List of CAPTURE Hardware Devices ****
	  card 1: C920 [HD Pro Webcam C920], device 0: USB Audio [USB Audio]
	  Subdevices: 1/1
	  Subdevice #0: subdevice #0
     Here card number of capture device is 1 and device id is 0 hence "hw:1,0" can be passed to alsasrc to refer to this capture device using -i option.

2. ALSA sound device names for playback devices
  ii. aplay -l
	  **** List of PLAYBACK Hardware Devices ****
	  card 0: monitor [DisplayPort monitor], device 0: (null) xilinx-dp-snd-codec-dai-0 []
	    Subdevices: 1/1
	    Subdevice #0: subdevice #0
	  card 0: monitor [DisplayPort monitor], device 1: (null) xilinx-dp-snd-codec-dai-1 []
	    Subdevices: 1/1
	    Subdevice #0: subdevice #0
       Here card number "0" is being used for playback device for display port channel 0 and device id is 0, so "hw:0,0" can be used for
       selecting display port channel 0 as playback device using --audio-output option.

3. PulseAudio sound device names for capture devices
  i. pactl list short sources
	0       alsa_input.usb-046d_HD_Pro_Webcam_C920_758B5BFF-02.analog-stereo  ...
	Here "alsa_input.usb-046d_HD_Pro_Webcam_C920_758B5BFF-02.analog-stereo" is the name of audio capture device which can be selected using -i option.

4. PulseAudio sound device names playback devices
  ii. pactl list short sinks
	0       alsa_output.platform-fd4a0000.zynqmp-display:zynqmp_dp_snd_card.analog-stereo ...
	Here "alsa_output.platform-fd4a0000.zynqmp-display:zynqmp_dp_snd_card.analog-stereo" is the name of audio playback device which can be selected using --audio-output option.



========================================================
V. Conguration settings for running standalone pipelines
========================================================
1. Boot the board using petalinux pre-builts.
2. Login into the board using username and password as root
3. Set below register values using devmem cmds. (Refer to PG252 document for more details about these register settings)
	a. Set Read and Write QOS value to LOW_PRIORITY (0x3) for VCU.
     • devmem 0xfd3b0008 w 0x3   #DEC0, DEC1<->HP3_FPD
     • devmem 0xfd3b001c w 0x3
     • devmem 0xfd3b0004 w 0xf
     • devmem 0xfd3b0018 w 0xf
     • devmem 0xfd390008 w 0x3    #ENC1<->HP1_FPD
     • devmem 0xfd39001c w 0x3
     • devmem 0xfd390004 w 0xf
     • devmem 0xfd390018 w 0xf
     • devmem 0xfd3a0008 w 0x3    #ENC0<->HP2_FPD
     • devmem 0xfd3a001c w 0x3
     • devmem 0xfd3a0004 w 0xf
     • devmem 0xfd3a0018 w 0xf
     • devmem 0xfd360008 w 0x3     #MCU<->HPC0
     • devmem 0xfd36001c w 0x3
     • devmem 0xfd360004 w 0x7
     • devmem 0xfd360018 w 0x7
4. Standalone gstreamer, OMX and CtrlSW pipelines can be executed on the board.

===============================
VI. Sample Gstreamer Pipelines
==============================

 "$gst-inspect-1.0 <element_name>" can be used to check the description of gstreamer elements and its properties.

 For Ex: To get description of each parameters for “omxh264dec” element run as below:
 root@zcu106-zynqmp:~#gst-inspect-1.0 omxh264dec

 H264 Decode:
 ===========
 Decode h264 input file and display on DP monitor.

 >> gst-launch-1.0 filesrc location="input-file.mp4" ! qtdemux name=demux demux.video_0 ! h264parse ! omxh264dec ! queue max-size-bytes=0 ! kmssink bus-id=fd4a0000.display fullscreen-overlay=1

 H265 Decode:
 ===========
 Decode h265 input file and display on DP monitor.

 >> gst-launch-1.0 filesrc location="input-file.mp4" ! qtdemux name=demux demux.video_0 ! h265parse ! omxh265dec ! queue max-size-bytes=0 ! kmssink bus-id=fd4a0000.display fullscreen-overlay=1
 (Note: Input-file.mp4 could be of any format ( 420/422 8bit , 420/422 10bit))

 Higher bitrate bitstream decoding: Decoder may take more than one frame period time for high bitrate decoding (> 100Mbps). Use below options to get better decoder performance.
 • Increase internal entropy buffers count to 9.
 • Add a queue at decoder input side.
 • The below command decodes h264 video file using 9 internal entropy buffers.

 >> gst-launch-1.0 filesrc location="input-file.mp4" ! qtdemux name=demux demux.video_0 ! h264parse ! queue max-size-bytes=0 ! omxh264dec internal-entropy-buffers=9 ! queue max-size-bytes=0 ! kmssink bus-id=fd4a0000.display fullscreen-overlay=1

 H264 Encode:
 ===========
 Encode 3840x2160 YUV fine using AVC encoder

 4:2:0-8bit (NV12):

 >> gst-launch-1.0 filesrc location="input-file.yuv" ! videoparse format=nv12 width=3840 height=2160 framerate=30/1 !  omxh264enc ! filesink location=”output.h264”

 4:2:2-8bit (NV16):

 >> gst-launch-1.0 filesrc location="input-file.yuv" ! videoparse format=nv16 width=3840 height=2160 framerate=30/1 !  omxh264enc ! filesink location=”output.h264”

 4:2:0-10bit (NV12_10LE32):

 >> gst-launch-1.0 filesrc location="input-file.yuv" ! videoparse format=nv12-10le32 width=3840 height=2160 framerate=30/1 !  omxh264enc ! filesink location=”output.h264”

 4:2:2-10bit(NV16_10LE32):

 >> gst-launch-1.0 filesrc location="input-file.yuv" ! videoparse format=nv16-10le32 width=3840 height=2160 framerate=30/1 !  omxh264enc ! filesink location=”output.h264”

 H265 Encode:
 ===========
 Encode 3840x2160 yuv file using HEVC encoder

 4:2:0-8bit(NV12):

 >> gst-launch-1.0 filesrc location="input-file.yuv" ! videoparse format=nv12 width=3840 height=2160 framerate=30/1 !  omxh265enc ! filesink location=”output.h265”

 4:2:2-8bit(NV16):

 >> gst-launch-1.0 filesrc location="input-file.yuv" ! videoparse format=nv16 width=3840 height=2160 framerate=30/1 !  omxh265enc ! filesink location=”output.h265”

 4:2:0-10bit(NV12_10LE32):

 >> gst-launch-1.0 filesrc location="input-file.yuv" ! videoparse format=nv12-10le32 width=3840 height=2160 framerate=30/1 !  omxh265enc ! filesink location=”output.h265”

 4:2:2-10bit(NV16_10LE32):

 >> gst-launch-1.0 filesrc location="input-file.yuv" ! videoparse format=nv16-10le32 width=3840 height=2160 framerate=30/1 !  omxh265enc ! filesink location=”output.h265”

 Note: input-yuv should be in respective input-format

 Transcode from H264 to H265:
 ===========================
 Convert h264 format file into h265 format:

 >> gst-launch-1.0 filesrc location="input-h264-file.mp4" ! qtdemux name=demux demux.video_0 ! h264parse ! omxh264dec ! omxh265enc ! filesink location="output.h265"

 Transcode from H265 to H264:
 ============================
 Convert h265 format file into h264 format:

 >> gst-launch-1.0 filesrc location="input-h265-file.mp4" ! qtdemux name=demux demux.video_0 ! h265parse ! omxh265dec ! omxh264enc ! filesink location="output.h264"

 Multistream Decoding:
 ====================
 Decode h265 video using 4 decoder elements simultaneously and save them to separate files

 >> gst-launch-1.0 filesrc location=input_1920x1080.mp4 ! qtdemux ! h265parse ! tee name=t t. ! queue ! omxh265dec ! queue max-size-bytes=0 ! filesink location=output_0_1920x1080.yuv t. ! queue ! omxh265dec ! queue max-size-bytes=0 ! filesink location=output_1_1920x1080.yuv t. ! queue ! omxh265dec ! queue max-size-bytes=0 ! filesink location=output_2_1920x1080.yuv t. ! queue ! omxh265dec ! queue max-size-bytes=0 ! filesink location=output_3_1920x1080.yuv

 Note: tee element is used to feed same input file into 4 decoder instances, user can use separate gst-launch-1.0 application to feed different inputs.

 Multistream Encoding:
 ====================
 Encode input yuv file using 8 encoder elements simultaneously.

 >> gst-launch-1.0 filesrc location=input_nv12_1920x1080.yuv ! videoparse width=1920 height=1080 format=nv12 framerate=30/1 ! tee name=t t. ! queue ! omxh264enc control-rate=2 target-bitrate=8000 ! video/x-h264, profile=high ! filesink location= ouput_0.h264 t. ! queue ! omxh264enc control-rate=2 target-bitrate=8000 ! video/x-h264, profile=high ! filesink location=ouput_1.h264 t. ! queue ! omxh264enc control-rate=2 target-bitrate=8000 ! video/x-h264, profile=high ! filesink location= ouput_2.h264 t. ! queue ! omxh264enc control-rate=2 target-bitrate=8000 ! video/x-h264, profile=high ! filesink location= ouput_3.h264 t. ! queue ! omxh264enc control-rate=2 target-bitrate=8000 ! video/x-h264, profile=high ! filesink location= ouput_4.h264 t. ! queue ! omxh264enc control-rate=2 target-bitrate=8000 ! video/x-h264, profile=high ! filesink location= ouput_5.h264 t.
 ! queue ! omxh264enc control-rate=2 target-bitrate=8000 ! video/x-h264, profile=high ! filesink location= ouput_6.h264 t. ! queue ! omxh264enc control-rate=2 target-bitrate=8000 ! video/x-h264, profile=high ! filesink location= ouput_7.h264

 For different input yuv formats following changes are required in above pipeline:
	4:2:2-8bit (NV16): 		format=nv16 and profile=high-4:2:2
    	4:2:0-10bit (NV12_10LE32):	format=nv12-10le32 and profile=high-10
    	4:2:2-10bit (NV16_10LE32):	format=nv16-10le32 and profile=high-4:2:2

Note: tee element is used to feed same input file into 8 encoder instances, user can use separate gst-launch-1.0 application to feed different inputs

=========================================
Sample Openmax/Control-Software Pipelines
=========================================

 Openmax Examples
 ================

 �"omx_decoder –help�" shows all the options for decoder application
 �"omx_encoder –help�" shows all the options for encoder application

 Decode File to File:
 >> omx_decoder input-file.h265 -hevc -o out.yuv

 Encode File to File:
 >> omx_encoder  inputfile.yuv --width 352 --height 288 --framerate 30 --avc --out out.h264

 (Note: Input YUV file should be in NV12 format)

 Control-Software Examples
 =========================

 Decode File to File:

 H264 Decode:
 >> ctrlsw_decoder -avc -in input-avc-file.h264 -out ouput.yuv

 H265 Decode:
 >> ctrlsw_decoder -hevc -in input-hevc-file.h265 -out ouput.yuv

 Encode File to File:
 >> ctrlsw_encoder –cfg encode_simple.cfg

Note: Users can use this as a demo example to run encode and decode applications at control software with different encoder configurations.
Refer to PG252 for possible encoder settings and cfg file parameters,
Sample cfg file is located at Control Software source "https://github.com/Xilinx/vcu-ctrl-sw/tree/master/test/config"
