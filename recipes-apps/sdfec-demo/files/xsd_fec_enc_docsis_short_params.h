
#ifndef XSD_FEC_ENC_DOCSIS_SHORT_PARAMS_H
#define XSD_FEC_ENC_DOCSIS_SHORT_PARAMS_H

#ifndef __linux__
#include "xsdfec.h"
#else
#include "sdfec_usr_intf.h"
#endif

typedef struct xsdfec_user_ldpc_code_params user_params;

u32 xsd_fec_enc_docsis_short_sc_table_size = 2;
u32 xsd_fec_enc_docsis_short_sc_table[2] = {
  0x0000cccc,
  0x0000000c
};
u32 xsd_fec_enc_docsis_short_la_table_size = 5;
u32 xsd_fec_enc_docsis_short_la_table[5] = {
  0x00000007,
  0x00000c07,
  0x00000b08,
  0x00000d07,
  0x00000c07
};
u32 xsd_fec_enc_docsis_short_qc_table_size = 82;
u32 xsd_fec_enc_docsis_short_qc_table[82] = {
  0x00020500,
  0x00010000,
  0x00020c02,
  0x00020e01,
  0x00020204,
  0x00020103,
  0x00022d06,
  0x00022505,
  0x00021808,
  0x00021a07,
  0x0002030a,
  0x00020009,
  0x0002220c,
  0x0002070d,
  0x00022e0e,
  0x00068a0f,
  0x00000000,
  0x00002301,
  0x00000102,
  0x00001a03,
  0x00000004,
  0x00000a05,
  0x00001006,
  0x00001007,
  0x00002208,
  0x00000409,
  0x0000020a,
  0x0002170b,
  0x0000000c,
  0x0000330d,
  0x00069410,
  0x0004310f,
  0x00000c00,
  0x00010000,
  0x00001602,
  0x00010000,
  0x00000304,
  0x00001c01,
  0x00003306,
  0x00002e03,
  0x00001908,
  0x00001005,
  0x0000130a,
  0x00000207,
  0x0000340c,
  0x00001d09,
  0x0000250e,
  0x0000120b,
  0x00042210,
  0x0006a711,
  0x00000000,
  0x00003301,
  0x00001002,
  0x00001f03,
  0x00000d04,
  0x00002705,
  0x00001b06,
  0x00002107,
  0x00000808,
  0x00001b09,
  0x0000350a,
  0x00000d0b,
  0x0000210e,
  0x0000340d,
  0x00068712,
  0x00042611,
  0x00002400,
  0x00000601,
  0x00000302,
  0x00003303,
  0x00000404,
  0x00001305,
  0x00000406,
  0x00002d07,
  0x00003008,
  0x00000909,
  0x0000160c,
  0x00000b0b,
  0x00002b0e,
  0x0000170d,
  0x00040e12,
  0x00068113
};
user_params xsd_fec_enc_docsis_short_params = {
  0x00000460, // N
  0x00000348, // K
  0x00000038, // P
  0x00000005, // NLayers
  0x00000052, // NQC
  0x0000002c, // NMQC
  0x0000000a, // NM
  0x00000001, // NormType
  0x00000000, // NoPacking
  0x00000000, // SpecialQC
  0x00000000, // NoFinalParity
  0x00000000, // MaxSchedule
  &xsd_fec_enc_docsis_short_sc_table[0],
  &xsd_fec_enc_docsis_short_la_table[0],
  &xsd_fec_enc_docsis_short_qc_table[0]
};

#endif
