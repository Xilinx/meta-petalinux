/************************** Constant Definitions *****************************/
#ifndef __XAIE_PARAMS__
#define __XAIE_PARAMS__
#define XAIE_NUM_ROWS            8
#define XAIE_NUM_COLS            50
#define XAIE_ADDR_ARRAY_OFF      0x800
#define CTRL_PL_OFFSET          0x20100000000
#define CTRL_IP_STRIDE          0x20000
#endif

/***************************** Include Files *********************************/
#include <iostream>
#include <cardano.h>

#ifndef __AIESIM__
#define HW_TARGET 1 

  #include "src/xgemm.h"

#endif

extern "C"
  {
  #include <stdio.h>
  #include <xaiengine.h>
}

#include "xioutils.h"
#include "cardano/cardano_api/PSImpl.h"


/************************** Variable Definitions *****************************/
/* Graph objects */
#ifndef __CDO__
  extern class XGeMM my_graph;
#endif /* __CDO__ */
/************************** PLIO Configurations  *****************************/

  cardano::PLIOConfig PLIOConfigurations[] = {
  //{id, shim_column, slaveOrMaster, streamId}
    {0, 7, 0, 0}, //gin0, i0
    {1, 7, 1, 0}, //gout0, i1
  };
  const int NUM_PLIO = 2;


/************************** AIE driver and Cardano API initializer *****************************/

  static bool isAIEControlInitialized = false;
  void initializeAIEControlIfNeeded()
  {
    if (!isAIEControlInitialized)
    {
      XAieLib_print("Initializing AIE driver...\n");
      XAIEGBL_HWCFG_SET_CONFIG((&AieConfig), XAIE_NUM_ROWS, XAIE_NUM_COLS, XAIE_ADDR_ARRAY_OFF);
      XAieGbl_HwInit(&AieConfig);
      AieConfigPtr = XAieGbl_LookupConfig(XPAR_AIE_DEVICE_ID);
      (void)XAieGbl_CfgInitialize(&AieInst, &TileInst[0][0], AieConfigPtr);

      XAieLib_print("Initializing Cardano API...\n");
      cardano::ConfigManager::initialize(&TileInst[0][0], XAIE_NUM_COLS, XAIE_NUM_ROWS+1,
                                        nullptr, 0,
                                        nullptr, 0,
                                        nullptr, 0,
                                        PLIOConfigurations, NUM_PLIO,
                                        nullptr, 0, 0,
                                        CTRL_PL_OFFSET, CTRL_IP_STRIDE);

      isAIEControlInitialized = true;
    }
  }


