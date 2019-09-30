#include <cardano.h>
#include "config.h"

int a[NUM_A_ELMNTS_PER_TILE];

void OneOutput(input_window_int32 * dataIn,
		input_window_int32 * bypassResult,
		output_window_int32 * result) {

	int currentCol = (get_coreid() & 0x7F0000) >> 16;
	int b[NUM_ROWS], intrmdtResult[NUM_ROWS / NUM_HW_COLS];

	for(unsigned i = 0; i < NUM_A_ELMNTS_PER_TILE / WIN_SIZE; i++) {
		window_acquire(dataIn);
		for(unsigned w = 0; w < WIN_SIZE; w++) {
			a[i * WIN_SIZE + w] = window_readincr(dataIn);
		}
		window_release(dataIn);
	}

	/**
	 * read one column of b, pass the same to the next core,
	 * compute matrix multiplication of 'a' rows x 'b' col and
	 * finally output the result
	 */
	for(unsigned i = 0; i < NUM_COLS; i++) {
		/**
		 * read 1 entire col of b
		 */
		window_acquire(dataIn);
		for(unsigned w = 0; w < WIN_SIZE; w++)
			b[w] = window_readincr(dataIn);
		window_release(dataIn);

		/**
		 * copy the results from previous cores to the output window
		 */
		window_acquire(result);
		for(unsigned k = 0; k < currentCol; k++) {
			window_acquire(bypassResult);
			for(unsigned w = 0; w < NUM_ROWS / NUM_HW_COLS; w++)
				window_writeincr(result, window_readincr(bypassResult));
			window_release(bypassResult);
		}

		for(unsigned k = 0; k < NUM_ROWS / NUM_HW_COLS; k++) {
			intrmdtResult[k] = 0;
			for(unsigned l = 0; l < NUM_COLS; l++) {
				intrmdtResult[k] += a[k * NUM_COLS + l] * b[l];
			}
			window_writeincr(result, intrmdtResult[k]);
		}
		window_release(result);
	}
}
