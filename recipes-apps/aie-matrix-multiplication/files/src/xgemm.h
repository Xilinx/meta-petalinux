#include "kernels.h"
#include <cardano.h>
#include "kernels/config.h"

using namespace cardano;

class XGeMM : public cardano::graph {
	private:
  		kernel krnl[NUM_HW_COLS];
	public:
		input_port matrix_a;
		output_port result;
		
		XGeMM() {
			krnl[0] = kernel::create(OneInput);
			source(krnl[0]) = "src/kernels/one_input.cc";
			runtime<ratio>(krnl[0]) = 0.9;
			location<kernel>(krnl[0]) = tile(0,0);
			
			for(int i = 1; i < NUM_HW_COLS - 1; i++) {
				krnl[i] = kernel::create(TwoInputs);
				source(krnl[i]) = "src/kernels/two_inputs.cc";
				runtime<ratio>(krnl[i]) = 0.9;
				location<kernel>(krnl[i]) = tile(i,0);
			}	

			krnl[NUM_HW_COLS - 1] = kernel::create(OneOutput);
			source(krnl[NUM_HW_COLS - 1]) = "src/kernels/one_output.cc";
			runtime<ratio>(krnl[NUM_HW_COLS - 1]) = 0.9;
			location<kernel>(krnl[NUM_HW_COLS - 1]) = tile(NUM_HW_COLS - 1, 0);

			connect<window<WIN_SIZE*4>> n0(matrix_a, async(krnl[0].in[0]));

			for(int i = 0; i < NUM_HW_COLS - 1; i++) {
   				connect<window<WIN_SIZE*4>> (async(krnl[i].out[0]), async(krnl[i+1].in[0]));
				connect<window<NUM_ROWS/NUM_HW_COLS*4>> (async(krnl[i].out[1]), async(krnl[i+1].in[1]));
			}

			connect<window<WIN_SIZE*4>> n(async(krnl[NUM_HW_COLS - 1].out[0]), result);
		}
};
