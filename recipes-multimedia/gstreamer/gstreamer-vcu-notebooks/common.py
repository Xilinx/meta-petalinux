#   Copyright (c) 2019, Xilinx, Inc.
#   All rights reserved.
#
#   Redistribution and use in source and binary forms, with or without
#   modification, are permitted provided that the following conditions are met:
#
#   1.  Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#
#   2.  Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#
#   3.  Neither the name of the copyright holder nor the names of its
#       contributors may be used to endorse or promote products derived from
#       this software without specific prior written permission.
#
#   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
#   THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
#   PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
#   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
#   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#   OR BUSINESS INTERRUPTION). HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#   OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#   ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

class common_vcu_demo_decode_display:
    def cmd_line_args_generator(INPUT_FILE_PATH, INPUT_URL, CODEC_TYPE, AUDIO_CODEC, DISPLAY_DEVICE, SHOW_FPS, LOOP_VIDEO, INTERNAL_ENTROPY_BUFFERS, PROXY_SERVER_URL, AUDIO_SINK, AUDIO_OUTPUT, SINK_NAME):
        CMD_LINE_ARGS = []
        if(len(INPUT_FILE_PATH) != 0):
        	CMD_LINE_ARGS.append('-i')
        	CMD_LINE_ARGS.append(INPUT_FILE_PATH)
        if(len(INPUT_URL) != 0):
        	CMD_LINE_ARGS.append('-u')
        	CMD_LINE_ARGS.append(INPUT_URL)
        if(len(INPUT_FILE_PATH) == 0 and len(INPUT_URL) == 0):
        	CMD_LINE_ARGS.append('-i')
        	CMD_LINE_ARGS.append("/usr/share/movies/bbb_sunflower_2160p_30fps_normal.mp4")
        if(len(CODEC_TYPE) != 0):
        	CMD_LINE_ARGS.append('-c')
        	CMD_LINE_ARGS.append(CODEC_TYPE)
        if(AUDIO_CODEC != 'none'):
        	CMD_LINE_ARGS.append('-a')
        	CMD_LINE_ARGS.append(AUDIO_CODEC)
        if(DISPLAY_DEVICE == 'DP'):
            CMD_LINE_ARGS.append('-d')
            DISPLAY_DEVICE = 'fd4a0000.zynqmp-display'
            CMD_LINE_ARGS.append(DISPLAY_DEVICE)
        elif(DISPLAY_DEVICE == 'HDMI'):
            CMD_LINE_ARGS.append('-d')
            DISPLAY_DEVICE = 'a0070000.v_mix'
            CMD_LINE_ARGS.append(DISPLAY_DEVICE)
        if(SHOW_FPS == 1):
        	CMD_LINE_ARGS.append('-f')
        if(LOOP_VIDEO == 1):
        	CMD_LINE_ARGS.append('-l')
        if(INTERNAL_ENTROPY_BUFFERS != '5'):
        	CMD_LINE_ARGS.append('-e')
        	CMD_LINE_ARGS.append(INTERNAL_ENTROPY_BUFFERS)
        if(len(PROXY_SERVER_URL) != 0):
        	CMD_LINE_ARGS.append('-p')
        	CMD_LINE_ARGS.append(PROXY_SERVER_URL)
        if(AUDIO_SINK == 'pulsesink'):
        	CMD_LINE_ARGS.append('--use-pulsesink')
        elif(AUDIO_SINK == 'alsasink'):
        	CMD_LINE_ARGS.append('--use-alsasink')
        if(len(AUDIO_OUTPUT) != 0):
        	CMD_LINE_ARGS.append('--audio-output')
        	CMD_LINE_ARGS.append(AUDIO_OUTPUT)
        if(SINK_NAME != 'kmssink'):
        	CMD_LINE_ARGS.append('-o')
        	CMD_LINE_ARGS.append(SINK_NAME)
        CMD_LINE_ARGS = " ".join(CMD_LINE_ARGS)
        print("sh common_vcu_demo_decode_display.sh", CMD_LINE_ARGS)
        return CMD_LINE_ARGS

