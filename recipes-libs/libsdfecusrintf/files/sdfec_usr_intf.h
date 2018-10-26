/******************************************************************************
*
* Copyright (C) 2016 Xilinx, Inc.  All rights reserved.
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
/****************************************************************************/
/**
 * @date	October 21, 2016
 * @brief	SDFEC User Interface Header
 *
 * @details
 * This header provides the definitions for the User Interface to control the
 * SDFEC Engine Instance.
 *
 * The Xilinx FEC SDFEC Engine is a hard IP designed for Xilinx FPGAs and SOCs
 * and the contains the following general features :
 *	- Support for LDPC and Turbo Codes
 *	- 32 bit wide AXI based register interface
 *
 * This API utilizes a 32 bit AXI MMIO interface to the FEC registers.
 * All interfaces described below are implemented in sdfec_usr_intf.c
 *
 * The user interface provided here performs device initialisation,
 * loading of appropriate codes, starting and stopping the SDFEC device
 * via IOCTL calls.
 *
 * The SDFEC IP is intended to be delivered as a part of a MP-SoC offering.
 * The  is expected to be built and compiled by means of a PetaLinux app.
 *
 * <pre>
 * Modification History
 *
 * Ver    Who       Date             Changes
 * --------------------------------------------------------------------------
 * 0.1     ra       2016-10-21       Initial User API tested with kernel driver
 * 0.2     dk       2016-08-${TODO}  Modified to match SD FEC Kernel Driver mode
 *
 * </pre>
 *
 *****************************************************************************/

#ifndef __SDFEC_USR_INTF_H__
#define __SDFEC_USR_INTF_H__

#include <stdbool.h>
#include <stdint.h>

typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int32_t s32;
typedef int8_t s8;
typedef int16_t s16;

#include "xilinx_sdfec.h"


/* User/App LDPC Config Data Stucture */
struct xsdfec_user_ldpc_code_params
{
    u32  n;
    u32  k;
    u32  psize;
    u32  nlayers;
    u32  nqc;
    u32  nmqc;
    u32  nm;
    u32  norm_type;
    u32  no_packing;
    u32  special_qc;
    u32  no_final_parity;
    u32  max_schedule;
    u32  *sc_table;
    u32  *la_table;
    u32  *qc_table;
};

/* User/App structure used to track table offests */
struct xsdfec_user_ldpc_table_offsets
{
    u32  sc_off; // Words
    u32  la_off; // Words
    u32  qc_off; // Words
};


/**
 * Opens the device corresponding to an instance of the SDFEC
 * For example this may be used to open "/dev/xsdfec0"
 */
int open_xsdfec(char *dev_name);

/**
 * Close the file represented by the file descriptor fd
 * Can be when the app has completed device initialisation
 */
int close_xsdfec(int fd);

/**
 * Checks the SW structure to verify device was setup correct
 * Enabled DIN,DOUT and CTRL AXI interfaces,
 * This function signals the FEC Instance is ready for operation.
 */
int start_xsdfec(int fd);

/**
 * Disables DIN,DOUT and CTRL AXI interfaces and
 * puts further processing by the FEC instance to a stop
 */
int stop_xsdfec(int fd);

/**
 * Set the SDFec instance to it's default configuration, typically needed
 * after a reset.
 */
int set_default_config_xsdfec(int fd);

/**
 * Query the driver for information about the current configuration
 * of the SDFEC Instance.
 */
int get_config_xsdfec(int fd, struct xsdfec_config * config);


/**
 * Query the driver for error stats from the SDFEC Instance.
 */
int get_stats_xsdfec(int fd, struct xsdfec_stats * stats);

/**
 * Clear the driver of error stats for the SDFEC Instance.
 */
int clear_stats_xsdfec(int fd);

/**
 * Print the configuration queried in get_config_xsdfec() to
 * standard console
 */
void print_config_xsdfec(struct xsdfec_config * config);

/**
 * Query the driver for hardware information about the current
 * status of the SDFEC Instance.
 */
int get_status_xsdfec(int fd, struct xsdfec_status * status);

/**
 * Print the stats queried in get_stats_xsdfec() to
 * standard console
 */
void print_stats_xsdfec(struct xsdfec_status * status,
                        struct xsdfec_stats * stats);

/**
 * Print the status queried in get_status_xsdfec() to
 * standard console
 */
void print_status_xsdfec(struct xsdfec_status * status);

/**
 * Add LDPC code to the SDFEC device
 * This function does not support replacing or updating
 * codes in place. It allows you to append new codes
 *
 * Calling this device on an unitialized SDFEC device
 * will configure that instance to be LDPC only. It
 * cannot be changed to operate with Turbo Codes by
 * calling set_turbo_xsdfec().
 */
int add_ldpc_xsdfec(int fd, struct xsdfec_ldpc_params * ldpc);


/**
 * Enable or disable interrupts generated by the SDFEC device
 * This function supports selective enabling/disabling of certain interrupts
 */
int set_irq_xsdfec(int fd, struct xsdfec_irq * irq);

/**
 * Setup SDFEC to operate with Turbo Codes
 *
 * Calling this function on an uninitialized SDFEC device will
 * configure that instance to be Turbo codes only. It cannot be
 * changed to operate with LDPC codes by calling add_ldpc_xsdfec()
 */
int set_turbo_xsdfec(int fd, struct xsdfec_turbo * turbo);

/**
 * Query the driver for the turbo parameter values. Will return
 * an error if SD-FEC block is not configured in turbo mode.
 */
int get_turbo_xsdfec(int fd, struct xsdfec_turbo * turbo);

/**
 * Sets if the order of blocks can change from input to output for
 * the SDFEC.
 */
int set_order_xsdfec(int fd, enum xsdfec_order order);

/**
 * Sets the bypass mode for the SDFEC.
 * Setting false results in normal operation.
 * setting true results in the sdfec performing the configured
 * operations (same number of cycles) but output data matches the input data
 *
 * note bypass is currently unsigned long to allow negative testing, ideally
 *      should be bool
 * note also the function masks the user from using a pointer for an input
 *      parameter
 */
int set_bypass_xsdfec(int fd, bool bypass);

/**
 * Query the driver to determine if the sdfec is currently progressing data
 */
int is_active_xsdfec(int fd, bool *is_sdfec_active);

/**
 * Convert codes gnereated by config-gen to the format understood
 * by the SDFEC Kernel driver
 */
int prepare_ldpc_code(
	struct xsdfec_user_ldpc_code_params * user_params,
	struct xsdfec_user_ldpc_table_offsets * user_offsets,
	struct xsdfec_ldpc_params * ldpc_params,
	unsigned int code_id);

/**
 * Calculate the offsets for the next in sequence LPDC code tables using the 
 * previously applied lpdc_params to calculate. 
 * 
 * @param  ldpc_params  that last successfully applied LDPC Parameters loaded 
 *                      into the sdfec device.
 * @param  user_offsets As the resultant offsets for the sdfec tables  
 * @return              0 if successful or -1 otherwise
 */
int update_lpdc_table_offsets(
    struct xsdfec_ldpc_params *ldpc_params,
    struct xsdfec_user_ldpc_table_offsets *user_offsets);

/**
 * Calculate the SC table size for a specified Code of the SDFEC device.
 */
int get_sc_table_size(struct xsdfec_user_ldpc_code_params * user_params);

/**
 * Print LDPC codes after being prepared by prepare_ldpc_code()
 * Used for debugging
 */
void print_ldpc_xsdfec(struct xsdfec_ldpc_params * ldpc);


#endif /* __SDFEC_USR_INTF_H__ */
