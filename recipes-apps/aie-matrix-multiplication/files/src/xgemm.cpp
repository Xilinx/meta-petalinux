#include <cardano.h>
#include "xgemm.h"
#include "kernels.h"
#include <unistd.h>
#include "kernels/config.h"	
#include <sys/time.h>
extern "C"
{
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <time.h>
#include <xaiengine.h>
}

#define raw_printf(format, ...) printf(format, ##__VA_ARGS__)
#define LPRINTF(format, ...) raw_printf("PLIO MCDMA> " format, ##__VA_ARGS__)
#define raw_perror(format, ...) fprintf(stderr, format, ##__VA_ARGS__)
#define LPERROR(format, ...) raw_perror("ERROR: PLIO MCDMA> " format, ##__VA_ARGS__)
#ifdef DEBUG
#define LPDEBUG(format, ...) LPRINTF(format, ##__VA_ARGS__)
#else
#define LPDEBUG(format, ...)
#endif

using namespace cardano;

PLIO gin0 = PLIO("plioin0", plio_64_bits);
PLIO gout0 = PLIO("plioout0", plio_64_bits);

simulation::platform<1,1> platform(&gin0, &gout0);

XGeMM my_graph;
connect<> in0(platform.src[0], my_graph.matrix_a);
connect<> out0(my_graph.result, platform.sink[0]);

#define MM2S_DMA_LEN (0x1000)
#define WIN_SIZE_BYTE (WIN_SIZE * 4)

static XAieGbl_MemInst *ddr_mem;
static void *ddr_mem_va;
static uint64_t xaxidma_mm2s_addr, xaxidma_s2mm_addr;
static uint64_t xaxidma_va;
static uint64_t xaxidma_addr;

/* Send data to AIE with PL DMA */
static uint32_t send_dma(uint32_t chan_id, uint64_t mm2s_addr, uint32_t mm2s_bufsize)
{
	uint32_t offset = 0x40U * chan_id;
	uint32_t bufsize, max_bufsize;
	unsigned char *bdptr = (unsigned char *)ddr_mem_va + 0x00000;
	unsigned char *next_bdptr;
	uint64_t bd_pa = XAieGbl_MemGetPaddr(ddr_mem) + 0x00000;
	uint64_t next_bd_pa;
	uint32_t buf_addr;

	LPDEBUG("%s: mm2s: 0x%lx, size=0x%x, bd_base=0x%x.\r\n",
		__func__, mm2s_addr, mm2s_bufsize, bd_pa);
	max_bufsize = (MM2S_DMA_LEN * (0x20000/0xC0));
	if (mm2s_bufsize > max_bufsize) {
		mm2s_bufsize = max_bufsize;
	}

	/* Set up the descriptor and mm2s */
	memset(bdptr, 0, 0x20000);
	next_bdptr = bdptr;
	next_bd_pa = bd_pa;
	buf_addr = mm2s_addr;
	for (bufsize = mm2s_bufsize; bufsize != 0; ) {
		uint32_t tmpbufsize = bufsize;
		uint32_t v;

		if (tmpbufsize > MM2S_DMA_LEN) {
			tmpbufsize = MM2S_DMA_LEN;
		}
		bufsize -= tmpbufsize;
		/* next addr */
		if (bufsize != 0) {
			next_bd_pa += 0xC0;
		}
		*((volatile uint32_t *)(next_bdptr + 0x4)) = next_bd_pa >> 32;
		*((volatile uint32_t *)(next_bdptr + 0x0)) = next_bd_pa & 0xFFFFFFC0;

		/* buffer addr */
		*((volatile uint32_t *)(next_bdptr + 0xc)) = 0;
		*((volatile uint32_t *)(next_bdptr + 0x8)) = buf_addr & 0xffffffff;
		/* sof | eof | size */
		v = tmpbufsize & 0x3FFFFFF;
		if (bufsize == 0) {
			/* eof */
			v |= 0x40000000;
		}
		if ((tmpbufsize + bufsize) == mm2s_bufsize) {
			/* sof */
			v |= 0x80000000;
		}
		*((volatile uint32_t *)(next_bdptr + 0x14)) = v;

		if (bufsize != 0) {
			next_bdptr += 0xC0;
			buf_addr += tmpbufsize;
		}
	}

	/* Enable the mm2s channe 1 */
	*((volatile uint32_t *)(xaxidma_va + 0x8)) = 0x1 << (chan_id - 1);
	/* Program descriptors: curr */
	*((volatile uint32_t *)(xaxidma_va + offset + 0x8)) = bd_pa & 0xFFFFFFC0;
	*((volatile uint32_t *)(xaxidma_va + offset + 0xc)) = bd_pa >> 32;

	/* Enable Fetch bit if the channel control register */
	*((volatile uint32_t *)(xaxidma_va + offset + 0x0)) = 0x1;
	/* Run the device */
	*((volatile uint32_t *)(xaxidma_va + 0x0)) = 0x1;

	/* mm2s tail */
	*((volatile uint32_t *)(xaxidma_va + offset + 0x10)) = next_bd_pa & 0xFFFFFFC0;
	*((volatile uint32_t *)(xaxidma_va + offset + 0x14)) = next_bd_pa >> 32;

	return mm2s_bufsize;
}

