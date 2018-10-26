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

#include "demo_test_drivers.h"
#include "sdfec_usr_intf.h"

#include "xsd_fec_dec_docsis_short_params.h"
#include "xsd_fec_dec_docsis_medium_params.h"
#include "xsd_fec_dec_docsis_long_params.h"
#include "xsd_fec_enc_docsis_short_params.h"
#include "xsd_fec_enc_docsis_medium_params.h"
#include "xsd_fec_enc_docsis_long_params.h"


#define FEC_DEC  "/dev/xsdfec0"
#define FEC_ENC  "/dev/xsdfec1"

user_params* enc_codes[NUM_LDPC_CODES] = {
	&xsd_fec_enc_docsis_short_params,
	&xsd_fec_enc_docsis_medium_params,
	&xsd_fec_enc_docsis_long_params
};

user_params* dec_codes[NUM_LDPC_CODES] = {
	&xsd_fec_dec_docsis_short_params,
	&xsd_fec_dec_docsis_medium_params,
	&xsd_fec_dec_docsis_long_params
};

int main(void)
{
	int ret_val = -1;
	int enc_fd  = -1;
	int dec_fd  = -1;
	int valid_config_params = 0;

	unsigned int code_id = 0;

	XData_source_top  data_source_top;
	XStats_top        stats_top;
	struct demo_monitors_t mons;

	struct metal_init_params metal_param = METAL_INIT_DEFAULTS;
	struct xsdfec_user_ldpc_table_offsets  dec_user_offsets;
	struct xsdfec_user_ldpc_table_offsets  enc_user_offsets;
	struct xsdfec_ldpc_params              dec_ldpc_params;
	struct xsdfec_ldpc_params              enc_ldpc_params;

	dec_user_offsets.sc_off = 0;
	dec_user_offsets.la_off = 0;
	dec_user_offsets.qc_off = 0;
	enc_user_offsets.sc_off = 0;
	enc_user_offsets.la_off = 0;
	enc_user_offsets.qc_off = 0;

	struct demo_params_t params      = { 0, 100, 6, 8, 0, 2, 0, 0 };
	struct demo_params_t prev_params = { 255, 0, 0, 0, 0, 0, 0, 0 };
	struct demo_stats_t  stats;

	printf("Initialize all devices\n");
	// GPIO Reset
	demo_gpio_initialize(GPIO_RESET_ID);
	// GPIO LEDs
	demo_gpio_initialize(GPIO_LED0_ID);
	demo_gpio_initialize(GPIO_LED1_ID);

	metal_init(&metal_param);
	ret_val = demo_data_source_initialize(&data_source_top);
	if (ret_val < 0) {
		printf("Failed to initialize data source block\n");
		exit(1);
	}
	ret_val = demo_stats_initialize(&stats_top);
	if (ret_val < 0) {
		printf("Failed to initialize stats block\n");
		exit(1);
	}
	ret_val = demo_monitors_initialize(&mons);
	if (ret_val < 0) {
		printf("Failed to initialize monitor blocks\n");
		exit(1);
	}

	// All LEDs off
	demo_gpio_write_value(GPIO_LED0_ID, "0");

	printf("Open FECs\n");
	dec_fd = open_xsdfec(FEC_DEC);
	if (dec_fd < 0) {
		printf("Failed to open dev %s\n", FEC_DEC);
		goto release_monitors;
	}

	enc_fd = open_xsdfec(FEC_ENC);
	if (enc_fd < 0) {
		printf("Failed to open dev %s\n", FEC_ENC);
		goto release_monitors;
	}

	// LED0 on only
	demo_gpio_write_value(GPIO_LED0_ID, "1");

	// Fixed SD-FEC & tests parameters
	// Example design require in-order outputs.
	set_order_xsdfec(dec_fd, XSDFEC_MAINTAIN_ORDER);
	set_order_xsdfec(enc_fd, XSDFEC_MAINTAIN_ORDER);
	demo_data_source_set_fec_type(&data_source_top);
	do {
		demo_gpio_write_value(GPIO_LED1_ID, "0");
		if (params.code != prev_params.code) {
			printf("Setup LDPC code for decoder\n");
			ret_val = prepare_ldpc_code(dec_codes[params.code],
						    &dec_user_offsets,
						    &dec_ldpc_params, code_id);
			if (ret_val != 0) {
				printf("Failed to perpare user ldpc code\n");
				goto close_devices;
			}

			ret_val = add_ldpc_xsdfec(dec_fd, &dec_ldpc_params);
			if (ret_val != 0) {
				printf("Failed to add ldpc code\n");
				goto close_devices;
			}

			printf("Setup LDPC code for encoder\n");
			ret_val = prepare_ldpc_code(enc_codes[params.code],
						    &enc_user_offsets,
						    &enc_ldpc_params, code_id);
			if (ret_val != 0) {
				printf("Failed to perpare user ldpc code\n");
				goto close_devices;
			}

			ret_val = add_ldpc_xsdfec(enc_fd, &enc_ldpc_params);
			if (ret_val != 0) {
				printf("Failed to add ldpc code\n");
				goto close_devices;
			}
		}

		printf("Start decoder FEC\n");
		ret_val = start_xsdfec(dec_fd);
		if (ret_val != 0) {
			printf("Failed to start device\n");
			goto close_devices;
		}

		printf("Start encoder FEC\n");
		ret_val = start_xsdfec(enc_fd);
		if (ret_val != 0) {
			printf("Failed to start device\n");
			goto close_devices;
		}

		// Code sizes
		unsigned int k = dec_codes[params.code]->k;
		unsigned int n = dec_codes[params.code]->n;

		if(demo_params_changed(&params, &prev_params)) {
			printf("Setup data source, stats and monitors\n");
			//
			demo_data_source_setup(&data_source_top, &params, k, n);

			// Setup stats
			demo_stats_setup(&stats_top, &params, k, n);

			// Setup performance monitor blocks
			demo_monitors_setup(&mons, &params);
		}
		// LED1 on only
		demo_gpio_write_value(GPIO_LED0_ID, "0");
		demo_gpio_write_value(GPIO_LED1_ID, "1");

		// Start data source and stats
		demo_monitors_start(&mons);
		demo_stats_start(&stats_top);
		demo_data_source_start(&data_source_top);

		printf("Wait for finish\n");
		while (!demo_stats_is_idle(&stats_top)) { }

		printf("Collect stats\n");
		demo_stats_collect(&stats_top, &mons, &stats);

		// All LEDs on
		demo_gpio_write_value(GPIO_LED0_ID, "1");
		demo_gpio_write_value(GPIO_LED1_ID, "1");

		// Print results
		demo_stats_print(&stats);

		printf("Stop encoder FEC\n");
		ret_val = stop_xsdfec(enc_fd);
		if (ret_val  != 0) {
			printf("Failed to stop dev %s\n", FEC_ENC);
			goto close_devices;
		}

		printf("Stop decoder FEC\n");
		ret_val = stop_xsdfec(dec_fd);
		if (ret_val  != 0) {
			printf("Failed to stop dev %s\n", FEC_DEC);
			goto close_devices;
		}

		/*
		 * Get valid parameters, the following cases will result in valid
		 * parmeters:
		 *  - User continues with prev_params
		 *  - User enters valid params
		 * if invalid parameters are entered then the user will be reasked
		 * the above options.
		 */
		prev_params = params;
		do
		{
			valid_config_params = demo_params_get(&params);
		} while (valid_config_params == 0);

	} while (1);


close_devices:
	printf("Close FEC encoder\n");
	(void)close_xsdfec(enc_fd);
	printf("Close FEC decoder\n");
	(void)close_xsdfec(dec_fd);

release_monitors:
	demo_monitors_release(&mons);
	demo_stats_release(&stats_top);
	demo_data_source_release(&data_source_top);

	// GPIO LEDs
	demo_gpio_release(GPIO_LED1_ID);
	demo_gpio_release(GPIO_LED0_ID);

	// GPIO Reset
	demo_gpio_release(GPIO_RESET_ID);

	return 0;
}
