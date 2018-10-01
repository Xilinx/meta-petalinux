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
#include <ctype.h>
#include "demo_test_drivers.h"

/************************** Function Implementation ***************************/

// Helper function to determine tkeep for various data streams in the example
// design
//      o Determined in S/W to simplify H/W
//      o tkeep indicates bytes
int  demo_data_source_initialize(XData_source_top* data_source_top)
{
	return XData_source_top_Initialize(data_source_top, BUS_NAME, DATA_DEV_NAME);
}

u64 demo_data_source_calc_keep(unsigned int packet_size,
			       unsigned int per_trans,
			       bool is_bits)
{
	unsigned int rem = packet_size % per_trans;

	if (is_bits)
		rem = (rem + 7) / 8;
	// If no remainder keep all on last transaction
	if (rem == 0)
		return 0xFFFFFFFF; // Max
	else
		return ((u64)1 << rem) - 1;
}

void demo_data_source_set_fec_type(XData_source_top* data_source_top)
{
	XData_source_top_Set_fec_type_V(data_source_top, 0); // LDPC = 0
}

void demo_data_source_setup(XData_source_top* data_source_top,
			    struct demo_params_t* params,
			    unsigned int k,
			    unsigned int n)
{
	int factorial_10bit;
	int factorial_11bit;
	u64 word = 0;
	int chan_symbls;
	int chan_rem;

	XData_source_top_Set_zero_data_V(data_source_top, params->zero_data);
	XData_source_top_Set_mod_type_V(data_source_top, params->mod_type);
	XData_source_top_Set_skip_chan_V(data_source_top, params->skip_chan);

	factorial_10bit = (int)params->snr*2048;
	factorial_11bit = (int)powf(10.0, (params->snr*0.1))*1024;
	XData_source_top_Set_snr_V(data_source_top, factorial_10bit);
	XData_source_top_Set_inv_sigma_sq_V(data_source_top, factorial_11bit);


	word += 0 << 0; // Code
	word += 1 << 14; // Hard output
	XData_source_top_Set_enc_ctrl_word_V(data_source_top, word);
	word = 0;
	word += 0 << 0; // Code
	word += 1 << 14; // Hard output
	word += params->term_on_pass << 16; // Term on pass
	word += params->max_iter << 18; // Max iter
	XData_source_top_Set_dec_ctrl_word_V(data_source_top, word);
	XData_source_top_Set_num_blocks_V(data_source_top, params->num_blocks);
	XData_source_top_Set_source_words_V(data_source_top, (int)(k+127)/128);
	XData_source_top_Set_source_keep_V(data_source_top, (u32)demo_data_source_calc_keep(k, 128, true));
	XData_source_top_Set_enc_keep_V(data_source_top, demo_data_source_calc_keep(n, 96, true));
	XData_source_top_Set_dec_keep_V(data_source_top, demo_data_source_calc_keep(k, 128, true));

	switch (params->mod_type) {
		case 0: {
			chan_symbls = (n+3)/4; // 1 (BPSK) symbol x 4
			chan_rem    = n % 4;
			break;
		}
		case 1: {
			chan_symbls = (n+7)/8; // 2 (QPSK/QAM4) symbols x 4
			chan_rem    = n % 8;
			break;
		}
		case 2: {
			chan_symbls = (n+11)/12; // 4 (QAM16) symbols x 3
			chan_rem    = n % 12;
			break;
		}
		case 3: {
			chan_symbls = (n+23)/24; // 6 (QAM64) symbols x 4
			chan_rem    = n % 24;
			break;
		}
		default: {
			chan_symbls = (n+3)/4; // 1 (BPSK) symbol x 4
			chan_rem    = n % 4;
			break;
		}
	}

	XData_source_top_Set_chan_symbls_V(data_source_top, chan_symbls);
	XData_source_top_Set_chan_rem_V(data_source_top, chan_rem);
}

void demo_data_source_start(XData_source_top* data_source_top)
{
    XData_source_top_Start(data_source_top);
}

void demo_data_source_release(XData_source_top* data_source_top)
{
	XData_source_top_Release(data_source_top);
}

