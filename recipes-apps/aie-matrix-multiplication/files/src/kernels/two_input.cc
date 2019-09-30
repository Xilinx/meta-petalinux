#include <cardano.h>
#define NUM_ELMNT 128

int a[NUM_ELMNT/2], b[NUM_ELMNT/2], c[NUM_ELMNT/2];

void TwoInput(input_window_int32 * matA, 
		output_window_int32 * out) {
	
	for(unsigned i = 0; i < NUM_ELMNT/2; i++)
		a[i] = window_readincr(matA);
	
	for(unsigned i = 0; i < NUM_ELMNT/2; i++)
		b[i] = window_readincr(matA);
	
	for(unsigned i = 0; i < NUM_ELMNT/2; i++) {
		c[i] = a[i] * b[i];
		window_writeincr(out, c[i]);
	}
}
