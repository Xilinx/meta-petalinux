
#ifndef XSD_FEC_ENC_DOCSIS_LONG_PARAMS_H
#define XSD_FEC_ENC_DOCSIS_LONG_PARAMS_H

#ifndef __linux__
#include "xsdfec.h"
#else
#include "sdfec_usr_intf.h"
#endif

typedef struct xsdfec_user_ldpc_code_params user_params;

extern u32 xsd_fec_enc_docsis_long_sc_table_size;
extern u32 xsd_fec_enc_docsis_long_sc_table[2];
extern u32 xsd_fec_enc_docsis_long_la_table_size;
extern u32 xsd_fec_enc_docsis_long_la_table[5];
extern u32 xsd_fec_enc_docsis_long_qc_table_size ;
extern u32 xsd_fec_enc_docsis_long_qc_table[169];
extern user_params xsd_fec_enc_docsis_long_params;

#endif