int demo_monitors_initialize(struct demo_monitors_t* mons)
{
	int ret_val = 0;
	if (ret_val == 0) {
		ret_val = XMonitor_Initialize(&(mons->enc_ip),
		                              BUS_NAME,
		                              ENC_IP_MON_DEV_NAME);
	}
	if (ret_val == 0) {
		ret_val = XMonitor_Initialize(&(mons->enc_op),
		                              BUS_NAME,
		                              ENC_OP_MON_DEV_NAME);
	}
	if (ret_val == 0) {
		ret_val = XMonitor_Initialize(&(mons->dec_ip),
		                              BUS_NAME,
		                              DEC_IP_MON_DEV_NAME);
	}

	if (ret_val == 0) {
		ret_val = XMonitor_Initialize(&(mons->dec_op),
		                              BUS_NAME,
		                              DEC_OP_MON_DEV_NAME);
	}

	return ret_val;
}

void demo_monitors_setup(struct demo_monitors_t* mons,
			 struct demo_params_t* params)
{
	XMonitor_Set_num_blocks_V(&(mons->enc_ip), params->num_blocks);
	XMonitor_Set_num_blocks_V(&(mons->enc_op), params->num_blocks);
	XMonitor_Set_num_blocks_V(&(mons->dec_ip), params->num_blocks);
	XMonitor_Set_num_blocks_V(&(mons->dec_op), params->num_blocks);
}

void demo_monitors_start(struct demo_monitors_t* mons)
{
	XMonitor_Start(&(mons->enc_ip));
	XMonitor_Start(&(mons->enc_op));
	XMonitor_Start(&(mons->dec_ip));
	XMonitor_Start(&(mons->dec_op));
}

void demo_monitors_release(struct demo_monitors_t* mons)
{
	XMonitor_Release(&(mons->dec_op));
	XMonitor_Release(&(mons->dec_ip));
	XMonitor_Release(&(mons->enc_op));
	XMonitor_Release(&(mons->enc_ip));
}

int demo_stats_initialize(XStats_top* stats_top)
{
	return XStats_top_Initialize(stats_top, BUS_NAME, STATS_DEV_NAME);
}

// Helper function to determine the mask for the stats block to apply to the
// last comparison
XStats_top_Mask_v demo_stats_calc_mask(unsigned int k)
{
	int bits = k % 128;
	XStats_top_Mask_v mask;

	if (bits == 0) {
		mask.word_0 = 0xFFFFFFFF;
		mask.word_1 = 0xFFFFFFFF;
		mask.word_2 = 0xFFFFFFFF;
		mask.word_3 = 0xFFFFFFFF;
		return mask;
	}
	if (bits >= 32) {
		mask.word_0 = 0xFFFFFFFF;
		bits -= 32;
	} else {
		mask.word_0 = 0x7FFFFFFF >> (31-bits); // Much faster
		bits = 0;
	}
	if (bits >= 32) {
		mask.word_1 = 0xFFFFFFFF;
		bits -= 32;
	} else {
		mask.word_1 = 0x7FFFFFFF >> (31-bits);
		bits = 0;
	}
	if (bits >= 32) {
		mask.word_2 = 0xFFFFFFFF;
		bits -= 32;
	} else {
		mask.word_2 = 0x7FFFFFFF >> (31-bits);
		bits = 0;
	}
	if (bits >= 32) {
		mask.word_3 = 0xFFFFFFFF;
		bits -= 32;
	} else {
		mask.word_3 = 0x7FFFFFFF >> (31-bits);
		bits = 0;
	}
	return mask;
}

void demo_stats_setup(XStats_top* stats_top,
		 struct demo_params_t* params,
		 unsigned int k,
		 unsigned int n)
{
	XStats_top_Set_num_blocks_V(stats_top, params->num_blocks);
	XStats_top_Set_k_V(stats_top, k);
	XStats_top_Set_n_V(stats_top, n);
	XStats_top_Set_mask_V(stats_top, demo_stats_calc_mask(k));
	XStats_top_Set_src_inc_parity_V(stats_top, 0);
}

void demo_stats_start(XStats_top* stats_top)
{
	XStats_top_Start(stats_top);
}

