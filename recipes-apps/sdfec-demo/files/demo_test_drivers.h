// #############################################################################
//
//  Copyright (C) 2018 Xilinx, Inc.  All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  Use of the Software is limited solely to applications:
//  (a) running on a Xilinx device, or
//  (b) that interact with a Xilinx device through a bus or interconnect.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
//  OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Except as contained in this notice, the name of the Xilinx shall not be used
//  in advertising or otherwise to promote the sale, use or other dealings in
//  this Software without prior written authorization from Xilinx.
//
// #############################################################################


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

#include "xdata_source_top.h"
#include "xstats_top.h"
#include "xmonitor.h"

/*************************** Constant Definitions *****************************/

/* Constants used to validate user input */
#define NUM_LDPC_CODES			(3UL)
#define MIN_SNR_VALUE			(-12.0)
#define MAX_SNR_VALUE			(16.0)
#define SMALLEST_MAX_ITER_VALUE		(1UL)
#define LARGEST_MAX_ITER_VALUE		(63UL)
#define MAX_MOD_TYPE_VALUE		(3UL)
/* the following are used to validate Boolean values, i.e. for the following 
   user inputs:
    - term_on_pass
    - zero_data
    - skip_chan
 */
#define USER_BOOLEAN_TRUE           (1UL)
#define USER_BOOLEAN_FALSE          (0UL)


/* Constants used to access devices other than the sd-fec */
#define BUS_NAME             "platform"
#define DATA_DEV_NAME        "a0000000.data_source_top"
#define STATS_DEV_NAME       "a0030000.stats_top"
#define ENC_IP_MON_DEV_NAME  "a0010000.monitor"
#define ENC_OP_MON_DEV_NAME  "a0020000.monitor"
#define DEC_IP_MON_DEV_NAME  "a00d0000.monitor"
#define DEC_OP_MON_DEV_NAME  "a00e0000.monitor"
#define GPIO_RESET_ID        "499"
#define GPIO_LED0_ID         "507"
#define GPIO_LED1_ID         "508"

/*************************** Type Definitions *********************************/
// Parameter struct
struct demo_params_t {
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
struct demo_stats_t {
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

struct demo_monitors_t {
	XMonitor enc_ip;
	XMonitor enc_op;
	XMonitor dec_ip;
	XMonitor dec_op;
};



/*************************** Function Prototypes ******************************/
int demo_data_source_initialize(XData_source_top* data_source_top);

u64 demo_data_source_calc_keep(unsigned int packet_size,
			       unsigned int per_trans,
			       bool is_bits);

void demo_data_source_set_fec_type(XData_source_top* data_source_top);

void demo_data_source_setup(XData_source_top* data_source_top,
			    struct demo_params_t* params,
			    unsigned int k,
			    unsigned int n);

void demo_data_source_start(XData_source_top* data_source_top);

void demo_data_source_release(XData_source_top* data_source_top);

int demo_monitors_initialize(struct demo_monitors_t* mons);

void demo_monitors_setup(struct demo_monitors_t* mons,
			 struct demo_params_t* params);

void demo_monitors_start(struct demo_monitors_t* mons);

void demo_monitors_release(struct demo_monitors_t* mons);

int demo_stats_initialize(XStats_top* stats_top);

XStats_top_Mask_v demo_stats_calc_mask(unsigned int k);

void demo_stats_setup(XStats_top* stats_top,
		 struct demo_params_t* params,
		 unsigned int k,
		 unsigned int n);

void demo_stats_start(XStats_top* stats_top);

u32 demo_stats_is_idle(XStats_top* stats_top);

void demo_stats_collect(XStats_top* stats_top,
			struct demo_monitors_t* mons,
			struct demo_stats_t* stats);

void demo_stats_release(XStats_top* stats_top);

void demo_params_print(struct demo_params_t* params);

int demo_params_get(struct demo_params_t* params);

int demo_params_changed(struct demo_params_t* params,
			struct demo_params_t* prev_params);

void demo_stats_print(struct demo_stats_t* stats);

void demo_gpio_initialize(char* gpioid);

void demo_gpio_release(char* gpioid);

void demo_gpio_reset(char* gpioid);

void demo_gpio_write_value(char* gpioid, char* val);
