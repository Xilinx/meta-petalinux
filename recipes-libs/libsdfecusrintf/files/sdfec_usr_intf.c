/* Kernel Headers */
#include <sys/ioctl.h>
/* User Headers */
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <ctype.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <errno.h>
/* Local Headers */
#include "sdfec_usr_intf.h"

int open_xsdfec(char *dev_name)
{
	int fd = -1;
	if (!dev_name) {
		fprintf(stderr, "%s : Null file name", __func__);
		return -ENOENT;
	}

	fd = open(dev_name, O_RDWR);
	if (fd < 0) {
		fprintf(stderr, "%s : Failed to open %s error = %s\n",
			__func__, dev_name, strerror(errno));
		return -1;
	}

	return fd;
}

int close_xsdfec(int fd)
{
	int rval;
	if (fd < 0) {
		fprintf(stderr, "%s : Invalid file descriptor %d\n",
				__func__, fd);
		return -EBADF;
	}
	rval = close(fd);
	if (rval < 0) {
		fprintf(stderr, "%s : Close failed with %s",
			__func__, strerror(errno));
		return (errno);
	}
	return 0;
}

int get_config_xsdfec(int fd, struct xsdfec_config * config)
{
    int rval;

    if (fd < 0) {
        fprintf(stderr, "%s : Invalid file descriptor %d\n",
                __func__, fd);
        return -EBADF;
    }

    if (!config) {
        fprintf(stderr, "%s : NULL config pointer\n",
            __func__, fd);
        return -EINVAL;
    }

    if ((rval = ioctl(fd, XSDFEC_GET_CONFIG, config)) < 0) {
        fprintf(stderr, "%s failed with %s\n", strerror(errno));
        return rval;
    }
    return 0;
}

int get_status_xsdfec(int fd, struct xsdfec_status * status)
{
	int rval;

	if (fd < 0) {
		fprintf(stderr, "%s : Invalid file descriptor %d\n",
				__func__, fd);
		return -EBADF;
	}

	if (!status) {
		fprintf(stderr, "%s : NULL status pointer\n",
			__func__, fd);
		return -EINVAL;
	}

	if ((rval = ioctl(fd, XSDFEC_GET_STATUS, status)) < 0) {
		fprintf(stderr, "%s failed with %s\n", strerror(errno));
		return rval;
	}
	return 0;
}

void print_stats_xsdfec(struct xsdfec_status * status,
			struct xsdfec_stats * stats)
{
	if (!stats) {
		fprintf(stderr, "Stats is NULL ... exiting\n");
		return;
	}

	printf("-------- XSDFEC%d Stats ---------\n", status->fec_id);
    	/* Print State */
	printf("ISR Error Count               = %u\n",  stats->isr_err_count);
	printf("Correctable ECC Error Count   = %u\n", stats->cecc_count);
	printf("Uncorrectable ECC Error Count = %u\n", stats->uecc_count);
	printf("--------------------------------\n");
}

void print_status_xsdfec(struct xsdfec_status * status)
{
	if (!status) {
		fprintf(stderr, "Status is NULL ... exiting\n");
		return;
	}

	printf("-------- XSDFEC%d Status --------\n", status->fec_id);
    	/* Print State */
    	if (status->state == XSDFEC_INIT)
    	    printf(" State : Initialized\n");
    	else if (status->state == XSDFEC_STARTED)
    	    printf(" State : Started\n");
    	else if (status->state == XSDFEC_STOPPED)
    	    printf(" State : Stopped\n");
    	else if (status->state == XSDFEC_NEEDS_RESET)
    	    printf(" State : Needs Reset\n");
    	else
    	    printf(" State : Invalid\n");
	/* Print Activity */
	printf("Activity : %d\n", status->activity);
	printf("------------------------------\n");
}

void print_config_xsdfec(struct xsdfec_config * config)
{
    if (!config) {
        fprintf(stderr, "Status is NULL ... exiting\n");
        return;
    }

    printf("-------- XSDFEC%d Config --------\n", config->fec_id);
    /* Print Code */
    if (config->code == XSDFEC_TURBO_CODE)
        printf(" Code : Turbo\n");
    else if (config->code == XSDFEC_LDPC_CODE)
        printf(" Code : LDPC\n");
    else
        printf(" Code : Invalid\n");

    /* Print Order */
    if (config->order == XSDFEC_MAINTAIN_ORDER)
        printf(" Order : Maintain Order\n");
    else if (config->order == XSDFEC_OUT_OF_ORDER)
        printf(" Order : Out Of Order\n");
    else
        printf(" Order : Invalid\n");

    printf("------------------------------\n");
}