u32 demo_stats_is_idle(XStats_top* stats_top)
{
	return XStats_top_IsIdle(stats_top);
}

void demo_stats_collect(XStats_top* stats_top,
		   struct demo_monitors_t* mons,
		   struct demo_stats_t* stats)
{
	stats->raw_berr  = XStats_top_Get_raw_berr_V(stats_top);
	stats->raw_blerr = XStats_top_Get_raw_blerr_V(stats_top);
	stats->cor_berr  = XStats_top_Get_cor_berr_V(stats_top);
	stats->cor_blerr = XStats_top_Get_cor_blerr_V(stats_top);
	stats->iter_cnt  = XStats_top_Get_iter_cnt_V(stats_top);
	stats->block_cnt = XStats_top_Get_block_cnt_V(stats_top);

	stats->enc_ip_first   = XMonitor_Get_first_V(&(mons->enc_ip));
	stats->enc_ip_last    = XMonitor_Get_last_V(&(mons->enc_ip));
	stats->enc_ip_stalled = XMonitor_Get_stalled_V(&(mons->enc_ip));
	stats->enc_op_first   = XMonitor_Get_first_V(&(mons->enc_op));
	stats->enc_op_last    = XMonitor_Get_last_V(&(mons->enc_op));
	stats->enc_op_stalled = XMonitor_Get_stalled_V(&(mons->enc_op));
	stats->dec_ip_first   = XMonitor_Get_first_V(&(mons->dec_ip));
	stats->dec_ip_last    = XMonitor_Get_last_V(&(mons->dec_ip));
	stats->dec_ip_stalled = XMonitor_Get_stalled_V(&(mons->dec_ip));
	stats->dec_op_first   = XMonitor_Get_first_V(&(mons->dec_op));
	stats->dec_op_last    = XMonitor_Get_last_V(&(mons->dec_op));
	stats->dec_op_stalled = XMonitor_Get_stalled_V(&(mons->dec_op));
}

void demo_stats_release(XStats_top* stats_top)
{
	XStats_top_Release(stats_top);
}

void demo_params_print(struct demo_params_t* params)
{
	printf("code        : %u\n", params->code);
	printf("num_blocks  : %u\n", params->num_blocks);
	printf("snr         : %f\n", params->snr);
	printf("max_iter    : %u\n", params->max_iter);
	printf("term_on_pass: %u\n", params->term_on_pass);
	printf("mod_type    : %u\n", params->mod_type);
	printf("zero_data   : %u\n", params->zero_data);
	printf("skip_chan   : %u\n", params->skip_chan);
}

static unsigned int ask_user_y(char *msg)
{
	unsigned int ret_val = 0;
	char user_input[16];
	int i = 0;

	printf("%s (y/n):", msg);
	if(fgets(user_input, sizeof(user_input), stdin)) {
		while (1) {
			if (user_input[i] == '\n')
				break;
			user_input[i] = tolower(user_input[i]);

			if (user_input[i] == 'y') {
				ret_val = 1;
				break;
			} else if (user_input[i] == 'n'){
				break;
			} else {
				i++;
			}
		}
	}

	return ret_val;
}

