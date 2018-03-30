Zynq Ultrascale+ MPSoC:VideoCodecUnit-ReadMe
============================================

Table of Contents
=================
• Supported VCU-Features and Specifiacation
• VCU out-of-box Examples Description
• Conguration settings for running standalone pipelines
• Sample Gstreaemr Pipelines
• Sample Control-Software/Openmax Pipelines

=====================================
Supported Features and Specifiacation
=====================================
Refer to PG252 (H.264/H.265 VideoCodec Unit v1.0) document at "https://www.xilinx.com/support.html#documentation"


====================================
VCU out-of-box Examples Description
====================================

 Below mentioned 5 VCU examples are supported in this build. Matchbox desktop shows two VCU application corresponds to VCU-Decode->Display use case, details are mentioned in Example-1 description.

 1.	VCU-Decode → Display: Decodes AVC/HEVC encoded container stream and Displays on DP monitor. It supports aac/vorbis audio decode as well.
 2.	USB-Camera → Encode → Decode → Display: Captures raw video frames from Camera and Encode/Decode using VCU and display using DP monitor.
 3.	USB-Camera → Decode → Display: Captures encoded video content from Camera, Decode using VCU  and display using DP monitor.
 4.	Transcode → to File: Transcodes input AVC/HEVC encoded bitstream into HEVC/AVC format and stores on disk.
 5.	Transcode → Stream out using Ethernet  ... Streaming In → Decode → Display: Transcodes input AVC/HEVC encoded bitstream into HEVC/AVC format and streams out to another board using RTP/UDP , and second board receives the data Decode using VCU, Display using DP monitor.

 =========================
 Steps to Verify Examples:
 =========================
 1. Boot the board (ZCU106/ZCU104) using petalinux pre-built.
	• Make sure your board is connected to Ethernet, this is required to download sample video content from Xilinx web server.
	• If you are using private network, then export proxy settings in /home/root/.bashrc file as below,
		i.  create/open a bashrc file using "vi ~/.bashrc"
		ii. Insert/add below line to bashrc file
			export http_proxy="<private network proxy address>"
	• If the board is not connected to internet, then you need to download the content using host machine and copy input files in to "/home/root/" folder. Use below commands to download the content in the host machine.
	• For AVC sample file:  wget http://petalinux.xilinx.com/test-2018.1/video-files/bbb_sunflower_2160p_30fps_normal_avc.mp4
	• For HEVC sample file: wget http://petalinux.xilinx.com/test-2018.1/video-files/bbb_sunflower_2160p_30fps_normal_hevc.mkv

 2. Example-1: (Decode → Display)
	• Matchbox Desktop will have below two applications
    • 4K AVC Decode: Click on this application, it will download sample AVC/AAC encoded bitstream and runs VCU Example-1 (Decode → Display). If the sample avc content is already present in /home/root then it will just decode→display the content.
	• 4K HEVC Decode: same as above but it uses HEVC/Voribis encoded bitstream.
	• Decode→ Display can be executed using command line option as well, use below command to run this example. Running the script with "-h" option shows all possible options.
		i.	vcu-demo-decode-display.sh -i /home/root/bbb_sunflower_2160p_30fps_normal_avc.mp4 -c avc -a aac
		ii.	vcu-demo-decode-display.sh -i /home/root/bbb_sunflower_2160p_30fps_normal_hevc.mkv -c hevc -a vorbis
 
 3.	Example-2: (USB-Camera → Encode → Decode → Display)
	• Connect USB camera to the board (Verified Cameras: Logitech HD camera).
	• Run below command to run Example 2
		i.	vcu-demo-camera-encode-decode-display.sh -s 640x480
			   
 4.	Example-3: (USB-Camera → Decode → Display)
	• Connect USB camera to the board (Verified Cameras: Logitech HD camera).
	• Run below command to run Example 3
		i.	vcu-demo-camera-decode-display.sh -s 1920x1080
	
	(Note: Resolution for Example 2&3 need to set base on USB Camera Capabilities.
           Capabilities can be found using "v4l2-ctl --list-formats-ext". V4lutils are not installed in the pre-built image, need to install using dnf or rebuild petalinux image including v4lutils)

 5.	Example-4: (Transcode → to File)
	• This example requires input sample files. If you have run Example-1 already, then sample encoded video content will be available in "/home/root" folder, if not then you need to download the content by running Desktop application (as mentioned in #1 above).
	• Use below command to transcode sample avc file into hevc file.
		i.	vcu-demo-transcode-to-file.sh -i /home/root/bbb_sunflower_2160p_30fps_normal_avc.mp4 -c avc -o /home/root/transcode.hevc
	• Use Example-1 again to view the transcoded file on the Display, run below command
		i.	vcu-demo-decode-display.sh -i /home/root/transcode.hevc -c hevc

 6.	Example-5 : (Transcode → Stream out using Ethernet  ... Streaming In → Decode → Display)
	• This example requires two boards, board-1 is used for transcode and stream-out (as a server) and board 2 is used for streaming-in and decode purpose (as a client) or we can use VLC player on the host machine as client instead of board 2.
	• Make sure you have one sample input file in board-1 (server) "/home/root/" folder, if not please run desktop example to download the corresponding content (AVC/HEVC).
	• Connect two boards back to back with Ethernet cable or make sure both the boards are connected to same Ethernet hub.
	• If you using VLC player as client them make sure you host machine and server board (board 1) are connected to same Ethernet hub or Connect them back to back using Ethernet cable
	• Client settings
		i.	set Client IP and run stream-in → Decode example on board 2, if you are using board 2 as client and connected the boards back to back.
			• ifconfig eth0 192.168.0.2 (note: setting of ip is not required if the boards already connected to same LAN)
			• vcu-demo-streamin-decode-display.sh -c avc (note: This mean client is receing AVC bitstream from server, use -c hevc If server is sending HEVC bitstream)
		ii.	If you are using VLC player on the host machine as Client then,
			• set the host machine IP address to 192.168.0.2, if you have connected host machine and the board back-to-back with ethernet cable. (note: Setting of ip is not required if the boards already connected to same LAN)
			• Create test.sdp file using below content (add separate line for each mentioned item below in test.sdp) and play test.sdp on host machine.
				1.	v=0 c=IN IP4 <Client machine IP address>
				2.	m=video 50000 RTP/AVP 96
				3.	a=rtpmap:96 H264/90000
				4.	a=framerate=30
		• Trouble-shoot for VLC player setup:
			o IP4 is client-IP address
			o H264/H265 is used based received codec type on the client
			o You may need to turn-off firewall in host machine.
	• set server IP and run Transcode → stream-out on board 1
		i.	ifconfig eth0 192.168.0.1 (note: setting of ip is not required if the boards already connected to same LAN)
		ii.	vcu-demo-transcode-to-streamout.sh  -i /home/root/bbb_sunflower_2160p_30fps_normal_hevc.mkv -c hevc -b 5000 -a <Client Machine/Board IP address>


=====================================================
Conguration settings for running standalone pipelines
=====================================================
1. Boot the board using petalinux pre-builts.
2. Login into the board using username and password as root
3. Set below register values using devmem cmds. (Refer to PG252 document for more details about these register settings)
	a. Set Read and Write QOS value to LOW_PRIORITY (0x3) for VCU.
     • devmem 0xfd3a0008 w 0x3   # Set read cmd as low priority in AFIFM4_RDQoS register
     • devmem 0xfd3b0008 w 0x3  # Set read cmd as low priority in AFIFM5_RDQoS register
     • devmem 0xfd3a001c w 0x3   # Set write cmd as low priority in AFIFM4_WRQoS register
     • devmem 0xfd3b001c w 0x3  # Set write cmd as low priority in AFIFM5_WRQoS register
    b. Set no. of Read & Write Issuing capability to 16 cmds from the AXI_FM to the PS-side.
     • devmem 0xfd3a0004 w 0xf  # Set read capability to 0xf cmds in AFIFM4_RDISSUE reg
	 • devmem 0xfd3b0004 w 0xf  # Set read capability to 0xf cmds in AFIFM5_RDISSUE reg
	 • devmem 0xfd3a0018 w 0xf  # Set write capability to 0xf cmds in AFIFM4_WRISSUE reg
	 • devmem 0xfd3b0018 w 0xf  # Set write capability to 0xf cmds in AFIFM5_WRISSUE reg
4. Standalone gstreamer, OMX and CtrlSW pipelines can be executed on the board.


============================
Sample Gstreaemr Pipelines
===========================

 "$gst-inspect-1.0 <element_name>" can be used to see the description of gstreamer elements and properties used in each of them.
 For Ex: To get description of each parameters for “omxh264dec” element run as below:
 root@zcu106-zynqmp:~#gst-inspect-1.0 omxh264dec
 
 H264 Decode:
 ===========
 Decode h264 based input file and display it over monitor connected to Display port

 >> gst-launch-1.0 filesrc location="input-file.mp4" ! qtdemux name=demux demux.video_0 ! h264parse ! omxh264dec ! queue max-size-bytes=0 ! kmssink bus-id=fd4a0000.zynqmp-display fullscreen-overlay=1

 H265 Decode:
 ===========
 Decode h265 based input file and display it over monitor connected to Display port

 >> gst-launch-1.0 filesrc location="input-file.mp4" ! qtdemux name=demux demux.video_0 ! h265parse ! omxh265dec ! queue max-size-bytes=0 ! kmssink bus-id=fd4a0000.zynqmp-display fullscreen-overlay=1
 (Note: Input-file.mp4 could be of any format ( 420/422 8bit , 420/422 10bit))

 Higher bitrate bitstream decoding: Decoder generally might take higher than one frame period time for high bitrate stream decoding (> 100Mbps, 4kP30), use below options to get better decoder performance.
 • Increase internal decoder buffers (internal-entropy-buffers parameter) to 9/10.
 • Add a queue at decoder input side
 • The below command decodes h264 based input mp4 file using more number of internal entropy buffers and displays it over DP.

 >> gst-launch-1.0 filesrc location="input-file.mp4" ! qtdemux name=demux demux.video_0 ! h264parse ! queue max-size-bytes=0 ! omxh264dec internal-entropy-buffers=10 ! queue max-size-bytes=0 ! kmssink bus-id=fd4a0000.zynqmp-display fullscreen-overlay=1

 H264 Encode:
 ===========
 Encode input 3840x2160 4:2:0-8bit (NV12) yuv file to h264 based format

 >> gst-launch-1.0 filesrc location="input-file.yuv" ! videoparse format=nv12 width=3840 height=2160 framerate=30/1 !  omxh264enc ! filesink location=”output.h264”

 Encode input 3840x2160 4:2:2-8bit (NV16) yuv file to h264 based format

 >> gst-launch-1.0 filesrc location="input-file.yuv" ! videoparse format=nv16 width=3840 height=2160 framerate=30/1 !  omxh264enc ! filesink location=”output.h264”

 Encode input 3840x2160 4:2:0-10bit (NV12_10LE32) yuv file to h264 based format

 >> gst-launch-1.0 filesrc location="input-file.yuv" ! videoparse format=nv12-10le32 width=3840 height=2160 framerate=30/1 !  omxh264enc ! filesink location=”output.h264”

 Encode input 3840x2160 4:2:2-10bit(NV16_10LE32) yuv file to h264 based format

 >> gst-launch-1.0 filesrc location="input-file.yuv" ! videoparse format=nv16-10le32 width=3840 height=2160 framerate=30/1 !  omxh264enc ! filesink location=”output.h264”

 H265 Encode:
 ===========
 Encode input 3840x2160 4:2:0-8bit(NV12) yuv file to h265 based format

 >> gst-launch-1.0 filesrc location="input-file.yuv" ! videoparse format=nv12 width=3840 height=2160 framerate=30/1 !  omxh265enc ! filesink location=”output.h265”

 Encode input 3840x2160 4:2:2-8bit(NV16) yuv file to h265 based format

 >> gst-launch-1.0 filesrc location="input-file.yuv" ! videoparse format=nv16 width=3840 height=2160 framerate=30/1 !  omxh265enc ! filesink location=”output.h265”

 Encode input 3840x2160 4:2:0-10bit(NV12_10LE32) yuv file to h265 based format

 >> gst-launch-1.0 filesrc location="input-file.yuv" ! videoparse format=nv12-10le32 width=3840 height=2160 framerate=30/1 !  omxh265enc ! filesink location=”output.h265”

 Encode input 3840x2160 4:2:2-10bit(NV16_10LE32) yuv file to h265 based format

 >> gst-launch-1.0 filesrc location="input-file.yuv" ! videoparse format=nv16-10le32 width=3840 height=2160 framerate=30/1 !  omxh265enc ! filesink location=”output.h265”

 Note: input-yuv should be in respective input-format

 Transcode from H264 to H265:
 ===========================
 Convert h264 based input container format file into h265 format

 >> gst-launch-1.0 filesrc location="input-h264-file.mp4" ! qtdemux name=demux demux.video_0 ! h264parse ! omxh264dec ! omxh265enc ! filesink location="output.h265"

 Transcode from H265 to H264:
 ============================
 Convert h265 based input container format file into h264 format

 >> gst-launch-1.0 filesrc location="input-h265-file.mp4" ! qtdemux name=demux demux.video_0 ! h265parse ! omxh265dec ! omxh264enc ! filesink location="output.h264"

 Multistream Decoding:
 ====================
 Decode h265 based input file using 4 decoder elements simultaneously and save them to separate files

 >> gst-launch-1.0 filesrc location=input_1920x1080.mp4 ! qtdemux ! h265parse ! tee name=t t. ! queue ! omxh265dec ! queue max-size-bytes=0 ! filesink location=output_0_1920x1080.yuv t. ! queue ! omxh265dec ! queue max-size-bytes=0 ! filesink location=output_1_1920x1080.yuv t. ! queue ! omxh265dec ! queue max-size-bytes=0 ! filesink location=output_2_1920x1080.yuv t. ! queue ! omxh265dec ! queue max-size-bytes=0 ! filesink location=output_3_1920x1080.yuv

 Note: tee element is used to fed same input file into 4 decoder instances, user can use separate gst-launch-1.0 application to fed different inputs.

 Multistream Encoding:
 ====================
 Encode input yuv file into 8 streams by using 8 encoder elements simultaneously.

 >> gst-launch-1.0 filesrc location=input_nv12_1920x1080.yuv ! videoparse width=1920 height=1080 format=nv12 framerate=30/1 ! tee name=t t. ! queue ! omxh264enc control-rate=2 target-bitrate=8000 ! video/x-h264, profile=high ! filesink location= ouput_0.h264 t. ! queue ! omxh264enc control-rate=2 target-bitrate=8000 ! video/x-h264, profile=high ! filesink location=ouput_1.h264 t. ! queue ! omxh264enc control-rate=2 target-bitrate=8000 ! video/x-h264, profile=high ! filesink location= ouput_2.h264 t. ! queue ! omxh264enc control-rate=2 target-bitrate=8000 ! video/x-h264, profile=high ! filesink location= ouput_3.h264 t. ! queue ! omxh264enc control-rate=2 target-bitrate=8000 ! video/x-h264, profile=high ! filesink location= ouput_4.h264 t. ! queue ! omxh264enc control-rate=2 target-bitrate=8000 ! video/x-h264, profile=high ! filesink location= ouput_5.h264 t.
 ! queue ! omxh264enc control-rate=2 target-bitrate=8000 ! video/x-h264, profile=high ! filesink location= ouput_6.h264 t. ! queue ! omxh264enc control-rate=2 target-bitrate=8000 ! video/x-h264, profile=high ! filesink location= ouput_7.h264

 For different input yuv formats following changes are required in above pipeline:
	4:2:2-8bit (NV16): 		format=nv16 and profile=high-4:2:2
    4:2:0-10bit (NV12_10LE32):	format=nv12-10le32 and profile=high-10
    4:2:2-10bit (NV16_10LE32):	format=nv16-10le32 and profile=high-4:2:2

	Note: tee element is used to fed same input file into 8 encoder instances, user can use separate gst-launch-1.0 application to fed different inputs


=========================================
Sample Openmax/Control-Software Pipelines
=========================================

 Openmax Examples
 ================
 
 “omx_decoder.exe –help” shows all the options for decoder application
 “omx_encoder.exe –help” shows all the options for encoder application

 Decode File to File:
 >> omx_decoder.exe input-file.h265 -hevc -o out.yuv

 Encode File to File:
 >> omx_encoder.exe  inputfile.yuv -w 352 -h 288 -r 30 -avc -o out.h264

 (Note: Input YUV file should be in NV12 format)

 Control-Software Examples
 =========================
 
 Decode File to File:

 H264 Decode:
 >> AL_Decoder -avc -in input-avc-file.h264 -out ouput.yuv
 H265 Decode:
 >> AL_Decoder -hevc -in input-hevc-file.h265 -out ouput.yuv

 Encode File to File:
 >> AL_Encoder –cfg encode_simple.cfg
 (Note: Users can use this as a demo example to run encode and decode applications at control software level with different configurations.
  Refer to PG252 for possible encoder settings and cfg file parameters, Sample cfg file is located at "test/config" folder on Control Software source "https://github.com/Xilinx/vcu-ctrl-sw/tree/master/test/config")