class common_vcu_demo_camera_encode_file:
    def cmd_line_args_generator(DEVICE_ID, VIDEO_CAPTURE_DEVICE, VIDEO_SIZE, CODEC_TYPE, AUDIO_CODEC, FRAME_RATE, OUTPUT_PATH, NO_OF_FRAMES, BIT_RATE, INTERNAL_ENTROPY_BUFFERS, SHOW_FPS, AUDIO_SRC, COMPRESSED_MODE, GOP_LENGTH, FAKE_SINK):
        CMD_LINE_ARGS = []
        if(len(DEVICE_ID) != 0):
        	CMD_LINE_ARGS.append('-i')
        	CMD_LINE_ARGS.append(DEVICE_ID)
        if(len(VIDEO_CAPTURE_DEVICE) != 0):
        	CMD_LINE_ARGS.append('-v')
        	CMD_LINE_ARGS.append(VIDEO_CAPTURE_DEVICE)
        if(len(VIDEO_SIZE) != 0):
        	CMD_LINE_ARGS.append('-s')
        	CMD_LINE_ARGS.append(VIDEO_SIZE)
        if(len(CODEC_TYPE) != 0):
        	CMD_LINE_ARGS.append('-c')
        	CMD_LINE_ARGS.append(CODEC_TYPE)
        if(AUDIO_CODEC != 'none'):
        	CMD_LINE_ARGS.append('-a')
        	CMD_LINE_ARGS.append(AUDIO_CODEC)
        if(len(FRAME_RATE) != 0):
        	CMD_LINE_ARGS.append('-r')
        	CMD_LINE_ARGS.append(FRAME_RATE)
        if(len(OUTPUT_PATH) != 0 and FAKE_SINK == 'none'):
        	CMD_LINE_ARGS.append('-o')
        	CMD_LINE_ARGS.append(OUTPUT_PATH)
        if(len(NO_OF_FRAMES) != 0):
        	CMD_LINE_ARGS.append('-n')
        	CMD_LINE_ARGS.append(NO_OF_FRAMES)
        if(len(BIT_RATE) != 0):
        	CMD_LINE_ARGS.append('-b')
        	CMD_LINE_ARGS.append(BIT_RATE)
        if(INTERNAL_ENTROPY_BUFFERS != '5'):
        	CMD_LINE_ARGS.append('-e')
        	CMD_LINE_ARGS.append(INTERNAL_ENTROPY_BUFFERS)
        if(SHOW_FPS == 1):
        	CMD_LINE_ARGS.append('-f')
        if(AUDIO_SRC == 'pulseaudiosrc'):
        	CMD_LINE_ARGS.append('--use-pulseaudiosrc')
        elif(AUDIO_SRC == 'alsasrc'):
        	CMD_LINE_ARGS.append('--use-alsasrc')
        if(COMPRESSED_MODE == 1):
        	CMD_LINE_ARGS.append('--compressed-mode')
        if(len(GOP_LENGTH) != 0):
        	CMD_LINE_ARGS.append('--gop-length')
        	CMD_LINE_ARGS.append(GOP_LENGTH)
        if(FAKE_SINK != 'none'):
        	CMD_LINE_ARGS.append('-o')
        	CMD_LINE_ARGS.append('fakevideosink')
        CMD_LINE_ARGS = " ".join(CMD_LINE_ARGS)
        print("sh common_vcu_demo_camera_encode_file.sh", CMD_LINE_ARGS)
        return CMD_LINE_ARGS