/************************** Function Definitions *****************************/
  void my_graph_init()
  {

	XAieLib_print("Initializing graph my_graph...\n");
	initializeAIEControlIfNeeded();

    #ifdef PS_INIT_AIE

	XAieDma_Tile TileDmaInst;


	XAieLib_print("Configuring PL-Interface for graph my_graph...\n");
	XAieTile_PlIntfDownszrSetBypass(&(TileInst[7][0]), 0, 0);
	XAieTile_PlIntfStrmWidCfg(&(TileInst[7][0]), 1, 0,64);
	XAieTile_PlIntfStrmWidCfg(&(TileInst[7][0]), 0, 0,64);
	// S_EAST_ch0_C23_R0 M_SOUTH_ch0_C23_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[23][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[23][1])), 0), XAIETILE_STRSW_MPORT_SOUTH((&(TileInst[23][1])), 0), XAIE_ENABLE);

	// S_EAST_ch3_C24_R0 M_WEST_ch0_C24_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[24][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[24][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[24][1])), 0), XAIE_ENABLE);

	// S_EAST_ch3_C25_R0 M_WEST_ch3_C25_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[25][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[25][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[25][1])), 3), XAIE_ENABLE);

	// S_EAST_ch3_C26_R0 M_WEST_ch3_C26_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[26][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[26][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[26][1])), 3), XAIE_ENABLE);

	// S_EAST_ch3_C27_R0 M_WEST_ch3_C27_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[27][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[27][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[27][1])), 3), XAIE_ENABLE);

	// S_EAST_ch3_C28_R0 M_WEST_ch3_C28_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[28][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[28][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[28][1])), 3), XAIE_ENABLE);

	// S_EAST_ch3_C29_R0 M_WEST_ch3_C29_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[29][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[29][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[29][1])), 3), XAIE_ENABLE);

	// S_EAST_ch3_C30_R0 M_WEST_ch3_C30_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[30][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[30][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[30][1])), 3), XAIE_ENABLE);

	// S_EAST_ch3_C31_R0 M_WEST_ch3_C31_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[31][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[31][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[31][1])), 3), XAIE_ENABLE);

	// S_EAST_ch3_C32_R0 M_WEST_ch3_C32_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[32][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[32][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[32][1])), 3), XAIE_ENABLE);

	// S_EAST_ch3_C33_R0 M_WEST_ch3_C33_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[33][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[33][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[33][1])), 3), XAIE_ENABLE);

	// S_EAST_ch3_C34_R0 M_WEST_ch3_C34_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[34][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[34][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[34][1])), 3), XAIE_ENABLE);

	// S_EAST_ch3_C35_R0 M_WEST_ch3_C35_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[35][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[35][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[35][1])), 3), XAIE_ENABLE);

	// S_EAST_ch3_C36_R0 M_WEST_ch3_C36_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[36][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[36][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[36][1])), 3), XAIE_ENABLE);

	// S_EAST_ch3_C37_R0 M_WEST_ch3_C37_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[37][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[37][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[37][1])), 3), XAIE_ENABLE);

	// S_EAST_ch3_C38_R0 M_WEST_ch3_C38_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[38][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[38][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[38][1])), 3), XAIE_ENABLE);

	// S_EAST_ch3_C39_R0 M_WEST_ch3_C39_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[39][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[39][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[39][1])), 3), XAIE_ENABLE);

	// S_EAST_ch3_C40_R0 M_WEST_ch3_C40_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[40][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[40][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[40][1])), 3), XAIE_ENABLE);

	// S_EAST_ch3_C41_R0 M_WEST_ch3_C41_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[41][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[41][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[41][1])), 3), XAIE_ENABLE);

	// S_EAST_ch3_C42_R0 M_WEST_ch3_C42_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[42][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[42][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[42][1])), 3), XAIE_ENABLE);

	// S_EAST_ch3_C43_R0 M_WEST_ch3_C43_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[43][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[43][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[43][1])), 3), XAIE_ENABLE);

	// S_EAST_ch3_C44_R0 M_WEST_ch3_C44_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[44][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[44][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[44][1])), 3), XAIE_ENABLE);

	// S_EAST_ch3_C45_R0 M_WEST_ch3_C45_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[45][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[45][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[45][1])), 3), XAIE_ENABLE);

	// S_EAST_ch3_C46_R0 M_WEST_ch3_C46_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[46][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[46][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[46][1])), 3), XAIE_ENABLE);

	// S_EAST_ch3_C47_R0 M_WEST_ch3_C47_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[47][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[47][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[47][1])), 3), XAIE_ENABLE);

	// S_EAST_ch3_C48_R0 M_WEST_ch3_C48_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[48][1]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[48][1])), 3), XAIETILE_STRSW_MPORT_WEST((&(TileInst[48][1])), 3), XAIE_ENABLE);

	// S_MM2S_DMA_ch0_C49_R0 M_WEST_ch3_C49_R0 net99

	XAieTile_StrmConnectCct(&(TileInst[49][1]), XAIETILE_STRSW_SPORT_DMA((&(TileInst[49][1])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[49][1])), 3), XAIE_ENABLE);

	// S_SHIM_EAST_ch0_C0 M_SHIM_NORTH_ch0_C0 net0

	XAieTile_StrmConnectCct(&(TileInst[0][0]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[0][0])), 0), XAIETILE_STRSW_MPORT_NORTH((&(TileInst[0][0])), 0), XAIE_ENABLE);

	// S_SHIM_EAST_ch0_C1 M_SHIM_WEST_ch0_C1 net0

	XAieTile_StrmConnectCct(&(TileInst[1][0]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[1][0])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[1][0])), 0), XAIE_ENABLE);

	// S_SHIM_EAST_ch0_C10 M_SHIM_WEST_ch0_C10 net99

	XAieTile_StrmConnectCct(&(TileInst[10][0]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[10][0])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[10][0])), 0), XAIE_ENABLE);

	// S_SHIM_EAST_ch0_C11 M_SHIM_WEST_ch0_C11 net99

	XAieTile_StrmConnectCct(&(TileInst[11][0]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[11][0])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[11][0])), 0), XAIE_ENABLE);

	// S_SHIM_EAST_ch0_C12 M_SHIM_WEST_ch0_C12 net99

	XAieTile_StrmConnectCct(&(TileInst[12][0]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[12][0])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[12][0])), 0), XAIE_ENABLE);

	// S_SHIM_EAST_ch0_C13 M_SHIM_WEST_ch0_C13 net99

	XAieTile_StrmConnectCct(&(TileInst[13][0]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[13][0])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[13][0])), 0), XAIE_ENABLE);

	// S_SHIM_EAST_ch0_C14 M_SHIM_WEST_ch0_C14 net99

	XAieTile_StrmConnectCct(&(TileInst[14][0]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[14][0])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[14][0])), 0), XAIE_ENABLE);

	// S_SHIM_EAST_ch0_C15 M_SHIM_WEST_ch0_C15 net99

	XAieTile_StrmConnectCct(&(TileInst[15][0]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[15][0])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[15][0])), 0), XAIE_ENABLE);

	// S_SHIM_EAST_ch0_C16 M_SHIM_WEST_ch0_C16 net99

	XAieTile_StrmConnectCct(&(TileInst[16][0]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[16][0])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[16][0])), 0), XAIE_ENABLE);

	// S_SHIM_EAST_ch0_C17 M_SHIM_WEST_ch0_C17 net99

	XAieTile_StrmConnectCct(&(TileInst[17][0]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[17][0])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[17][0])), 0), XAIE_ENABLE);

	// S_SHIM_EAST_ch0_C18 M_SHIM_WEST_ch0_C18 net99

	XAieTile_StrmConnectCct(&(TileInst[18][0]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[18][0])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[18][0])), 0), XAIE_ENABLE);

	// S_SHIM_EAST_ch0_C19 M_SHIM_WEST_ch0_C19 net99

	XAieTile_StrmConnectCct(&(TileInst[19][0]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[19][0])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[19][0])), 0), XAIE_ENABLE);

	// S_SHIM_EAST_ch0_C2 M_SHIM_WEST_ch0_C2 net0

	XAieTile_StrmConnectCct(&(TileInst[2][0]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[2][0])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[2][0])), 0), XAIE_ENABLE);

	// S_SHIM_EAST_ch0_C20 M_SHIM_WEST_ch0_C20 net99

	XAieTile_StrmConnectCct(&(TileInst[20][0]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[20][0])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[20][0])), 0), XAIE_ENABLE);

	// S_SHIM_EAST_ch0_C21 M_SHIM_WEST_ch0_C21 net99

	XAieTile_StrmConnectCct(&(TileInst[21][0]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[21][0])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[21][0])), 0), XAIE_ENABLE);

	// S_SHIM_EAST_ch0_C22 M_SHIM_WEST_ch0_C22 net99

	XAieTile_StrmConnectCct(&(TileInst[22][0]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[22][0])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[22][0])), 0), XAIE_ENABLE);

	// S_SHIM_EAST_ch0_C3 M_SHIM_WEST_ch0_C3 net0

	XAieTile_StrmConnectCct(&(TileInst[3][0]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[3][0])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[3][0])), 0), XAIE_ENABLE);

	// S_SHIM_EAST_ch0_C4 M_SHIM_WEST_ch0_C4 net0

	XAieTile_StrmConnectCct(&(TileInst[4][0]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[4][0])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[4][0])), 0), XAIE_ENABLE);

	// S_SHIM_EAST_ch0_C5 M_SHIM_WEST_ch0_C5 net0

	XAieTile_StrmConnectCct(&(TileInst[5][0]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[5][0])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[5][0])), 0), XAIE_ENABLE);

	// S_SHIM_EAST_ch0_C6 M_SHIM_WEST_ch0_C6 net0

	XAieTile_StrmConnectCct(&(TileInst[6][0]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[6][0])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[6][0])), 0), XAIE_ENABLE);

	// S_SHIM_EAST_ch0_C7 M_SHIM_SOUTH_ch0_C7 net99

	XAieTile_StrmConnectCct(&(TileInst[7][0]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[7][0])), 0), XAIETILE_STRSW_MPORT_SOUTH((&(TileInst[7][0])), 0), XAIE_ENABLE);

	// S_SHIM_EAST_ch0_C8 M_SHIM_WEST_ch0_C8 net99

	XAieTile_StrmConnectCct(&(TileInst[8][0]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[8][0])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[8][0])), 0), XAIE_ENABLE);

	// S_SHIM_EAST_ch0_C9 M_SHIM_WEST_ch0_C9 net99

	XAieTile_StrmConnectCct(&(TileInst[9][0]), XAIETILE_STRSW_SPORT_EAST((&(TileInst[9][0])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[9][0])), 0), XAIE_ENABLE);

	// S_SHIM_NORTH_ch0_C23 M_SHIM_WEST_ch0_C23 net99

	XAieTile_StrmConnectCct(&(TileInst[23][0]), XAIETILE_STRSW_SPORT_NORTH((&(TileInst[23][0])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[23][0])), 0), XAIE_ENABLE);

	// S_SHIM_SOUTH_ch0_C7 M_SHIM_WEST_ch0_C7 net0

	XAieTile_StrmConnectCct(&(TileInst[7][0]), XAIETILE_STRSW_SPORT_SOUTH((&(TileInst[7][0])), 0), XAIETILE_STRSW_MPORT_WEST((&(TileInst[7][0])), 0), XAIE_ENABLE);

	// S_SOUTH_ch0_C0_R0 M_S2MM_DMA_ch0_C0_R0 net0

	XAieTile_StrmConnectCct(&(TileInst[0][1]), XAIETILE_STRSW_SPORT_SOUTH((&(TileInst[0][1])), 0), XAIETILE_STRSW_MPORT_DMA((&(TileInst[0][1])), 0), XAIE_ENABLE);

	 //Bypass elf loading while generating AIE CDO 
	#ifndef __CDO__
	XAieLib_print("Loading elfs of graph my_graph...\n");
	XAieGbl_LoadElf(&(TileInst[0][1]),(u8*)"Work/aie/0_0/Release/0_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[1][1]),(u8*)"Work/aie/1_0/Release/1_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[2][1]),(u8*)"Work/aie/2_0/Release/2_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[3][1]),(u8*)"Work/aie/3_0/Release/3_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[4][1]),(u8*)"Work/aie/4_0/Release/4_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[5][1]),(u8*)"Work/aie/5_0/Release/5_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[6][1]),(u8*)"Work/aie/6_0/Release/6_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[7][1]),(u8*)"Work/aie/7_0/Release/7_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[8][1]),(u8*)"Work/aie/8_0/Release/8_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[9][1]),(u8*)"Work/aie/9_0/Release/9_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[10][1]),(u8*)"Work/aie/10_0/Release/10_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[11][1]),(u8*)"Work/aie/11_0/Release/11_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[12][1]),(u8*)"Work/aie/12_0/Release/12_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[13][1]),(u8*)"Work/aie/13_0/Release/13_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[14][1]),(u8*)"Work/aie/14_0/Release/14_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[15][1]),(u8*)"Work/aie/15_0/Release/15_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[16][1]),(u8*)"Work/aie/16_0/Release/16_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[17][1]),(u8*)"Work/aie/17_0/Release/17_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[18][1]),(u8*)"Work/aie/18_0/Release/18_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[19][1]),(u8*)"Work/aie/19_0/Release/19_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[20][1]),(u8*)"Work/aie/20_0/Release/20_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[21][1]),(u8*)"Work/aie/21_0/Release/21_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[22][1]),(u8*)"Work/aie/22_0/Release/22_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[23][1]),(u8*)"Work/aie/23_0/Release/23_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[24][1]),(u8*)"Work/aie/24_0/Release/24_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[25][1]),(u8*)"Work/aie/25_0/Release/25_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[26][1]),(u8*)"Work/aie/26_0/Release/26_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[27][1]),(u8*)"Work/aie/27_0/Release/27_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[28][1]),(u8*)"Work/aie/28_0/Release/28_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[29][1]),(u8*)"Work/aie/29_0/Release/29_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[30][1]),(u8*)"Work/aie/30_0/Release/30_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[31][1]),(u8*)"Work/aie/31_0/Release/31_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[32][1]),(u8*)"Work/aie/32_0/Release/32_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[33][1]),(u8*)"Work/aie/33_0/Release/33_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[34][1]),(u8*)"Work/aie/34_0/Release/34_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[35][1]),(u8*)"Work/aie/35_0/Release/35_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[36][1]),(u8*)"Work/aie/36_0/Release/36_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[37][1]),(u8*)"Work/aie/37_0/Release/37_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[38][1]),(u8*)"Work/aie/38_0/Release/38_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[39][1]),(u8*)"Work/aie/39_0/Release/39_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[40][1]),(u8*)"Work/aie/40_0/Release/40_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[41][1]),(u8*)"Work/aie/41_0/Release/41_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[42][1]),(u8*)"Work/aie/42_0/Release/42_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[43][1]),(u8*)"Work/aie/43_0/Release/43_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[44][1]),(u8*)"Work/aie/44_0/Release/44_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[45][1]),(u8*)"Work/aie/45_0/Release/45_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[46][1]),(u8*)"Work/aie/46_0/Release/46_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[47][1]),(u8*)"Work/aie/47_0/Release/47_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[48][1]),(u8*)"Work/aie/48_0/Release/48_0", XAIE_ENABLE);
	XAieGbl_LoadElf(&(TileInst[49][1]),(u8*)"Work/aie/49_0/Release/49_0", XAIE_ENABLE);
	#endif

	XAieLib_print("Configuring DMAs of graph my_graph...\n");

	XAieDma_TileInitialize(&(TileInst[0][1]), &TileDmaInst);

	//Setting buffer buf0
	XAieDma_TileBdSetLock(&TileDmaInst, 0, XAIEDMA_TILE_BD_ADDRA, 0, XAIE_ENABLE, 1, XAIE_ENABLE, 0);
	XAieDma_TileBdSetAdrLenMod(&TileDmaInst, 0, 0x3820, 0, 2000, XAIE_DISABLE, XAIE_DISABLE);
	XAieDma_TileBdSetNext(&TileDmaInst, 0, 1);
	XAieDma_TileBdWrite(&TileDmaInst, 0);

	//Setting buffer buf0d
	XAieDma_TileBdSetLock(&TileDmaInst, 1, XAIEDMA_TILE_BD_ADDRA, 1, XAIE_ENABLE, 1, XAIE_ENABLE, 0);
	XAieDma_TileBdSetAdrLenMod(&TileDmaInst, 1, 0x5000, 0, 2000, XAIE_DISABLE, XAIE_DISABLE);
	XAieDma_TileBdSetNext(&TileDmaInst, 1, 0);
	XAieDma_TileBdWrite(&TileDmaInst, 1);

	XAieDma_TileSetStartBd((&TileDmaInst) , XAIEDMA_TILE_CHNUM_S2MM0, 0);
	XAieDma_TileChControl((&TileDmaInst) , XAIEDMA_TILE_CHNUM_S2MM0, XAIE_RESETDISABLE, XAIE_ENABLE);

	XAieDma_TileInitialize(&(TileInst[49][1]), &TileDmaInst);

	//Setting buffer buf99
	XAieDma_TileBdSetLock(&TileDmaInst, 0, XAIEDMA_TILE_BD_ADDRA, 0, XAIE_ENABLE, 0, XAIE_ENABLE, 1);
	XAieDma_TileBdSetAdrLenMod(&TileDmaInst, 0, 0x0, 0, 2000, XAIE_DISABLE, XAIE_DISABLE);
	XAieDma_TileBdSetNext(&TileDmaInst, 0, 1);
	XAieDma_TileBdWrite(&TileDmaInst, 0);

	//Setting buffer buf99d
	XAieDma_TileBdSetLock(&TileDmaInst, 1, XAIEDMA_TILE_BD_ADDRA, 1, XAIE_ENABLE, 0, XAIE_ENABLE, 1);
	XAieDma_TileBdSetAdrLenMod(&TileDmaInst, 1, 0x5820, 0, 2000, XAIE_DISABLE, XAIE_DISABLE);
	XAieDma_TileBdSetNext(&TileDmaInst, 1, 0);
	XAieDma_TileBdWrite(&TileDmaInst, 1);

	XAieDma_TileSetStartBd((&TileDmaInst) , XAIEDMA_TILE_CHNUM_MM2S0, 0);
	XAieDma_TileChControl((&TileDmaInst) , XAIEDMA_TILE_CHNUM_MM2S0, XAIE_RESETDISABLE, XAIE_ENABLE);

	XAieTile_PlIntfDownszrEnable(&(TileInst[7][0]),0);


    #endif

	return;
  }

  void my_graph_run(long long &gr_enable_time, bool &is_graph_running)
  {

    // Reset the core(s)
	XAieLib_print("Resetting core(s) of graph my_graph...\n");
    XAieTile_CoreControl(&(TileInst[0][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[1][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[2][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[3][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[4][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[5][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[6][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[7][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[8][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[9][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[10][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[11][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[12][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[13][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[14][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[15][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[16][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[17][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[18][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[19][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[20][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[21][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[22][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[23][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[24][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[25][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[26][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[27][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[28][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[29][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[30][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[31][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[32][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[33][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[34][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[35][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[36][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[37][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[38][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[39][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[40][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[41][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[42][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[43][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[44][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[45][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[46][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[47][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[48][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[49][1]), XAIE_DISABLE, XAIE_ENABLE);
    if(ess_debug)
    {
      //For debugging enable the cores and put them on halt state
	  XAieLib_print("Putting core(s) of graph my_graph on halt state for debugging...\n");
      XAieGbl_Write32((TileInst[0][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[1][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[2][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[3][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[4][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[5][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[6][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[7][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[8][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[9][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[10][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[11][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[12][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[13][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[14][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[15][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[16][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[17][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[18][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[19][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[20][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[21][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[22][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[23][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[24][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[25][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[26][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[27][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[28][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[29][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[30][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[31][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[32][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[33][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[34][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[35][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[36][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[37][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[38][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[39][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[40][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[41][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[42][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[43][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[44][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[45][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[46][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[47][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[48][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[49][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
    }

    // Record a snapshot of the graph startup/enable time
    gr_enable_time = XAieTile_CoreReadTimer(&(TileInst[0][1]));

	XAieLib_print("Enabling core(s) of graph my_graph...\n");
    XAieTile_CoreControl(&(TileInst[0][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[1][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[2][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[3][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[4][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[5][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[6][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[7][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[8][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[9][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[10][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[11][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[12][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[13][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[14][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[15][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[16][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[17][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[18][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[19][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[20][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[21][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[22][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[23][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[24][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[25][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[26][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[27][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[28][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[29][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[30][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[31][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[32][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[33][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[34][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[35][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[36][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[37][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[38][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[39][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[40][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[41][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[42][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[43][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[44][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[45][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[46][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[47][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[48][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[49][1]), XAIE_ENABLE, XAIE_DISABLE);

    // Set graph enable after enabling all cores
    is_graph_running = true;

	return;
  }

  void my_graph_run(int test_iterations, long long &gr_enable_time, bool &is_graph_running)
  {

    // Set test-iterations for the core(s) of graph my_graph
    XAieTile_DmWriteWord(&(TileInst[0][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[1][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[2][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[3][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[4][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[5][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[6][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[7][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[8][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[9][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[10][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[11][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[12][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[13][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[14][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[15][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[16][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[17][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[18][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[19][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[20][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[21][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[22][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[23][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[24][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[25][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[26][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[27][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[28][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[29][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[30][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[31][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[32][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[33][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[34][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[35][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[36][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[37][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[38][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[39][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[40][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[41][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[42][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[43][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[44][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[45][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[46][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[47][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[48][2]), 0x4, test_iterations);
    XAieTile_DmWriteWord(&(TileInst[49][2]), 0x4, test_iterations);

    // Reset the core(s)
	XAieLib_print("Resetting core(s) of graph my_graph...\n");
    XAieTile_CoreControl(&(TileInst[0][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[1][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[2][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[3][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[4][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[5][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[6][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[7][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[8][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[9][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[10][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[11][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[12][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[13][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[14][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[15][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[16][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[17][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[18][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[19][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[20][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[21][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[22][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[23][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[24][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[25][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[26][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[27][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[28][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[29][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[30][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[31][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[32][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[33][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[34][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[35][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[36][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[37][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[38][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[39][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[40][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[41][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[42][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[43][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[44][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[45][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[46][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[47][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[48][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[49][1]), XAIE_DISABLE, XAIE_ENABLE);
    if(ess_debug)
    {
      //For debugging enable the cores and put them on halt state
	  XAieLib_print("Putting core(s) of graph my_graph on halt state for debugging...\n");
      XAieGbl_Write32((TileInst[0][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[1][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[2][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[3][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[4][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[5][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[6][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[7][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[8][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[9][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[10][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[11][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[12][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[13][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[14][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[15][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[16][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[17][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[18][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[19][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[20][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[21][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[22][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[23][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[24][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[25][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[26][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[27][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[28][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[29][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[30][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[31][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[32][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[33][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[34][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[35][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[36][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[37][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[38][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[39][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[40][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[41][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[42][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[43][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[44][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[45][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[46][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[47][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[48][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[49][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
    }

    // Record a snapshot of the graph startup/enable time
    gr_enable_time = XAieTile_CoreReadTimer(&(TileInst[0][1]));

	XAieLib_print("Enabling core(s) of graph my_graph...\n");
    XAieTile_CoreControl(&(TileInst[0][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[1][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[2][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[3][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[4][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[5][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[6][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[7][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[8][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[9][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[10][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[11][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[12][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[13][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[14][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[15][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[16][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[17][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[18][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[19][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[20][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[21][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[22][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[23][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[24][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[25][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[26][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[27][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[28][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[29][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[30][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[31][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[32][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[33][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[34][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[35][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[36][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[37][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[38][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[39][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[40][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[41][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[42][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[43][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[44][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[45][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[46][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[47][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[48][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[49][1]), XAIE_ENABLE, XAIE_DISABLE);

    // Set graph enable after enabling all cores
    is_graph_running = true;

	return;
  }

  void my_graph_run_cdo(bool cdo_debug, bool enable_cores)
  {

    // Reset the core(s)
	XAieLib_print("Resetting core(s) of graph my_graph...\n");
    XAieTile_CoreControl(&(TileInst[0][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[1][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[2][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[3][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[4][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[5][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[6][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[7][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[8][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[9][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[10][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[11][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[12][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[13][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[14][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[15][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[16][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[17][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[18][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[19][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[20][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[21][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[22][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[23][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[24][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[25][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[26][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[27][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[28][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[29][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[30][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[31][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[32][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[33][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[34][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[35][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[36][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[37][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[38][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[39][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[40][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[41][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[42][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[43][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[44][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[45][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[46][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[47][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[48][1]), XAIE_DISABLE, XAIE_ENABLE);
    XAieTile_CoreControl(&(TileInst[49][1]), XAIE_DISABLE, XAIE_ENABLE);
    if(cdo_debug)
    {
      //For debugging enable the cores and put them on halt state
	  XAieLib_print("Putting core(s) of graph my_graph on halt state for debugging...\n");
      XAieGbl_Write32((TileInst[0][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[1][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[2][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[3][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[4][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[5][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[6][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[7][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[8][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[9][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[10][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[11][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[12][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[13][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[14][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[15][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[16][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[17][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[18][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[19][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[20][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[21][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[22][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[23][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[24][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[25][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[26][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[27][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[28][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[29][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[30][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[31][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[32][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[33][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[34][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[35][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[36][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[37][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[38][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[39][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[40][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[41][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[42][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[43][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[44][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[45][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[46][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[47][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[48][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
      XAieGbl_Write32((TileInst[49][1]).TileAddr + XAIEGBL_CORE_DBGCTRL0, XAIEGBL_CORE_DBGCTRL0_DBGHLTBIT_MASK);
    }
    if(enable_cores)
    {
	XAieLib_print("Enabling core(s) of graph my_graph...\n");
    XAieTile_CoreControl(&(TileInst[0][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[1][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[2][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[3][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[4][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[5][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[6][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[7][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[8][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[9][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[10][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[11][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[12][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[13][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[14][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[15][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[16][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[17][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[18][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[19][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[20][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[21][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[22][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[23][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[24][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[25][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[26][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[27][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[28][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[29][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[30][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[31][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[32][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[33][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[34][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[35][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[36][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[37][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[38][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[39][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[40][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[41][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[42][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[43][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[44][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[45][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[46][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[47][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[48][1]), XAIE_ENABLE, XAIE_DISABLE);
    XAieTile_CoreControl(&(TileInst[49][1]), XAIE_ENABLE, XAIE_DISABLE);
    }

	return;
  }

  void my_graph_end(bool &is_graph_running)
  {

	XAieLib_print("Waiting for core(s) of graph my_graphto finish execution...\n");
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[0][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[0][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[1][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[1][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[2][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[2][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[3][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[3][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[4][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[4][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[5][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[5][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[6][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[6][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[7][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[7][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[8][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[8][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[9][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[9][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[10][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[10][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[11][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[11][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[12][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[12][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[13][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[13][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[14][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[14][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[15][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[15][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[16][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[16][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[17][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[17][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[18][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[18][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[19][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[19][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[20][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[20][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[21][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[21][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[22][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[22][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[23][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[23][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[24][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[24][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[25][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[25][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[26][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[26][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[27][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[27][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[28][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[28][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[29][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[29][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[30][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[30][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[31][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[31][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[32][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[32][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[33][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[33][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[34][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[34][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[35][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[35][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[36][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[36][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[37][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[37][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[38][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[38][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[39][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[39][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[40][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[40][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[41][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[41][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[42][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[42][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[43][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[43][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[44][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[44][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[45][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[45][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[46][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[46][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[47][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[47][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[48][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[48][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[49][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[49][1]), XAIE_DISABLE, XAIE_DISABLE);
    // reset graph enable after disabling all cores
    is_graph_running = false;

	XAieLib_print("core(s) are done executing...\n");

	XAieTile_PlIntfDownszrDisable(&(TileInst[7][0]),0);
    return;
  }


  void my_graph_end(unsigned int cycle_timeout, long long gr_enable_time, bool &is_graph_running)
  {
      if(int(cycle_timeout) >= 0)
	{

	  XAieLib_print("Waiting for core(s) of graph my_graph to complete  %d cycles...\n", cycle_timeout);
      // Adjust the cycle-timeout value
      unsigned int elapsed_time = ( XAieTile_CoreReadTimer(&(TileInst[0][1])) - gr_enable_time );
      if( int(cycle_timeout - elapsed_time) > 0 )
        (void)XAieTile_CoreWaitCycles(&(TileInst[0][1]), (cycle_timeout - elapsed_time));

	  XAieLib_print("core(s) execution timed out...\n");

	  XAieLib_print("Disabling core(s) of graph my_graph...\n");
      XAieTile_CoreControl(&(TileInst[0][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[1][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[2][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[3][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[4][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[5][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[6][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[7][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[8][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[9][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[10][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[11][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[12][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[13][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[14][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[15][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[16][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[17][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[18][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[19][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[20][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[21][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[22][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[23][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[24][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[25][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[26][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[27][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[28][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[29][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[30][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[31][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[32][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[33][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[34][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[35][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[36][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[37][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[38][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[39][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[40][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[41][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[42][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[43][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[44][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[45][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[46][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[47][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[48][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[49][1]), XAIE_DISABLE, XAIE_DISABLE);
      // reset graph enable after disabling all cores
      is_graph_running = false;
    }

	XAieTile_PlIntfDownszrDisable(&(TileInst[7][0]),0);
    return;
  }


 void my_graph_wait(bool &is_graph_running)
 {

	XAieLib_print("Waiting for core(s) of graph my_graphto finish execution...\n");
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[0][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[0][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[1][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[1][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[2][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[2][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[3][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[3][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[4][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[4][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[5][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[5][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[6][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[6][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[7][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[7][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[8][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[8][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[9][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[9][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[10][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[10][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[11][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[11][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[12][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[12][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[13][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[13][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[14][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[14][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[15][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[15][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[16][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[16][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[17][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[17][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[18][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[18][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[19][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[19][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[20][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[20][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[21][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[21][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[22][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[22][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[23][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[23][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[24][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[24][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[25][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[25][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[26][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[26][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[27][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[27][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[28][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[28][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[29][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[29][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[30][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[30][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[31][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[31][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[32][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[32][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[33][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[33][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[34][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[34][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[35][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[35][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[36][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[36][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[37][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[37][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[38][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[38][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[39][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[39][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[40][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[40][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[41][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[41][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[42][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[42][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[43][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[43][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[44][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[44][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[45][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[45][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[46][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[46][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[47][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[47][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[48][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[48][1]), XAIE_DISABLE, XAIE_DISABLE);
    while(!(unsigned)XAieTile_CoreWaitStatus(&(TileInst[49][1]), 0, XAIETILE_CORE_STATUS_DONE)); 
    XAieTile_CoreControl(&(TileInst[49][1]), XAIE_DISABLE, XAIE_DISABLE);
    // reset graph enable after disabling all cores
    is_graph_running = false;

	XAieLib_print("core(s) are done executing...\n");
    return;
  }


 void my_graph_wait(unsigned int cycle_timeout, long long gr_enable_time, bool &is_graph_running)
 {
      if(int(cycle_timeout) >= 0)
	{

	  XAieLib_print("Waiting for core(s) of graph my_graph to complete  %d cycles...\n", cycle_timeout);
      // Adjust the cycle-timeout value
      unsigned int elapsed_time = ( XAieTile_CoreReadTimer(&(TileInst[0][1])) - gr_enable_time );
      if( int(cycle_timeout - elapsed_time) > 0 )
        (void)XAieTile_CoreWaitCycles(&(TileInst[0][1]), (cycle_timeout - elapsed_time));

	  XAieLib_print("core(s) execution timed out...\n");

	  XAieLib_print("Disabling core(s) of graph my_graph...\n");
      XAieTile_CoreControl(&(TileInst[0][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[1][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[2][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[3][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[4][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[5][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[6][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[7][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[8][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[9][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[10][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[11][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[12][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[13][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[14][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[15][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[16][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[17][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[18][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[19][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[20][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[21][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[22][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[23][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[24][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[25][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[26][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[27][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[28][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[29][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[30][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[31][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[32][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[33][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[34][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[35][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[36][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[37][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[38][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[39][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[40][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[41][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[42][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[43][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[44][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[45][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[46][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[47][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[48][1]), XAIE_DISABLE, XAIE_DISABLE);
      XAieTile_CoreControl(&(TileInst[49][1]), XAIE_DISABLE, XAIE_DISABLE);
      // reset graph enable after disabling all cores
      is_graph_running = false;
    }
    return;
  }


  void my_graph_resume(long long& gr_enable_time, bool &is_graph_running)
  {

	XAieLib_print("Re-enabling core(s) of graph my_graph...\n");
    // Reset the graph timer
    gr_enable_time = XAieTile_CoreReadTimer(&(TileInst[0][1]));
    if (!XAieTile_CoreReadStatusDone(&(TileInst[0][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[0][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[1][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[1][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[2][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[2][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[3][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[3][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[4][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[4][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[5][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[5][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[6][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[6][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[7][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[7][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[8][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[8][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[9][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[9][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[10][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[10][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[11][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[11][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[12][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[12][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[13][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[13][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[14][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[14][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[15][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[15][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[16][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[16][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[17][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[17][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[18][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[18][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[19][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[19][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[20][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[20][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[21][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[21][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[22][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[22][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[23][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[23][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[24][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[24][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[25][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[25][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[26][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[26][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[27][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[27][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[28][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[28][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[29][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[29][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[30][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[30][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[31][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[31][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[32][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[32][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[33][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[33][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[34][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[34][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[35][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[35][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[36][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[36][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[37][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[37][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[38][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[38][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[39][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[39][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[40][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[40][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[41][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[41][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[42][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[42][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[43][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[43][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[44][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[44][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[45][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[45][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[46][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[46][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[47][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[47][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[48][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[48][1]), XAIE_ENABLE, XAIE_DISABLE);
    if (!XAieTile_CoreReadStatusDone(&(TileInst[49][1]))) //XAIE_ENABLE will clear Core_Done status bit
      XAieTile_CoreControl(&(TileInst[49][1]), XAIE_ENABLE, XAIE_DISABLE);
    // Set graph enable after re-enabling all cores
    is_graph_running = true;

  }

#ifndef __CDO__

  void cardano::graph::init()
  { 
	if (this == (cardano::graph *)(&my_graph))
	{
		my_graph_init();
	}
	return;
  }


  void cardano::graph::run()
  {
    #ifdef PS_ENABLE_AIE
 
	if (this == (cardano::graph *)(&my_graph))
	{
		my_graph_run(my_graph.enable_time, my_graph.is_running);
	}

    #endif

	return;
  }


  void cardano::graph::run(int test_iterations)
  { 
	if (this == (cardano::graph *)(&my_graph))
	{
		my_graph_run(test_iterations, my_graph.enable_time, my_graph.is_running);
	}
	return;
  }


  void cardano::graph::wait()
  { 
	if (this == (cardano::graph *)(&my_graph))
	{
		my_graph_wait(my_graph.is_running);
	}
	return;
  }


  void cardano::graph::wait(unsigned int cycle_timeout)
  { 
	if (this == (cardano::graph *)(&my_graph))
	{
		my_graph_wait(cycle_timeout, my_graph.enable_time, my_graph.is_running);
	}
	return;
  }


  void cardano::graph::resume()
  { 
	if (this == (cardano::graph *)(&my_graph))
	{
		my_graph_resume(my_graph.enable_time, my_graph.is_running);
	}
	return;
  }


  void cardano::graph::end()
  { 
	if (this == (cardano::graph *)(&my_graph))
	{
		my_graph_end(my_graph.is_running);
	}
	return;
  }


  void cardano::graph::end(unsigned int cycle_timeout)
  { 
	if (this == (cardano::graph *)(&my_graph))
	{
		my_graph_end(cycle_timeout, my_graph.enable_time, my_graph.is_running);
	}
	return;
  }

  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const cfloat* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match cfloat array type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const cfloat* value, size_t sz)
  {
    cardano::graph::update(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const cint16* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match cint16 array type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const cint16* value, size_t sz)
  {
    cardano::graph::update(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const cint32* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match cint32 array type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const cint32* value, size_t sz)
  {
    cardano::graph::update(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const float* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match float array type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const float* value, size_t sz)
  {
    cardano::graph::update(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const int16* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match int16 array type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const int16* value, size_t sz)
  {
    cardano::graph::update(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const int32* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match int32 array type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const int32* value, size_t sz)
  {
    cardano::graph::update(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const int64* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match int64 array type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const int64* value, size_t sz)
  {
    cardano::graph::update(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const int8* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match int8 array type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const int8* value, size_t sz)
  {
    cardano::graph::update(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const uint16* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match uint16 array type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const uint16* value, size_t sz)
  {
    cardano::graph::update(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const uint32* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match uint32 array type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const uint32* value, size_t sz)
  {
    cardano::graph::update(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const uint64* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match uint64 array type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const uint64* value, size_t sz)
  {
    cardano::graph::update(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const uint8* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match uint8 array type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, const uint8* value, size_t sz)
  {
    cardano::graph::update(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, cfloat value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match cfloat scalar type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, cfloat value)
  {
    cardano::graph::update(rtpPort, value, -1);
    return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, cint16 value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match cint16 scalar type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, cint16 value)
  {
    cardano::graph::update(rtpPort, value, -1);
    return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, cint32 value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match cint32 scalar type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, cint32 value)
  {
    cardano::graph::update(rtpPort, value, -1);
    return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, float value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match float scalar type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, float value)
  {
    cardano::graph::update(rtpPort, value, -1);
    return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, int16 value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match int16 scalar type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, int16 value)
  {
    cardano::graph::update(rtpPort, value, -1);
    return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, int32 value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match int32 scalar type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, int32 value)
  {
    cardano::graph::update(rtpPort, value, -1);
    return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, int64 value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match int64 scalar type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, int64 value)
  {
    cardano::graph::update(rtpPort, value, -1);
    return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, int8 value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match int8 scalar type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, int8 value)
  {
    cardano::graph::update(rtpPort, value, -1);
    return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, uint16 value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match uint16 scalar type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, uint16 value)
  {
    cardano::graph::update(rtpPort, value, -1);
    return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, uint32 value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match uint32 scalar type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, uint32 value)
  {
    cardano::graph::update(rtpPort, value, -1);
    return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, uint64 value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match uint64 scalar type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, uint64 value)
  {
    cardano::graph::update(rtpPort, value, -1);
    return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, uint8 value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::update: the data type of rtpPort does not match uint8 scalar type.\n";
  	return;
  }
  void cardano::graph::update(cardano::port<cardano::direction::in>& rtpPort, uint8 value)
  {
    cardano::graph::update(rtpPort, value, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, cfloat* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match cfloat array type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, cfloat* value, size_t sz)
  {
    cardano::graph::read(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, cint16* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match cint16 array type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, cint16* value, size_t sz)
  {
    cardano::graph::read(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, cint32* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match cint32 array type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, cint32* value, size_t sz)
  {
    cardano::graph::read(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, float* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match float array type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, float* value, size_t sz)
  {
    cardano::graph::read(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, int16* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match int16 array type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, int16* value, size_t sz)
  {
    cardano::graph::read(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, int32* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match int32 array type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, int32* value, size_t sz)
  {
    cardano::graph::read(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, int64* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match int64 array type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, int64* value, size_t sz)
  {
    cardano::graph::read(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, int8* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match int8 array type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, int8* value, size_t sz)
  {
    cardano::graph::read(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, uint16* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match uint16 array type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, uint16* value, size_t sz)
  {
    cardano::graph::read(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, uint32* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match uint32 array type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, uint32* value, size_t sz)
  {
    cardano::graph::read(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, uint64* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match uint64 array type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, uint64* value, size_t sz)
  {
    cardano::graph::read(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, uint8* value, size_t sz, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match uint8 array type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, uint8* value, size_t sz)
  {
    cardano::graph::read(rtpPort, value, sz, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, cfloat& value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match cfloat scalar type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, cfloat& value)
  {
    cardano::graph::read(rtpPort, value, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, cint16& value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match cint16 scalar type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, cint16& value)
  {
    cardano::graph::read(rtpPort, value, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, cint32& value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match cint32 scalar type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, cint32& value)
  {
    cardano::graph::read(rtpPort, value, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, float& value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match float scalar type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, float& value)
  {
    cardano::graph::read(rtpPort, value, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, int16& value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match int16 scalar type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, int16& value)
  {
    cardano::graph::read(rtpPort, value, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, int32& value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match int32 scalar type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, int32& value)
  {
    cardano::graph::read(rtpPort, value, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, int64& value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match int64 scalar type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, int64& value)
  {
    cardano::graph::read(rtpPort, value, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, int8& value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match int8 scalar type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, int8& value)
  {
    cardano::graph::read(rtpPort, value, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, uint16& value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match uint16 scalar type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, uint16& value)
  {
    cardano::graph::read(rtpPort, value, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, uint32& value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match uint32 scalar type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, uint32& value)
  {
    cardano::graph::read(rtpPort, value, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, uint64& value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match uint64 scalar type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, uint64& value)
  {
    cardano::graph::read(rtpPort, value, -1);
    return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, uint8& value, int selector)
  {  
  	std::cerr << "ERROR: cardano::graph::read: the data type of rtpPort does not match uint8 scalar type.\n";
  	return;
  }
  void cardano::graph::read(cardano::port<cardano::direction::inout>& rtpPort, uint8& value)
  {
    cardano::graph::read(rtpPort, value, -1);
    return;
  }
cardano::graph::graph() {impl= std::make_shared<GraphImpl>();}
cardano::RCGraph::RCGraph() {}
void cardano::RCGraph::as_alternative_graph() {}
#endif /* __CDO__*/



#if !defined(__CDO__)
// Kernel Stub Definition
  void OneInput(input_window_int32*,output_window_int32*,output_window_int32*) { /* Stub */ } 
  void OneOutput(input_window_int32*,input_window_int32*,output_window_int32*) { /* Stub */ } 
  void TwoInputs(input_window_int32*,input_window_int32*,output_window_int32*,output_window_int32*) { /* Stub */ } 
#endif