static unsigned int check_user_params(struct demo_params_t* params)
{
	int valid_usr_params = 1;

	if (params->code >= NUM_LDPC_CODES) {
		printf("ERROR: Entered code, %u, is out of range(0 - %u)\n",
			params->code,
			NUM_LDPC_CODES - 1);
		valid_usr_params = 0;
	}

	if ((params->snr < MIN_SNR_VALUE) ||
	    (params->snr > MAX_SNR_VALUE)) {
		printf("ERROR: Entered snr, %f, is out of range(%f - %f)\n",
			params->snr,
			MIN_SNR_VALUE,
			MAX_SNR_VALUE);
		valid_usr_params = 0;
	}

	if ((params->max_iter < SMALLEST_MAX_ITER_VALUE) ||
	    (params->max_iter > LARGEST_MAX_ITER_VALUE)) {
		printf("ERROR: Entered max_iter, %u, is out of range(%u - %u)\n",
			params->max_iter,
			SMALLEST_MAX_ITER_VALUE,
			LARGEST_MAX_ITER_VALUE);
		valid_usr_params = 0;
	}

	if ((params->term_on_pass != USER_BOOLEAN_TRUE) &&
	    (params->term_on_pass != USER_BOOLEAN_FALSE) ) {
		printf("ERROR: Entered term_on_pass, %u, is not Boolean(0 or 1)\n",
			params->term_on_pass);
		valid_usr_params = 0;
	}

	if (params->mod_type > MAX_MOD_TYPE_VALUE) {
		printf("ERROR: Entered mod_type, %u, exceeds the maximun(%u)\n",
			params->mod_type,
			MAX_MOD_TYPE_VALUE);
		valid_usr_params = 0;
	}

	if ((params->zero_data != USER_BOOLEAN_TRUE) &&
	    (params->zero_data != USER_BOOLEAN_FALSE)) {
		printf("ERROR: Entered zero_data, %u, is not Boolean(0 or 1)\n",
			params->zero_data);
		valid_usr_params = 0;
	}

	if ((params->skip_chan != USER_BOOLEAN_TRUE) &&
	    (params->skip_chan != USER_BOOLEAN_FALSE) ) {
		printf("ERROR: Entered skip_chan, %u, is not Boolean(0 or 1)\n",
			params->skip_chan);
		valid_usr_params = 0;
	}

	return valid_usr_params;
}

static int get_user_param(char *param_name, char *param_format, void *param)
{
	char *tmp_ptr;
	int ch;
	char user_input[16];
	int num_params_read;
	printf("%s: ", param_name);
	fgets(user_input, sizeof(user_input), stdin);
	num_params_read = sscanf(user_input, param_format, param);

	tmp_ptr = strchr(user_input, '\n');
	if (!tmp_ptr) {
		while((ch = getchar()) != EOF && ch != '\n');
 	}

 	return num_params_read;
}

int demo_params_get(struct demo_params_t* params)
{
	unsigned int is_yes ;
	struct demo_params_t current_config_params;
	int num_params_read;
	unsigned int valid_params = 1;

	printf("Current config:\n");
	demo_params_print(params);
	is_yes = ask_user_y("New config?");
	if (is_yes == 1) {
		printf("Input new config: \n");

		/* copy in the old so can partialy write a set of values */
		memcpy(&current_config_params,
		       params,
		       sizeof(struct demo_params_t));

		num_params_read = get_user_param("code", "%u",
   						 &(current_config_params.code));
		if (num_params_read == 1) {
   			num_params_read = get_user_param("num_blocks", "%lu",
   							 &(current_config_params.num_blocks));
		}

		if (num_params_read == 1)
			num_params_read = get_user_param("snr", "%lf",
   							 &(current_config_params.snr));

		if (num_params_read == 1)
			num_params_read = get_user_param("max_iter", "%u",
   							 &(current_config_params.max_iter));

		if (num_params_read == 1)
			num_params_read = get_user_param("term_on_pass", "%u",
   							 &(current_config_params.term_on_pass));

		if (num_params_read == 1)
			num_params_read = get_user_param("mod_type", "%u",
   							 &(current_config_params.mod_type));

		if (num_params_read == 1)
			num_params_read = get_user_param("zero_data", "%u",
   							 &(current_config_params.zero_data));

		if (num_params_read == 1)
			num_params_read = get_user_param("skip_chan", "%u",
   							 &(current_config_params.skip_chan));

		valid_params = check_user_params(&current_config_params);
		if (valid_params == 1) {
			memcpy(params,
			       &current_config_params,
			       sizeof(struct demo_params_t));

			printf("Next config:\n");
			demo_params_print(params);
		} else {
			printf("Continuing with previous config...\n");
		}

	}

	return valid_params;
}

int demo_params_changed(struct demo_params_t* params,
			struct demo_params_t* prev_params)
{
	if (params->num_blocks   != prev_params->num_blocks   ||
	    params->code         != prev_params->code         ||
	    params->snr          != prev_params->snr          ||
	    params->mod_type     != prev_params->mod_type     ||
	    params->skip_chan    != prev_params->skip_chan    ||
	    params->term_on_pass != prev_params->term_on_pass ||
	    params->zero_data    != prev_params->zero_data    ||
	    params->max_iter     != prev_params->max_iter) {

		return 1;
	}
	else {
		return 0;
	}
}