/* Receive data from AIE with PL DMA */
static uint32_t recv_dma(uint32_t chan_id, uint64_t s2mm_addr, uint32_t s2mm_bufsize)
{
	uint32_t offset = 0x40U * chan_id;
	uint32_t bufsize, max_bufsize;
	unsigned char *bdptr = (unsigned char *)ddr_mem_va + 0x20000;
	unsigned char *next_bdptr;
	uint64_t bd_pa = XAieGbl_MemGetPaddr(ddr_mem) + 0x20000;
	uint64_t next_bd_pa;
	uint32_t buf_addr;

	LPDEBUG("%s: s2mm=0x%lx, size=0x%x, win_size=0x%x, bd_base=0x%x.\r\n",
		__func__, s2mm_addr, s2mm_bufsize, WIN_SIZE_BYTE, bd_pa);
	max_bufsize = (WIN_SIZE_BYTE * (0x20000/0xC0));
	if (s2mm_bufsize > max_bufsize) {
		s2mm_bufsize = max_bufsize;
	}

	/* Set up the descriptor and s2mm */
	memset(bdptr, 0, 0x20000);
	next_bdptr = bdptr;
	next_bd_pa = bd_pa;
	buf_addr = s2mm_addr;
	for (bufsize = s2mm_bufsize; bufsize != 0; ) {
		uint32_t tmpbufsize = bufsize;
		uint32_t v;

		if (tmpbufsize > WIN_SIZE_BYTE) {
			tmpbufsize = WIN_SIZE_BYTE;
		}
		bufsize -= tmpbufsize;
		/* next addr */
		if (bufsize != 0) {
			next_bd_pa += 0xC0;
		}
		*((volatile uint32_t *)(next_bdptr + 0x4)) = next_bd_pa >> 32;
		*((volatile uint32_t *)(next_bdptr + 0x0)) = next_bd_pa & 0xFFFFFFC0;
		*((volatile uint32_t *)(next_bdptr + 0xc)) = 0;
		*((volatile uint32_t *)(next_bdptr + 0x8)) = buf_addr & 0xffffffff;
		/* sof | eof | size */
		v = tmpbufsize & 0x3FFFFFF;
		if (bufsize == 0) {
			/* eof */
			v |= 0x40000000;
		}
		if ((tmpbufsize + bufsize) == s2mm_bufsize) {
			/* sof */
			v |= 0x80000000;
		}
		*((volatile uint32_t *)(next_bdptr + 0x14)) = v;

		if (bufsize != 0) {
			next_bdptr += 0xC0;
			buf_addr += tmpbufsize;
		}
	}

	/* Enable the s2mm channe 1 */
	*((volatile uint32_t *)(xaxidma_va + 0x500 + 0x8)) = 0x1 << (chan_id - 1);
	/* Program descriptors: curr */
	*((volatile uint32_t *)(xaxidma_va + offset + 0x500 + 0xc)) = bd_pa >> 32;
	*((volatile uint32_t *)(xaxidma_va + offset + 0x500 + 0x8)) = bd_pa & 0xFFFFFFC0;

	/* Enable Fetch bit if the channel control register */
	*((volatile uint32_t *)(xaxidma_va + offset + 0x500 + 0x0)) = 0x1;

	/* Run the device */
	*((volatile uint32_t *)(xaxidma_va + 0x500)) = 0x1;

	/* s2mm tail */
	*((volatile uint32_t *)(xaxidma_va + offset + 0x500 + 0x10)) = next_bd_pa & 0xFFFFFFC0;
	*((volatile uint32_t *)(xaxidma_va + offset + 0x500 + 0x14)) = next_bd_pa >> 32;

	LPDEBUG("%s: actual size 0x%x\n", __func__, s2mm_bufsize);
	return s2mm_bufsize;
}

/* Reset PL DMA */
static void reset_dma()
{
	LPRINTF("%s\r\n", __func__);
	*((volatile uint32_t *)(xaxidma_va + 0x00)) = 0x4;
	*((volatile uint32_t *)(xaxidma_va + 0x500)) = 0x4;
	sleep(1);
	*((volatile uint32_t *)(xaxidma_va + 0x00)) = 0;
	*((volatile uint32_t *)(xaxidma_va + 0x500)) = 0;
}

/* Poll PL DMA status */
static void poll_dma()
{
	uint32_t mm2sval, s2mmval;

	mm2sval = *((volatile uint32_t *)(xaxidma_va + 0x04));
	s2mmval = *((volatile uint32_t *)(xaxidma_va + 0x504));
	LPRINTF("%s: mm2s=0x%x,s2mm=0x%x\n", __func__, mm2sval, s2mmval);
}