class common_vcu_demo_camera_decode_display:
    def cmd_line_args_generator(DEVICE_ID, VIDEO_CAPTURE_DEVICE, VIDEO_SIZE, CODEC_TYPE, AUDIO_CODEC, DISPLAY_DEVICE, SINK_NAME, NO_OF_FRAMES, BIT_RATE, INTERNAL_ENTROPY_BUFFERS, SHOW_FPS, AUDIO_SRC, AUDIO_OUTPUT, AUDIO_SINK, FRAME_RATE):
        CMD_LINE_ARGS = []
        if(len(DEVICE_ID) != 0):
        	CMD_LINE_ARGS.append('-i')
        	CMD_LINE_ARGS.append(DEVICE_ID)
        if(len(VIDEO_CAPTURE_DEVICE) != 0):
        	CMD_LINE_ARGS.append('-v')
        	CMD_LINE_ARGS.append(VIDEO_CAPTURE_DEVICE)
        if(len(VIDEO_SIZE) != 0):
        	CMD_LINE_ARGS.append('-s')
        	CMD_LINE_ARGS.append(VIDEO_SIZE)
        if(len(CODEC_TYPE) != 0):
        	CMD_LINE_ARGS.append('-c')
        	CMD_LINE_ARGS.append(CODEC_TYPE)
        if(AUDIO_CODEC != 'none'):
        	CMD_LINE_ARGS.append('-a')
        	CMD_LINE_ARGS.append(AUDIO_CODEC)
        if(DISPLAY_DEVICE == 'DP'):
            CMD_LINE_ARGS.append('-d')
            DISPLAY_DEVICE = 'fd4a0000.zynqmp-display'
            CMD_LINE_ARGS.append(DISPLAY_DEVICE)
        elif(DISPLAY_DEVICE == 'HDMI'):
            CMD_LINE_ARGS.append('-d')
            DISPLAY_DEVICE = 'a0070000.v_mix'
            CMD_LINE_ARGS.append(DISPLAY_DEVICE)
        if(SINK_NAME != 'kmssink'):
        	CMD_LINE_ARGS.append('-o')
        	CMD_LINE_ARGS.append(SINK_NAME)
        if(len(NO_OF_FRAMES) != 0):
        	CMD_LINE_ARGS.append('-n')
        	CMD_LINE_ARGS.append(NO_OF_FRAMES)
        if(len(FRAME_RATE) != 0):
        	CMD_LINE_ARGS.append('-r')
        	CMD_LINE_ARGS.append(FRAME_RATE)
        if(len(BIT_RATE) != 0):
        	CMD_LINE_ARGS.append('-b')
        	CMD_LINE_ARGS.append(BIT_RATE)
        if(INTERNAL_ENTROPY_BUFFERS != '5'):
        	CMD_LINE_ARGS.append('-e')
        	CMD_LINE_ARGS.append(INTERNAL_ENTROPY_BUFFERS)
        if(SHOW_FPS == 1):
        	CMD_LINE_ARGS.append('-f')
        if(AUDIO_SRC == 'pulsesrc'):
        	CMD_LINE_ARGS.append('--use-pulsesrc')
        elif(AUDIO_SRC == 'alsasrc'):
        	CMD_LINE_ARGS.append('--use-alsasrc')
        if(len(AUDIO_OUTPUT) != 0):
        	CMD_LINE_ARGS.append('--audio-output')
        	CMD_LINE_ARGS.append(AUDIO_OUTPUT)
        if(AUDIO_SINK == 'pulsesink'):
        	CMD_LINE_ARGS.append('--use-pulsesink')
        elif(AUDIO_SINK == 'alsasink'):
        	CMD_LINE_ARGS.append('--use-alsasink')
        CMD_LINE_ARGS = " ".join(CMD_LINE_ARGS)
        print("sh common_vcu_demo_camera_decode_display.sh", CMD_LINE_ARGS)
        return CMD_LINE_ARGS

