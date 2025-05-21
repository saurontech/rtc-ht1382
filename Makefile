# Comment/uncomment the following line to enable/disable debugging
#DEBUG = y

# Add your debugging flag (or not) to ccflags.
ifeq ($(DEBUG),y)
  DEBFLAGS = -O -g -DSCULLV_DEBUG # "-O" is needed to expand inlines
else
  DEBFLAGS = -O2
endif
ifndef $(LDDINC)                                                                
  LDDINC:=$(shell pwd)
endif
ccflags-y += $(DEBFLAGS)
ccflags-y += -I$(LDDINC)


ifneq ($(KERNELRELEASE),)

rtc_ht1382-objs := rtc-ht1382.o

obj-m	:= rtc_ht1382.o

else

KERNELDIR ?= /lib/modules/$(shell uname -r)/build
PWD       := $(shell pwd)

modules:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) LDDINC=$(PWD) modules

endif

clean:
	rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c .tmp_versions *.symvers *.order *.a *.mod *.dwo
	find ./legacy -name '*.o' -exec rm {} \;
	find ./legacy -name '*.dwo' -exec rm {} \;
	find ./legacy -name '*.cmd' -exec rm {} \;

depend .depend dep:
	$(CC) -M *.c > .depend

ifeq (.depend,$(wildcard .depend))
include .depend
endif