int start_xsdfec(int fd)
{
	int rval;

	if (fd < 0) {
		fprintf(stderr, "%s : Invalid file descriptor %d\n",
				__func__, fd);
		return -EBADF;
	}

	if ((rval = ioctl(fd, XSDFEC_START_DEV)) < 0) {
		fprintf(stderr, "%s : failed with %s\n",
			__func__, strerror(errno));
		return rval;
	}

	return 0;
}

int stop_xsdfec(int fd)
{
	int rval;

	if (fd < 0) {
		fprintf(stderr, "%s : Invalid file descriptor %d\n",
				__func__, fd);
		return -EBADF;
	}

	if ((rval = ioctl(fd, XSDFEC_STOP_DEV)) < 0) {
		fprintf(stderr, "%s : failed with %s\n",
		 __func__, strerror(errno));
		return rval;
	}

	return 0;
}

int set_turbo_xsdfec(int fd, struct xsdfec_turbo * turbo)
{
	int rval;

	if (fd < 0) {
		fprintf(stderr, "%s : Invalid file descriptor %d\n",
				__func__, fd);
		return -EBADF;
	}

	if (!turbo) {
		fprintf(stderr, "%s : NULL turbo code pointer\n",
			__func__, fd);
		return -EINVAL;
	}

	if ((rval = ioctl(fd, XSDFEC_SET_TURBO, turbo)) < 0) {
		fprintf(stderr, "%s : failed with %s\n",
		 __func__, strerror(errno));
		return rval;
	}
	return 0;
}

int get_turbo_xsdfec(int fd, struct xsdfec_turbo * turbo)
{
    int rval;

    if (fd < 0) {
        fprintf(stderr, "%s : Invalid file descriptor %d\n",
                __func__, fd);
        return -EBADF;
    }

    if (!turbo) {
        fprintf(stderr, "%s : NULL Turbo pointer\n",
            __func__, fd);
        return -EINVAL;
    }

    if ((rval = ioctl(fd, XSDFEC_GET_TURBO, turbo)) < 0) {
        fprintf(stderr, "%s failed with %s\n", strerror(errno));
        return rval;
    }
    return 0;
}

int set_irq_xsdfec(int fd, struct xsdfec_irq * irq)
{
	int rval;

	if (fd < 0) {
		fprintf(stderr, "%s : Invalid file descriptor %d\n",
				__func__, fd);
		return -EBADF;
	}

	if (!irq) {
		fprintf(stderr, "%s : NULL irq pointer\n",
			__func__, fd);
		return -EINVAL;
	}

	if ((rval = ioctl(fd, XSDFEC_SET_IRQ, irq)) < 0) {
		fprintf(stderr, "%s : failed with %s\n",
		 __func__, strerror(errno));
		return rval;
	}
	return 0;
}

int add_ldpc_xsdfec(int fd, struct xsdfec_ldpc_params * ldpc)
{
	int rval;

	if (fd < 0) {
		fprintf(stderr, "%s : Invalid file descriptor %d\n",
				__func__, fd);
		return -EBADF;
	}

	if (!ldpc) {
		fprintf(stderr, "%s : NULL status pointer\n",
			__func__, fd);
		return -EINVAL;
	}

	if ((rval = ioctl(fd, XSDFEC_ADD_LDPC_CODE_PARAMS, ldpc)) < 0)
	{
		fprintf(stderr, "%s : failed with %s\n",
		 __func__, strerror(errno));
		return rval;
	}
	return 0;
}

int set_default_config_xsdfec(int fd)
{
	int rval;

	if (fd < 0) {
		fprintf(stderr, "%s : Invalid file descriptor %d\n",
				__func__, fd);
		return -EBADF;
	}

	if ((rval = ioctl(fd, XSDFEC_SET_DEFAULT_CONFIG)) < 0) {
		fprintf(stderr, "%s : failed with %s\n",
		 __func__, strerror(errno));
		return rval;
	}
	return 0;
}

