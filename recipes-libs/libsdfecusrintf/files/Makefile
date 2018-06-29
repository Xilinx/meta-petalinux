
APP = sdfecusrintf

# Add any other object files to this list below
LIB_OBJS = 
LIB_OBJS += sdfec_usr_intf.o

LIBSOURCES=*.c
OUTS = *.o
NAME := sdfecusrintf
MAJOR = 1.0
MINOR = 1
VERSION = $(MAJOR).$(MINOR)

LDLIBS = 

all: lib$(NAME).so

lib$(NAME).so.$(VERSION): $(OUTS)
	$(CC) $(LDFLAGS) $(OUTS) -shared -Wl,-soname,lib$(NAME).so.$(MAJOR) -o lib$(NAME).so.$(VERSION)

lib$(NAME).so: lib$(NAME).so.$(VERSION)
	rm -f lib$(NAME).so.$(MAJOR) lib$(NAME).so
	ln -s lib$(NAME).so.$(VERSION) lib$(NAME).so.$(MAJOR)
	ln -s lib$(NAME).so.$(MAJOR) lib$(NAME).so

%.o: %.c
	$(CC) $(CFLAGS) -c -fPIC $(LIBSOURCES)

clean:
	rm -rf *.o *.so *.so.*

