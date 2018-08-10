/*******************************************************************************
 *
 * Copyright (C) 2016 - 2017 Xilinx, Inc. All rights reserved.
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
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * XILINX CONSORTIUM BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
 * OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 *
 * Except as contained in this notice, the name of the Xilinx shall not be used
 * in advertising or otherwise to promote the sale, use or other dealings in
 * this Software without prior written authorization from Xilinx.
 *
 * Author:	Peter Ryser <peter.ryser@xilinx.com>
 *
 * ******************************************************************************/

#include "mraa.h"
#include <stdio.h>
#include <unistd.h>
#include <string.h>

static void power_button_pushed(void *);
static void usage(char *);

static char command[256]={0};
const char *lcd_display= "python /sbin/groove-rgb-lcd.py";

static void usage(char *cmd)
{
	printf("Usage: %s pin commmand\n", cmd);
	printf("  %s executes the specified command\n"
		"  when the power button (pin) on the ZZSoC board is pushed.\n", cmd);
}

static void power_button_pushed(void *dummy)
{

	printf("Power button pressed. Powering down...\n");
	(void) system(lcd_display);
	(void) system(command);
}

int main(int argc, char *argv[])
{
       int pin;

	if(argc != 3 ) {
		usage(argv[0]);
		exit(1);
	}

	strncpy(command, argv[2], sizeof(command)-1);
	pin = strtol(argv[1], NULL, 10);

	mraa_init();
	mraa_gpio_context pwr_button = mraa_gpio_init_raw(pin);
	mraa_gpio_dir(pwr_button, MRAA_GPIO_IN);
	mraa_gpio_isr(pwr_button, MRAA_GPIO_EDGE_FALLING,
			&power_button_pushed,NULL);
	for (;;) {
		pause();};
	return MRAA_SUCCESS;
}