/* Wait for PL DMA RX status */
static void wait_dma_recv()
{
	uint32_t s2mmval;

	s2mmval = *((volatile uint32_t *)(xaxidma_va + 0x504));
	while((s2mmval & 0x2) == 0) {
		usleep(5);
		s2mmval = *((volatile uint32_t *)(xaxidma_va + 0x504));
	};

	LPDEBUG("%s: s2mm=0x%x\n", __func__, s2mmval);
}

int main(void) {
	int input_ab[NUM_ELMNTS * 2] = {0};
	int input_a[NUM_ROWS][NUM_COLS] =  {0};
	int input_b[NUM_ROWS][NUM_COLS] =  {0};
	int output[NUM_ELMNTS] = {0};
	int outputAPU[NUM_ROWS][NUM_COLS] = {0};
	int outputAIE[NUM_ROWS][NUM_COLS] = {0};
	unsigned char *inBuf, *outBuf;
	int *outIntBuf;

	int fd;
	unsigned int page_addr, page_offset;
	unsigned int page_size=sysconf(_SC_PAGESIZE);
	void *ptr;

	LPRINTF("%u x %u Matrix Multiplication.\n", NUM_COLS, NUM_ROWS);
	for(int i = 0; i < NUM_ROWS; i++) {
	  for(int j = 0; j < NUM_COLS; j++){
		input_a[i][j] = i * NUM_ROWS + j + 1;
		input_b[i][j] = i * NUM_ROWS + j + 1;
	  }
	}

	/* mmap PL DMA */
	fd = open("/dev/mem", O_RDWR);
	if (fd < 1) {
		LPERROR("Failed to open devmem.\r\n");
		return -EINVAL;
	}

	xaxidma_addr = 0xa4000000;
	page_addr = (xaxidma_addr & ~(page_size - 1));
	page_offset = (unsigned int)xaxidma_addr - page_addr;
	ptr = mmap(NULL, page_size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, page_addr);
	if (ptr == NULL) {
		LPERROR("Failed to mmap axi dma address.\r\n");
		return -EINVAL;
	}

	xaxidma_va = (uint64_t)((unsigned char *)ptr + page_offset);

	/* Reset DMA */
	reset_dma();

	/* Setup data in DDR */
	ddr_mem = XAieGbl_MemInit(0);
	if (ddr_mem == NULL) {
		return -EINVAL;
	}
	ddr_mem_va = (void *)((uintptr_t)XAieGbl_MemGetVaddr(ddr_mem));

	LPRINTF("allocated ddr mem: %p.\r\n", ddr_mem_va);
	LPRINTF("pa = 0x%lx.\r\n", XAieGbl_MemGetPaddr(ddr_mem));
	xaxidma_mm2s_addr = XAieGbl_MemGetPaddr(ddr_mem) + 0x40000;
	xaxidma_s2mm_addr = XAieGbl_MemGetPaddr(ddr_mem) + 0x80000;
	if (ddr_mem_va != NULL) {
		inBuf = (unsigned char *)ddr_mem_va + 0x40000;
		outBuf = (unsigned char *)ddr_mem_va + 0x80000;
	}

	outIntBuf = (int *)outBuf;
	/**
	 * transpose for AIE
	 */
	for(int i = 0; i < NUM_ROWS; i++) {
		for(int j = 0; j < NUM_COLS; j++) {
			input_ab[i * NUM_ROWS + j] = input_a[i][j];
			input_ab[NUM_ELMNTS + i * NUM_ROWS + j] = input_a[j][i];
		}
	}
	/* Initialize DDR */
	memset(outBuf, 0, NUM_ELMNTS * sizeof(int32));
	memcpy(inBuf, input_ab, NUM_ELMNTS * 2 * sizeof(int32));

	my_graph.init();
	my_graph.run(1);
	/* Set up DMA */
	recv_dma(1, xaxidma_s2mm_addr, (NUM_ELMNTS) * sizeof(int32));
	send_dma(1, xaxidma_mm2s_addr, (NUM_ELMNTS * 2) * sizeof(int32));
	wait_dma_recv();

	for(int i = 0; i < NUM_ROWS; i++)
		for(int j = 0; j < NUM_COLS; j++)
			outputAIE[j][i] = outIntBuf[i * NUM_ROWS + j];

	 for(int i = 0; i < NUM_ROWS; i++) {
	  for(int j = 0; j < NUM_COLS; j++) {
		for(int k = 0; k < NUM_COLS; k++) {
			outputAPU[i][j] += input_a[i][k] * input_b[k][j];
		}
	  }
	}

	for(int i = 0; i < NUM_ROWS; i++) {
	  for(int j = 0; j < NUM_COLS; j++) {
		if(outputAIE[i][j] != outputAPU[i][j]) {
			LPERROR("[%d][%d]: AIE = 0x%x APU = 0x%x\n",
				i, j, outputAIE[i][j], outputAPU[i][j]);
			return -1;
		}
	  }
	}

	LPRINTF("Successful\n");
	my_graph.end();

	return 0;
}
