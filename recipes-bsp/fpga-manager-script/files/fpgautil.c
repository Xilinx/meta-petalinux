/******************************************************************************
 *
 * Copyright (C) 2018 Xilinx, Inc.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
 * OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 * Except as contained in this notice, the name of the Xilinx shall not be used
 * in advertising or otherwise to promote the sale, use or other dealings in
 * this Software without prior written authorization from Xilinx.
 *
 ******************************************************************************/
/*****************************************************************************/
/**
 * @file: fpgautil.c
 * Simple command line tool to load fpga via overlay or through sysfs interface
 * and read fpga configuration using Xilinx zynqMP fpga manager
 * Author: Appana Durga Kedareswara Rao <appanad@xilinx.com>
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <string.h>
#include <signal.h>
#include <getopt.h>
#include <poll.h>
#include <ctype.h>
#include <libgen.h>
#include <time.h>
#include <errno.h>
#include <sys/time.h>
#include <sys/stat.h>

#define OVERLAY      1
#define FPGA_SYSFS   2
#define READBACK     3
#define ENCRYPTION_USERKEY_EN     (0x00000008U)

void print_usage(char *prg)
{
	fprintf(stderr, "\n%s: FPGA Utility for Loading/reading PL Configuration in zynqMP\n\n", prg);
	fprintf(stderr, "Usage:	%s -b <bin file path> -o <dtbo file path>\n\r", prg);
	fprintf(stderr, "\n");
	fprintf(stderr, "Options: -b <binfile>		(Bin file path)\n");
	fprintf(stderr, "         -o <dtbofile>		(DTBO file path)\n");
	fprintf(stderr, "         -f <flags>		Optional: <Bitstream type flags>\n");
	fprintf(stderr, "				   f := <Full | Partial > \n");
	fprintf(stderr, "				Default: <Full>\n");
	fprintf(stderr, "	  -s <secure flags>	Optional: <Secure flags>\n");
	fprintf(stderr, "				   s := <AuthDDR | AuthOCM | EnUsrKey | EnDevKey | AuthEnUsrKeyDDR | AuthEnUsrKeyOCM | AuthEnDevKeyDDR | AuthEnDevKeyOCM>\n");
	fprintf(stderr, "	  -k <AesKey>		Optional: <AES User Key>\n");
	fprintf(stderr, "	  -r <Readback> 	Optional: <file name>\n");
	fprintf(stderr, "				Default: By default Read back contents will be stored in readback.bin file\n");
	fprintf(stderr, "	  -t			Optional: <Readback Type>\n");
	fprintf(stderr, "				   0 - Configuration Register readback\n");
	fprintf(stderr, "				   1 - Configuration Data Frames readback\n");
	fprintf(stderr, "				Default: 0 (Configuration register readback)\n");
	fprintf(stderr, "	  -R 			Optional: Remove overlay from a live tree\n");
	fprintf(stderr, " \n");
	fprintf(stderr, "Examples:\n");
	fprintf(stderr, "(Load Full bitstream using Overlay)\n");
	fprintf(stderr, "%s -b top.bit.bin -o can.dtbo\n", prg);
	fprintf(stderr, "(Load Partial bitstream through the sysfs interface)\n");
	fprintf(stderr, "%s -b top.bit.bin -f Partial \n", prg);
	fprintf(stderr, "(Load Authenticated bitstream through the sysfs interface)\n");
	fprintf(stderr, "%s -b top.bit.bin -f Full -s AuthDDR \n", prg);
	fprintf(stderr, "(Load Parital Encrypted Userkey bitstream using Overlay)\n");
	fprintf(stderr, "%s -b top.bit.bin -o pl.dtbo -f Partial -s EnUsrKey -k <32byte key value>\n", prg);
	fprintf(stderr, "(Read PL Configuration Registers)\n");
	fprintf(stderr, "%s -b top.bit.bin -r\n", prg);
	fprintf(stderr, " \n");
}

int gettime(struct timeval  t0, struct timeval t1)
{
        return ((t1.tv_sec - t0.tv_sec) * 1000.0f + (t1.tv_usec -t0.tv_usec) / 1000.0f);
}

int fpga_state(int flow)
{
	FILE *fptr;
	char buf[10], *state;
	
	if (flow == OVERLAY) {
		system("cat /configfs/device-tree/overlays/full/status  >> state.txt");
		state = "applied";
	} else {
		system("cat /sys/class/fpga_manager/fpga0/state >> state.txt");
		state = "operating";
	}
	fptr = fopen("state.txt", "r");
	if (fptr) {
		if (flow == OVERLAY)
			fgets(buf, 8, fptr);
		else
			fgets(buf, 10, fptr);
		fclose(fptr);
		system("rm state.txt");
		if (strcmp(buf, state) == 0)
			return 0;
		else
			return 1;
	}
	
	return 1;
}

struct zynqmp_fpgaflag {
        char *flag;
        unsigned int value;
};

static struct zynqmp_fpgaflag flagdump[] = {
        {.flag = "Full",		.value = 0x0},
        {.flag = "Partial",		.value = 0x1},
        {.flag = "AuthDDR",		.value = 0x2},
        {.flag = "AuthOCM",		.value = 0x4},
        {.flag = "EnUsrKey",		.value = 0x8},
        {.flag = "EnDevKey",		.value = 0x10},
        {.flag = "AuthEnUsrKeyDDR",	.value = 0xA},
        {.flag = "AuthEnUsrKeyOCM",	.value = 0xC},
        {.flag = "AuthEnDevKeyDDR",	.value = 0x12},
        {.flag = "AuthEnDevKeyOCM",	.value = 0x14},
        {}
};

static int cmd_flags(int argc, const char *name)
{
	int valid_flag = 0;
	int flag = 0;
	struct zynqmp_fpgaflag *p = flagdump;

	while (p->flag) {
		if (!strcmp(name, p->flag)) {
			flag = p->value;
			break;
		}
		p++;
	}

	return flag;
}

int main(int argc, char **argv)
{
	int ret;
	char *binfile = NULL, *overlay = NULL, *AesKey = NULL, *flag = NULL, *partial_overlay = NULL;
	char *Module[100] = {0};
	int opt, flags = 0, flow = 0,rm_overlay = 0, readback_type = 0, sflags = 0;
	char command[2048], *token, *tmp, *tmp1, *tmp2 , *tmp3;
	const char *folder, *filename = "readback", *name;
	struct stat sb;
	double time;
        struct timeval t1, t0;

	if (argc == 1) {
		print_usage(basename(argv[0]));
		return 1;
	}

	while ((opt = getopt(argc, argv, "o:b:f:s:p:k:rt::Rh?:")) != -1) {
		switch (opt) {
		case 'o':
			overlay = optarg;
			flow = OVERLAY;
			break;
		case 'b':
			binfile = optarg;
			if (!(flow == OVERLAY))
				flow = FPGA_SYSFS;
			break;
		case 'f':
			if (flow == OVERLAY) {
				name = argv[6];
				flags = cmd_flags(argc, name);
			} else if (flow == FPGA_SYSFS) {
				name = argv[4];
				flags = cmd_flags(argc, name);
			}
			flags += sflags;
			printf("Flags : 0x%x\r\n", flags);
			break;
		case 's':
			if (flow == OVERLAY) {
				name = argv[8];
				sflags = cmd_flags(argc, name);
			} else if (flow == FPGA_SYSFS) {
				name = argv[6];
				sflags = cmd_flags(argc, name);
			}
			flags += sflags;
			printf("Flags : 0x%x\r\n", flags);
			break;
		case 'p':
			partial_overlay = optarg;	
		case 'k':
			AesKey = optarg;
			break;	 
		case 't':
			if (optarg == NULL && argv[4] != NULL)
				readback_type = atoi(argv[4]);
			break;
		case 'r':
			if (optarg == NULL && argv[2] != NULL)
				filename = argv[2];
			flow = READBACK;
			break;
		case 'R':
			rm_overlay = 1;
			break;
		case '?':
		case 'h':
		default:
			print_usage(basename(argv[0]));
			return 1;
			break;
		}
	}

	system("mkdir -p /lib/firmware");

	if (rm_overlay) {
		folder = "/configfs/device-tree/overlays/full";
		if (((stat(folder, &sb) == 0) && S_ISDIR(sb.st_mode))) {
			system("rmdir /configfs/device-tree/overlays/full");
		}
		return 0;
	}

	if (flow == OVERLAY) {
		if (argc < 5) {
			printf("\n\r");
			printf("%s: For more information run %s -h\n", strerror(22), basename(argv[0]));
			return 1;
		}
		
		folder = "/configfs/device-tree/";
		if (((stat(folder, &sb) == 0) && S_ISDIR(sb.st_mode))) {
		} else {
			system("mkdir /configfs");
			system("mount -t configfs configfs /configfs");
		}
		snprintf(command, sizeof(command), "cp %s /lib/firmware", binfile);
		system(command);
		snprintf(command, sizeof(command), "cp %s /lib/firmware", overlay);
		system(command);
		tmp = strdup(overlay);
		while((token = strsep(&tmp, "/"))) {
			tmp1 = token;
		}
		snprintf(command, sizeof(command), "echo %x > /sys/class/fpga_manager/fpga0/flags", flags);
		system(command);
		if (ENCRYPTION_USERKEY_EN & flags) {
			snprintf(command, sizeof(command), "echo %s > /sys/class/fpga_manager/fpga0/key", AesKey);
                	system(command);
		}

		if (!(flags & 1)) {
			system("cd /configfs/device-tree/overlays/ && mkdir full");
			snprintf(command, sizeof(command), "echo -n %s > /configfs/device-tree/overlays/full/path", tmp1);
			gettimeofday(&t0, NULL);
			system(command);
			if (partial_overlay) {
				snprintf(command, sizeof(command), "cp %s /lib/firmware", partial_overlay);
				system(command);
				tmp2 = strdup(partial_overlay);
				while((token = strsep(&tmp2, "/"))) {
					tmp3 = token;
				}
				system("cd /configfs/device-tree/overlays/ && mkdir full1");
				snprintf(command, sizeof(command), "echo -n %s > /configfs/device-tree/overlays/full1/path", tmp3);
				system(command);
			}
		} else {
			system("cd /configfs/device-tree/overlays/ && mkdir full1");
			snprintf(command, sizeof(command), "echo -n %s > /configfs/device-tree/overlays/full1/path", tmp1);
			gettimeofday(&t0, NULL);
			system(command);
		}
		gettimeofday(&t1, NULL);
		time = gettime(t0, t1);
		if (!fpga_state(OVERLAY)) {
			printf("Time taken to load DTBO is %f Milli Seconds\n\r", time);
			printf("DTBO loaded through zynqMP FPGA manager successfully\n\r");
		} else {
			printf("DTBO loading through zynqMP FPGA manager failed\n\r");
		}

		/* Delete Bin file and DTBO file*/
		snprintf(command, sizeof(command), "rm /lib/firmware/%s", tmp1);
		system(command);
		tmp = strdup(binfile);
		while((token = strsep(&tmp, "/"))) {
			tmp1 = token;
		}
		snprintf(command, sizeof(command), "rm /lib/firmware/%s", tmp1);
		system(command);
	} else if (flow == FPGA_SYSFS) {
		if (argc < 3) {
			printf("%s: For more information run %s -h\n", strerror(22), basename(argv[0]));
			return 1;
		}
		snprintf(command, sizeof(command), "cp %s /lib/firmware", binfile);
		system(command);
		snprintf(command, sizeof(command), "echo %x > /sys/class/fpga_manager/fpga0/flags", flags);
		system(command);
	        if (ENCRYPTION_USERKEY_EN & flags) {
                        snprintf(command, sizeof(command), "echo %s > /sys/class/fpga_manager/fpga0/key", AesKey);
                        system(command);
                }	
		tmp = strdup(binfile);
		while((token = strsep(&tmp, "/"))) {
			tmp1 = token;
		}
		snprintf(command, sizeof(command), "echo %s > /sys/class/fpga_manager/fpga0/firmware", tmp1);
		gettimeofday(&t0, NULL);
		system(command);
		gettimeofday(&t1, NULL);
		time = gettime(t0, t1);
		if (!fpga_state(FPGA_SYSFS)) {
			printf("Time taken to load BIN is %f Milli Seconds\n\r", time);
			printf("BIN FILE loaded through zynqMP FPGA manager successfully\n\r");
		} else {
			printf("BIN FILE loading through zynqMP FPGA manager failed\n\r");
		}
		snprintf(command, sizeof(command), "rm /lib/firmware/%s", tmp1);
		system(command);
	} else if (flow == READBACK) {
		if (readback_type > 1) {
			printf("Invalid arugments :%s\n", strerror(1));
			printf("For more information run %s -h\n", basename(argv[0]));
			return -EINVAL;	
		}
		snprintf(command, sizeof(command), "echo %x > /sys/module/zynqmp_fpga/parameters/readback_type", readback_type);
		system(command);
		snprintf(command, sizeof(command), "cat /sys/kernel/debug/fpga/fpga0/image >> %s.bin", filename);
		system(command);
		printf("Readback contents are stored in the file %s.bin\n\r", filename);
	}

	return 0;
}