class common_vcu_demo_camera_encode_decode_display:
    def cmd_line_args_generator(DEVICE_ID, VIDEO_CAPTURE_DEVICE, VIDEO_SIZE, CODEC_TYPE, AUDIO_CODEC, DISPLAY_DEVICE, FRAME_RATE, SINK_NAME, NO_OF_FRAMES, BIT_RATE, INTERNAL_ENTROPY_BUFFERS, SHOW_FPS, AUDIO_SRC, AUDIO_OUTPUT, AUDIO_SINK):
        CMD_LINE_ARGS = []
        if(len(DEVICE_ID) != 0):
        	CMD_LINE_ARGS.append('-i')
        	CMD_LINE_ARGS.append(DEVICE_ID)
        if(len(VIDEO_CAPTURE_DEVICE) != 0):
        	CMD_LINE_ARGS.append('-v')
        	CMD_LINE_ARGS.append(VIDEO_CAPTURE_DEVICE)
        if(len(VIDEO_SIZE) != 0):
        	CMD_LINE_ARGS.append('-s')
        	CMD_LINE_ARGS.append(VIDEO_SIZE)
        if(len(CODEC_TYPE) != 0):
        	CMD_LINE_ARGS.append('-c')
        	CMD_LINE_ARGS.append(CODEC_TYPE)
        if(AUDIO_CODEC != 'none'):
        	CMD_LINE_ARGS.append('-a')
        	CMD_LINE_ARGS.append(AUDIO_CODEC)
        if(DISPLAY_DEVICE == 'DP'):
            CMD_LINE_ARGS.append('-d')
            DISPLAY_DEVICE = 'fd4a0000.zynqmp-display'
            CMD_LINE_ARGS.append(DISPLAY_DEVICE)
        elif(DISPLAY_DEVICE == 'HDMI'):
            CMD_LINE_ARGS.append('-d')
            DISPLAY_DEVICE = 'a0070000.v_mix'
            CMD_LINE_ARGS.append(DISPLAY_DEVICE)
        if(len(FRAME_RATE) != 0):
        	CMD_LINE_ARGS.append('-r')
        	CMD_LINE_ARGS.append(FRAME_RATE)
        if(SINK_NAME != 'kmssink'):
        	CMD_LINE_ARGS.append('-o')
        	CMD_LINE_ARGS.append(SINK_NAME)
        if(len(NO_OF_FRAMES) != 0):
        	CMD_LINE_ARGS.append('-n')
        	CMD_LINE_ARGS.append(NO_OF_FRAMES)
        if(len(BIT_RATE) != 0):
        	CMD_LINE_ARGS.append('-b')
        	CMD_LINE_ARGS.append(BIT_RATE)
        if(INTERNAL_ENTROPY_BUFFERS != '5'):
        	CMD_LINE_ARGS.append('-e')
        	CMD_LINE_ARGS.append(INTERNAL_ENTROPY_BUFFERS)
        if(SHOW_FPS == 1):
        	CMD_LINE_ARGS.append('-f')
        if(AUDIO_SRC == 'pulsesrc'):
        	CMD_LINE_ARGS.append('--use-pulsesrc')
        elif(AUDIO_SRC == 'alsasrc'):
        	CMD_LINE_ARGS.append('--use-alsasrc')
        if(len(AUDIO_OUTPUT) != 0):
        	CMD_LINE_ARGS.append('--audio-output')
        	CMD_LINE_ARGS.append(AUDIO_OUTPUT)
        if(AUDIO_SINK == 'pulsesink'):
        	CMD_LINE_ARGS.append('--use-pulsesink')
        elif(AUDIO_SINK == 'alsasink'):
        	CMD_LINE_ARGS.append('--use-alsasink')
        CMD_LINE_ARGS = " ".join(CMD_LINE_ARGS)
        print("sh common_vcu_demo_camera_encode_decode_display.sh", CMD_LINE_ARGS)
        return CMD_LINE_ARGS

class common_vcu_demo_camera_encode_streamout:
    def cmd_line_args_generator(DEVICE_ID, VIDEO_CAPTURE_DEVICE, VIDEO_SIZE, CODEC_TYPE, AUDIO_CODEC, FRAME_RATE, OUTPUT_PATH, NO_OF_FRAMES, BIT_RATE, SHOW_FPS, AUDIO_SRC, PERIODICITY_IDR, GOP_LENGTH, COMPRESSED_MODE, FAKE_SINK, ADDRESS_PATH):
        CMD_LINE_ARGS = []
        if(len(DEVICE_ID) != 0):
        	CMD_LINE_ARGS.append('-i')
        	CMD_LINE_ARGS.append(DEVICE_ID)
        if(len(VIDEO_CAPTURE_DEVICE) != 0):
        	CMD_LINE_ARGS.append('-v')
        	CMD_LINE_ARGS.append(VIDEO_CAPTURE_DEVICE)
        if(len(VIDEO_SIZE) != 0):
        	CMD_LINE_ARGS.append('-s')
        	CMD_LINE_ARGS.append(VIDEO_SIZE)
        if(len(CODEC_TYPE) != 0):
        	CMD_LINE_ARGS.append('-c')
        	CMD_LINE_ARGS.append(CODEC_TYPE)
        if(AUDIO_CODEC != 'none'):
        	CMD_LINE_ARGS.append('-a')
        	CMD_LINE_ARGS.append(AUDIO_CODEC)
        if(len(FRAME_RATE) != 0):
        	CMD_LINE_ARGS.append('-r')
        	CMD_LINE_ARGS.append(FRAME_RATE)
        if(FAKE_SINK != 'none'):
        	CMD_LINE_ARGS.append('-o')
        	CMD_LINE_ARGS.append('fakevideosink')
        if(len(OUTPUT_PATH) != 0 and FAKE_SINK == 'none'):
        	CMD_LINE_ARGS.append('-o')
        	CMD_LINE_ARGS.append(OUTPUT_PATH)
        if(len(NO_OF_FRAMES) != 0):
        	CMD_LINE_ARGS.append('-n')
        	CMD_LINE_ARGS.append(NO_OF_FRAMES)
        if(len(BIT_RATE) != 0):
        	CMD_LINE_ARGS.append('-b')
        	CMD_LINE_ARGS.append(BIT_RATE)
        if(SHOW_FPS == 1):
        	CMD_LINE_ARGS.append('-f')
        if(AUDIO_SRC == 'pulseaudiosrc'):
        	CMD_LINE_ARGS.append('--use-pulseaudiosrc')
        elif(AUDIO_SRC == 'alsasrc'):
        	CMD_LINE_ARGS.append('--use-alsasrc')
        if(len(PERIODICITY_IDR) != 0):
        	CMD_LINE_ARGS.append('--periodicity-idr')
        	CMD_LINE_ARGS.append(PERIODICITY_IDR)
        if(len(GOP_LENGTH) != 0):
        	CMD_LINE_ARGS.append('--gop-length')
        	CMD_LINE_ARGS.append(GOP_LENGTH)
        if(COMPRESSED_MODE == 1):
        	CMD_LINE_ARGS.append('--compressed-mode')
        if(len(ADDRESS_PATH) != 0):
        	CMD_LINE_ARGS.append('--address')
        	CMD_LINE_ARGS.append(ADDRESS_PATH)
        CMD_LINE_ARGS = " ".join(CMD_LINE_ARGS)
        print("sh common_vcu_demo_camera_encode_streamout.sh", CMD_LINE_ARGS)
        return CMD_LINE_ARGS

