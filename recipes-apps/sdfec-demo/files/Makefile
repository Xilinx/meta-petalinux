
APP = sdfec-demo

# Add any other object files to this list below
APP_OBJS = 
APP_OBJS += demo_test_drivers.o
APP_OBJS += main.o
APP_OBJS += xdata_source_top.o
APP_OBJS += xdata_source_top_sinit.o
APP_OBJS += xmonitor.o
APP_OBJS += xmonitor_sinit.o
APP_OBJS += xstats_top.o
APP_OBJS += xstats_top_sinit.o

CFLAGS += -std=gnu99
LDLIBS = -lm -lmetal -lsdfecusrintf

all: build

build: $(APP)

$(APP): $(APP_OBJS)
	$(CC) $(LDFLAGS) -o $@ $(APP_OBJS) $(LDLIBS)

clean:
	-rm -f $(APP) *.elf *.gdb *.o