int get_stats_xsdfec(int fd, struct xsdfec_stats * stats)
{
    int rval;

    if (fd < 0) {
        fprintf(stderr, "%s : Invalid file descriptor %d\n",
                __func__, fd);
        return -EBADF;
    }

    if (!stats) {
        fprintf(stderr, "%s : NULL stats pointer\n",
            __func__, fd);
        return -EINVAL;
    }

    if ((rval = ioctl(fd, XSDFEC_GET_STATS, stats)) < 0) {
        fprintf(stderr, "%s failed with %s\n", strerror(errno));
        return rval;
    }
    return 0;
}
int clear_stats_xsdfec(int fd)
{
	int rval;

	if (fd < 0) {
		fprintf(stderr, "%s : Invalid file descriptor %d\n",
				__func__, fd);
		return -EBADF;
	}

	if ((rval = ioctl(fd, XSDFEC_CLEAR_STATS)) < 0) {
		fprintf(stderr, "%s : failed with %s\n",
		 __func__, strerror(errno));
		return rval;
	}
	return 0;
}
int set_order_xsdfec(int fd, enum xsdfec_order order)
{
	int rval;

	if (fd < 0) {
		fprintf(stderr, "%s : invalid file descriptor %d\n",
				__func__, fd);
		return -EBADF;
	}

	if ((rval = ioctl(fd, XSDFEC_SET_ORDER, &order)) < 0) {
		fprintf(stderr, "%s : failed with %s\n",
		 __func__, strerror(errno));
		return rval;
	}

	return 0;
}

int set_bypass_xsdfec(int fd, bool bypass)
{
	int rval;

	if (fd < 0) {
		fprintf(stderr, "%s : Invalid file descriptor %d\n",
				__func__, fd);
		return -EBADF;
	}

	if ((rval = ioctl(fd, XSDFEC_SET_BYPASS, &bypass)) < 0) {
		fprintf(stderr, "%s : failed with %s\n",
		 __func__, strerror(errno));
		return rval;
	}

	return 0;
}

int is_active_xsdfec(int fd, bool *is_sdfec_active)
{
	int rval;

	if (fd < 0) {
		fprintf(stderr, "%s : Invalid file descriptor %d\n",
				__func__, fd);
		return -EBADF;
	}

	if (!is_sdfec_active) {
		fprintf(stderr, "%s : NULL status pointer\n",
			__func__, fd);
		return -EINVAL;
	}

	if ((rval = ioctl(fd, XSDFEC_IS_ACTIVE, is_sdfec_active)) < 0) {
		fprintf(stderr, "%s : failed with %s\n",
		 __func__, strerror(errno));
		return rval;
	}

	return 0;
}

