
APP = sdfec-multi-ldpc-codes

# Add any other object files to this list below
APP_OBJS = 
APP_OBJS += sdfec_multi_ldpc_codes.o
APP_OBJS += xmonitor.o
APP_OBJS += xstats_top.o
APP_OBJS += xdata_source_top.o
APP_OBJS += tstb_drivers.o
APP_OBJS += xsd_fec_dec_docsis_long_params.o
APP_OBJS += xsd_fec_dec_docsis_medium_params.o
APP_OBJS += xsd_fec_dec_docsis_short_params.o
APP_OBJS += xsd_fec_enc_docsis_long_params.o
APP_OBJS += xsd_fec_enc_docsis_medium_params.o
APP_OBJS += xsd_fec_enc_docsis_short_params.o
APP_OBJS += usr_params.o

CFLAGS += -std=gnu99
LDLIBS = -lm -lmetal -lsdfecusrintf

all: build

build: $(APP)

$(APP): $(APP_OBJS)
	$(CC) $(LDFLAGS) -o $@ $(APP_OBJS) $(LDLIBS)

clean:
	-rm -f $(APP) *.elf *.gdb *.o