class common_vcu_demo_streamin_decode_display:
    def cmd_line_args_generator(PORT_NUMBER, CODEC_TYPE, AUDIO_CODEC, DISPLAY_DEVICE, KERNEL_RECV_BUFFER_SIZE, SINK_NAME, INTERNAL_ENTROPY_BUFFERS, SHOW_FPS, AUDIO_SINK):
        CMD_LINE_ARGS = []
        if(len(PORT_NUMBER) != 0):
        	CMD_LINE_ARGS.append('-p')
        	CMD_LINE_ARGS.append(PORT_NUMBER)
        if(len(CODEC_TYPE) != 0):
        	CMD_LINE_ARGS.append('-c')
        	CMD_LINE_ARGS.append(CODEC_TYPE)
        if(AUDIO_CODEC != 'none'):
        	CMD_LINE_ARGS.append('-a')
        	CMD_LINE_ARGS.append(AUDIO_CODEC)
        if(DISPLAY_DEVICE == 'DP'):
            CMD_LINE_ARGS.append('-d')
            DISPLAY_DEVICE = 'fd4a0000.zynqmp-display'
            CMD_LINE_ARGS.append(DISPLAY_DEVICE)
        elif(DISPLAY_DEVICE == 'HDMI'):
            CMD_LINE_ARGS.append('-d')
            DISPLAY_DEVICE = 'a0070000.v_mix'
            CMD_LINE_ARGS.append(DISPLAY_DEVICE)
        if(len(KERNEL_RECV_BUFFER_SIZE) != 0):
        	CMD_LINE_ARGS.append('-b')
        	CMD_LINE_ARGS.append(KERNEL_RECV_BUFFER_SIZE)
        if(SINK_NAME != 'kmssink'):
        	CMD_LINE_ARGS.append('-o')
        	CMD_LINE_ARGS.append(SINK_NAME)
        if(INTERNAL_ENTROPY_BUFFERS != '5'):
        	CMD_LINE_ARGS.append('-e')
        	CMD_LINE_ARGS.append(INTERNAL_ENTROPY_BUFFERS)
        if(SHOW_FPS == 1):
        	CMD_LINE_ARGS.append('-f')
        if(AUDIO_SINK == 'pulsesink'):
        	CMD_LINE_ARGS.append('--use-pulsesink')
        elif(AUDIO_SINK == 'alsasink'):
        	CMD_LINE_ARGS.append('--use-alsasink')
        CMD_LINE_ARGS = " ".join(CMD_LINE_ARGS)
        print("sh common_vcu_demo_streamin_decode_display.sh", CMD_LINE_ARGS)
        return CMD_LINE_ARGS