int prepare_ldpc_code(struct xsdfec_user_ldpc_code_params * user_params,
		      struct xsdfec_user_ldpc_table_offsets * user_offsets,
		      struct xsdfec_ldpc_params * ldpc_params,
		      unsigned int code_id)
{
	int itr;
	if (!user_params || !user_offsets || !ldpc_params) {
		fprintf(stderr, "%s : Null input argument\n");
		return -EINVAL;
	}

	if (code_id >= 128) {
		fprintf(stderr, "%s : Invalid LDPC Code ID\n");
	}

	memset(ldpc_params, 0, sizeof(*ldpc_params));

	ldpc_params->n = user_params->n;
	ldpc_params->k = user_params->k;
	ldpc_params->psize  = user_params->psize;
	ldpc_params->nlayers  = user_params->nlayers;
	ldpc_params->nqc  = user_params->nqc;
	ldpc_params->nmqc  = user_params->nmqc;
	ldpc_params->nm  = user_params->nm;
	ldpc_params->norm_type  = user_params->norm_type;
	ldpc_params->no_packing  = user_params->no_packing;
	ldpc_params->special_qc  = user_params->special_qc;
	ldpc_params->no_final_parity  = user_params->no_final_parity;
	ldpc_params->max_schedule  = user_params->max_schedule;

	ldpc_params->sc_off  = user_offsets->sc_off;
	ldpc_params->la_off  = user_offsets->la_off;
	ldpc_params->qc_off  = user_offsets->qc_off;

	if (!user_params->sc_table) {
		fprintf(stderr, "%s : Null Param SC table\n");
		return -EINVAL;
	}

	/* Prepare SC Table */
	if (get_sc_table_size(user_params) >
	    (XSDFEC_LDPC_SC_TABLE_ADDR_HIGH - XSDFEC_LDPC_SC_TABLE_ADDR_BASE)) {
		fprintf(stderr,
		"%s : SC Table entries for code %d exceeds reg space\n",
		__func__, code_id);
		return -EINVAL;
	}

	for (itr = 0; itr < get_sc_table_size(user_params); itr++)
	{
		ldpc_params->sc_table[itr] = user_params->sc_table[itr];
	}

	/* Prepare LA Table */
	if (user_params->nlayers >
	    (XSDFEC_LDPC_LA_TABLE_ADDR_HIGH - XSDFEC_LDPC_LA_TABLE_ADDR_BASE)) {
		fprintf(stderr,
		"%s : LA Table entries for code %d exceeds reg space\n",
		__func__, code_id);
		return -EINVAL;
	}

	for (itr = 0; itr < user_params->nlayers; itr++)
	{
		ldpc_params->la_table[itr] = user_params->la_table[itr];
	}

	/* Prepare QC Table */
	if (user_params->nqc >
		(XSDFEC_LDPC_QC_TABLE_ADDR_HIGH -
	                        XSDFEC_LDPC_QC_TABLE_ADDR_BASE)) {
		fprintf(stderr,
		"%s : LA Table entries for code %d exceeds reg space\n",
		__func__, code_id);
		return -EINVAL;
	}

	for (itr = 0; itr < user_params->nqc; itr++)
	{
		ldpc_params->qc_table[itr] = user_params->qc_table[itr];
	}

	ldpc_params->code_id = code_id;
	return 0;
}

int update_lpdc_table_offsets(struct xsdfec_ldpc_params *ldpc_params,
			      struct xsdfec_user_ldpc_table_offsets *user_offsets)
{
	struct xsdfec_ldpc_param_table_sizes table_sizes;

	xsdfec_calculate_shared_ldpc_table_entry_size(ldpc_params, &table_sizes);
	user_offsets->sc_off = ldpc_params->sc_off + table_sizes.sc_size;
	user_offsets->la_off = ldpc_params->la_off + table_sizes.la_size;
	user_offsets->qc_off = ldpc_params->qc_off + table_sizes.qc_size;

	return 0;
}

int get_sc_table_size(struct xsdfec_user_ldpc_code_params * user_params)
{
	int sc_table_size;
	int rem;

	rem = (user_params->nlayers) % 4;
	sc_table_size = (user_params->nlayers) % 4;
	if (rem != 0)
	{
		sc_table_size++;
	}
	return sc_table_size;
}

#if 0
void print_ldpc_xsdfec(struct xsdfec_ldpc_params * ldpc)
{
	if (!ldpc)
		return;
	printf("---- LPDC Code %d ----\n", ldpc->code_id);
	printf("\t n = 0x%x\n", ldpc->n);
	printf("\t k = 0x%x\n", ldpc->k);
	printf("\t psize = 0x%x\n", ldpc->psize);
	printf("\t nlayers = 0x%x\n", ldpc->nlayers);
	printf("\t nqc = 0x%x\n", ldpc->nqc);
	printf("\t sc_off = 0x%x\n", ldpc->sc_off);
	printf("\t la_off = 0x%x\n", ldpc->la_off);
	printf("\t qc_off = 0x%x\n", ldpc->qc_off);
	printf("sc_table[0] = 0x%x  sc_table[nlayers-1] = 0x%x\n",
		ldpc->sc_table[0], ldpc->sc_table[ldpc->nlayers -1]);
	printf("la_table[0] = 0x%x  la_table[nlayers-1] = 0x%x\n",
		ldpc->la_table[0], ldpc->la_table[ldpc->nlayers -1]);
	printf("qc_table[0] = 0x%x  qc_table[nqc-1] = 0x%x\n",
		ldpc->qc_table[0], ldpc->qc_table[ldpc->nqc -1]);
}
#endif
