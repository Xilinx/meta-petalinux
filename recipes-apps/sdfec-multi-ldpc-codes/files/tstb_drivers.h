/*******************************************************************************
 *
 * Copyright (C) 2018 Xilinx, Inc.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Use of the Software is limited solely to applications:
 * (a) running on a Xilinx device, or
 * (b) that interact with a Xilinx device through a bus or interconnect.
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
#ifndef _TSTB_DRIVERS_H_
#define _TSTB_DRIVERS_H_

/****************************** Include Files *********************************/
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <linux/input.h>
#include <ctype.h>
#include <poll.h>

#include "usr_params.h"
#include "xdata_source_top.h"
#include "xstats_top.h"
#include "xmonitor.h"

/*************************** Constant Definitions *****************************/
/* Constants used to access devices other than the sd-fec */
#define NUM_LDPC_CODES		(3UL)
#define BUS_NAME		"platform"
#define DATA_DEV_NAME		"a0000000.data_source_top"
#define STATS_DEV_NAME		"a0030000.stats_top"
#define ENC_IP_MON_DEV_NAME	"a0010000.monitor"
#define ENC_OP_MON_DEV_NAME	"a0020000.monitor"
#define DEC_IP_MON_DEV_NAME	"a00d0000.monitor"
#define DEC_OP_MON_DEV_NAME	"a00e0000.monitor"
#define GPIO_RESET_ID		"499"
#define GPIO_LED0_ID		"507"
#define GPIO_LED1_ID		"508"

/*************************** Type Definitions *********************************/
/* Parameter struct */
struct tstb_params_t {
	unsigned int code;
	unsigned int num_blocks;
	double       snr;
	unsigned int max_iter;
	unsigned int term_on_pass;
	unsigned int mod_type;
	unsigned int zero_data;
	unsigned int skip_chan;
};

//Stats struct
struct tstb_stats_t {
	u32 raw_berr;
	u32 raw_blerr;
	u32 cor_berr;
	u32 cor_blerr;
	u32 iter_cnt;
	u32 block_cnt;
	u32 enc_ip_first;
	u32 enc_ip_last;
	u32 enc_ip_stalled;
	u32 enc_op_first;
	u32 enc_op_last;
	u32 enc_op_stalled;
	u32 dec_ip_first;
	u32 dec_ip_last;
	u32 dec_ip_stalled;
	u32 dec_op_first;
	u32 dec_op_last;
	u32 dec_op_stalled;
};

struct tstb_monitors_t {
	XMonitor enc_ip;
	XMonitor enc_op;
	XMonitor dec_ip;
	XMonitor dec_op;
};

/*************************** Function Prototypes ******************************/
int tstb_data_source_initialize(XData_source_top* data_source_top);

u64 tstb_data_source_calc_keep(unsigned int packet_size,
			       unsigned int per_trans,
			       bool is_bits);

void tstb_data_source_set_fec_type(XData_source_top* data_source_top);

void tstb_data_source_setup(XData_source_top* data_source_top,
			    struct tstb_params_t* params,
			    unsigned int k,
			    unsigned int n,
			    unsigned int enc_code,
			    unsigned int dec_code);

void tstb_data_source_start(XData_source_top* data_source_top);

void tstb_data_source_release(XData_source_top* data_source_top);

int tstb_monitors_initialize(struct tstb_monitors_t* mons);

void tstb_monitors_setup(struct tstb_monitors_t* mons,
			 struct tstb_params_t* params);

void tstb_monitors_start(struct tstb_monitors_t* mons);

void tstb_monitors_release(struct tstb_monitors_t* mons);

int tstb_stats_initialize(XStats_top* stats_top);

XStats_top_Mask_v tstb_stats_calc_mask(unsigned int k);

void tstb_stats_setup(XStats_top* stats_top,
		 struct tstb_params_t* params,
		 unsigned int k,
		 unsigned int n);

void tstb_stats_start(XStats_top* stats_top);

u32 tstb_stats_is_idle(XStats_top* stats_top);

void tstb_stats_collect(XStats_top* stats_top,
			struct tstb_monitors_t* mons,
			struct tstb_stats_t* stats);

void tstb_stats_print(struct tstb_stats_t* stats);

void tstb_stats_release(XStats_top* stats_top);

int tstb_gpio_initialize(char* gpioid);

void tstb_gpio_release(char* gpioid);

void tstb_gpio_reset(char* gpioid);

void tstb_gpio_write_value(char* gpioid, char* val);

int load_ldpc_code(int fd,
		   user_params* code,
		   struct xsdfec_user_ldpc_table_offsets* user_offsets,
		   struct xsdfec_ldpc_params* ldpc_params,
		   unsigned int code_id,
		   char* dev);

void trigger_interrupt(user_params* dec_code,
		       struct tstb_params_t* params,
		       XData_source_top* data_source_top);

void poll_event(int fd);

#endif