class common_vcu_demo_transcode_to_file:
    def cmd_line_args_generator(INPUT_FILE_PATH, BIT_RATE, CODEC_TYPE, AUDIO_CODEC, OUTPUT_PATH, INTERNAL_ENTROPY_BUFFERS, GOP_LENGTH, PERIODICITY_IDR, SHOW_FPS):
        CMD_LINE_ARGS = []
        if(len(INPUT_FILE_PATH) != 0):
        	CMD_LINE_ARGS.append('-i')
        	CMD_LINE_ARGS.append(INPUT_FILE_PATH)
        if(len(BIT_RATE) != 0):
        	CMD_LINE_ARGS.append('-b')
        	CMD_LINE_ARGS.append(BIT_RATE)
        if(len(CODEC_TYPE) != 0):
        	CMD_LINE_ARGS.append('-c')
        	CMD_LINE_ARGS.append(CODEC_TYPE)
        if(AUDIO_CODEC != 'none'):
        	CMD_LINE_ARGS.append('-a')
        	CMD_LINE_ARGS.append(AUDIO_CODEC)
        if(len(OUTPUT_PATH) != 0):
        	CMD_LINE_ARGS.append('-o')
        	CMD_LINE_ARGS.append(OUTPUT_PATH)
        if(INTERNAL_ENTROPY_BUFFERS != '5'):
        	CMD_LINE_ARGS.append('-e')
        	CMD_LINE_ARGS.append(INTERNAL_ENTROPY_BUFFERS)
        if(len(GOP_LENGTH) != 0):
        	CMD_LINE_ARGS.append('--gop-length')
        	CMD_LINE_ARGS.append(GOP_LENGTH)
        if(len(PERIODICITY_IDR) != 0):
        	CMD_LINE_ARGS.append('--periodicity-idr')
        	CMD_LINE_ARGS.append(PERIODICITY_IDR)
        if(SHOW_FPS == 1):
        	CMD_LINE_ARGS.append('-f')
        CMD_LINE_ARGS = " ".join(CMD_LINE_ARGS)
        print("sh common_vcu_demo_transcode_to_file.sh", CMD_LINE_ARGS)
        return CMD_LINE_ARGS

class common_vcu_demo_transcode_to_streamout:
    def cmd_line_args_generator(INPUT_FILE_PATH, BIT_RATE, CODEC_TYPE, ADDRESS_PATH, PORT_NUMBER, INTERNAL_ENTROPY_BUFFERS, GOP_LENGTH, PERIODICITY_IDR, CPB_SIZE):
        CMD_LINE_ARGS = []
        if(len(INPUT_FILE_PATH) != 0):
        	CMD_LINE_ARGS.append('-i')
        	CMD_LINE_ARGS.append(INPUT_FILE_PATH)
        if(len(BIT_RATE) != 0):
        	CMD_LINE_ARGS.append('-b')
        	CMD_LINE_ARGS.append(BIT_RATE)
        if(len(CODEC_TYPE) != 0):
        	CMD_LINE_ARGS.append('-c')
        	CMD_LINE_ARGS.append(CODEC_TYPE)
        if(len(ADDRESS_PATH) != 0):
        	CMD_LINE_ARGS.append('-a')
        	CMD_LINE_ARGS.append(ADDRESS_PATH)
        if(len(PORT_NUMBER) != 0):
        	CMD_LINE_ARGS.append('-p')
        	CMD_LINE_ARGS.append(PORT_NUMBER)
        if(INTERNAL_ENTROPY_BUFFERS != '5'):
        	CMD_LINE_ARGS.append('-e')
        	CMD_LINE_ARGS.append(INTERNAL_ENTROPY_BUFFERS)
        if(len(GOP_LENGTH) != 0):
        	CMD_LINE_ARGS.append('--gop-length')
        	CMD_LINE_ARGS.append(GOP_LENGTH)
        if(len(PERIODICITY_IDR) != 0):
        	CMD_LINE_ARGS.append('--periodicity-idr')
        	CMD_LINE_ARGS.append(PERIODICITY_IDR)
        if(len(CPB_SIZE) != 0):
        	CMD_LINE_ARGS.append('--cpb-size')
        	CMD_LINE_ARGS.append(CPB_SIZE)
        CMD_LINE_ARGS = " ".join(CMD_LINE_ARGS)
        print("sh common_vcu_demo_transcode_to_streamout.sh", CMD_LINE_ARGS)
        return CMD_LINE_ARGS