void demo_stats_print(struct demo_stats_t* stats)
{
	printf("\n---- RESULTS ----\n");
	printf("\tStats: \n");
	printf("\t\tDecode iteration count = %u\n", stats->iter_cnt);
	printf("\t\tChannel bit error count = %u\n", stats->raw_berr);
	printf("\t\tChannel block error count = %u\n", stats->raw_blerr);
	printf("\t\tUncorrected bit error count after Decode = %u\n",
		stats->cor_berr);
	printf("\t\tUncorrected block error count after Decode = %u\n",
		stats->cor_blerr);
	printf("\tEncoder Monitors:\n");
	printf("\t\tIn Monitor First Timestamp = %u\n", stats->enc_ip_first);
	printf("\t\tIn Monitor Last Timestamp = %u\n", stats->enc_ip_last);
	printf("\t\tIn Monitor Num Stalled Clk Cycles = %u\n",
		stats->enc_ip_stalled);
	printf("\t\tOut Monitor First Timestamp = %u\n", stats->enc_op_first);
	printf("\t\tOut Monitor Last Timestamp =  %u\n", stats->enc_op_last);
	printf("\t\tOut Monitor Num Stalled Clk Cycles = %u\n",
		stats->enc_op_stalled);
	printf("\tDecoder Monitors:\n");
	printf("\t\tIn Monitor First Timestamp = %u\n", stats->dec_ip_first);
	printf("\t\tIn Monitor Last Timestamp = %u\n", stats->dec_ip_last);
	printf("\t\tIn Monitor Num Stalled Clk Cycles = %u\n",
		stats->dec_ip_stalled);
	printf("\t\tOut Monitor First Timestamp = %u\n", stats->dec_op_first);
	printf("\t\tOut Monitor Last Timestamp =  %u\n", stats->dec_op_last);
	printf("\t\tOut Monitor Num Stalled Clk Cycles = %u\n",
		stats->dec_op_stalled);
}

void demo_gpio_initialize(char* gpioid)
{
	int expfd  = -1;
	int dirfd  = -1;
	char gpio_dirpath[50];

	expfd = open("/sys/class/gpio/export", O_WRONLY);
	if (expfd < 0) {
		printf("Cannot open GPIO to export it\n");
		exit(1);
	}

	write(expfd, gpioid, 4);

	// Update the direction of the GPIO to be an output
	sprintf(gpio_dirpath, "/sys/class/gpio/gpio%s/direction", gpioid);
	dirfd = open(gpio_dirpath, O_RDWR);
	if (dirfd < 0) {
		printf("Cannot open GPIO direction it\n");
		exit(1);
	}

	write(dirfd, "out", 4);

	close(dirfd);
	close(expfd);
}

void demo_gpio_release(char* gpioid)
{
	int unexpfd  = -1;

	unexpfd = open("/sys/class/gpio/unexport", O_WRONLY);
	if (unexpfd < 0) {
		printf("Cannot open GPIO to unexport it\n");
		exit(1);
	}

	write(unexpfd, gpioid, 4);

	close(unexpfd);
}

void demo_gpio_reset(char* gpioid)
{
	int valfd = -1;
	char gpio_valpath[50];

	sprintf(gpio_valpath, "/sys/class/gpio/gpio%s/value", gpioid);
	valfd = open(gpio_valpath, O_RDWR);
	if (valfd < 0) {
		printf("Cannot open GPIO value\n");
		exit(1);
	}
	write(valfd, "1", 2);
	write(valfd, "0", 2);
	close(valfd);
}

void demo_gpio_write_value(char* gpioid, char* val)
{
	int valfd = -1;
	char gpio_valpath[50];

	sprintf(gpio_valpath, "/sys/class/gpio/gpio%s/value", gpioid);
	valfd = open(gpio_valpath, O_RDWR);
	if (valfd < 0) {
		printf("Cannot open GPIO value\n");
		exit(1);
	}
	write(valfd, val, 2);
	close(valfd);
}