class common_vcu_demo_videotestsrc_hdr_to_file:
    def cmd_line_args_generator(VIDEO_SIZE, CODEC_TYPE, OUTPUT_PATH, NO_OF_FRAMES, BIT_RATE, FRAME_RATE, GOP_LENGTH, PERIODICITY_IDR, COLOR_FORMAT, RED_X, RED_Y, GREEN_X, GREEN_Y, BLUE_X, BLUE_Y, WHITE_X, WHITE_Y, MAX_DISPLAY_LUMINANCE, MIN_DISPLAY_LUMINANE, MAX_CLL, MAX_FALL, SHOW_FPS):
        CMD_LINE_ARGS = []
        if(len(VIDEO_SIZE) != 0):
        	CMD_LINE_ARGS.append('-s')
        	CMD_LINE_ARGS.append(VIDEO_SIZE)
        if(len(CODEC_TYPE) != 0):
        	CMD_LINE_ARGS.append('-c')
        	CMD_LINE_ARGS.append(CODEC_TYPE)
        if(len(OUTPUT_PATH) != 0):
        	CMD_LINE_ARGS.append('-o')
        	CMD_LINE_ARGS.append(OUTPUT_PATH)
        if(len(NO_OF_FRAMES) != 0):
        	CMD_LINE_ARGS.append('-n')
        	CMD_LINE_ARGS.append(NO_OF_FRAMES)
        if(len(BIT_RATE) != 0):
        	CMD_LINE_ARGS.append('-b')
        	CMD_LINE_ARGS.append(BIT_RATE)
        if(len(FRAME_RATE) != 0):
        	CMD_LINE_ARGS.append('-r')
        	CMD_LINE_ARGS.append(FRAME_RATE)
        if(len(GOP_LENGTH) != 0):
        	CMD_LINE_ARGS.append('--gop-length')
        	CMD_LINE_ARGS.append(GOP_LENGTH)
        if(len(PERIODICITY_IDR) != 0):
        	CMD_LINE_ARGS.append('--periodicity-idr')
        	CMD_LINE_ARGS.append(PERIODICITY_IDR)
        if(len(COLOR_FORMAT) != 0):
        	CMD_LINE_ARGS.append('--color-format')
        	CMD_LINE_ARGS.append(COLOR_FORMAT)
        if(len(RED_X) != 0) and (len(RED_Y) != 0) and (len(GREEN_X) != 0) and (len(GREEN_Y) != 0) and (len(BLUE_X) != 0) and (len(BLUE_Y) != 0):
        	CMD_LINE_ARGS.append('--display-primaries')
        	CMD_LINE_ARGS.append((RED_X + ':' + RED_Y + ':' + GREEN_X + ':' + GREEN_Y + ':' + BLUE_X + ':' + BLUE_Y))
        if(len(WHITE_X) != 0) and (len(WHITE_Y) != 0):
        	CMD_LINE_ARGS.append('--white-point')
        	CMD_LINE_ARGS.append(WHITE_X + ':' + WHITE_Y)
        if(len(MAX_DISPLAY_LUMINANCE) != 0) and (len(MIN_DISPLAY_LUMINANE) != 0):
        	CMD_LINE_ARGS.append('--display-luminance')
        	CMD_LINE_ARGS.append(MAX_DISPLAY_LUMINANCE + ':' + MIN_DISPLAY_LUMINANE)
        if(len(MAX_CLL) != 0):
        	CMD_LINE_ARGS.append('--max-cll')
        	CMD_LINE_ARGS.append(MAX_CLL)
        if(len(MAX_FALL) != 0):
        	CMD_LINE_ARGS.append('--max-fall')
        	CMD_LINE_ARGS.append(MAX_FALL)
        if(SHOW_FPS == 1):
        	CMD_LINE_ARGS.append('-f')
        CMD_LINE_ARGS = " ".join(CMD_LINE_ARGS)
        print("sh common_vcu_demo_videotestsrc_hdr_to_file.sh", CMD_LINE_ARGS)
        return CMD_LINE_ARGS
