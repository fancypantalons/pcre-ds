#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------
ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

include $(DEVKITARM)/ds_rules

#---------------------------------------------------------------------------------
BUILD		:= build

ARM9SOURCES :=	source/arm9
ARM7SOURCES :=	

DATESTRING	:=	$(shell date +%Y)$(shell date +%m)$(shell date +%d)

export PATH		:=	$(DEVKITARM)/bin:$(PATH)

export BASEDIR	:=	$(CURDIR)
export LIBDIR	:=	$(BASEDIR)/lib
export DEPENDS	:=	$(BASEDIR)/deps
export INCDIR	:=	$(BASEDIR)/include
export BUILDDIR	:=	$(BASEDIR)/$(BUILD)

ARM9CFILES	:=	$(foreach dir,$(ARM9SOURCES),$(notdir $(wildcard $(dir)/*.c)))
ARM9SFILES	:=	$(foreach dir,$(ARM9SOURCES),$(notdir $(wildcard $(dir)/*.s)))
ARM9BINFILES	:=	$(foreach dir,$(ARM9SOURCES),$(notdir $(wildcard $(dir)/*.bin)))

export ARM9_VPATH	:=	$(foreach dir,$(ARM9SOURCES),$(BASEDIR)/$(dir))

export ARM9OBJS :=	$(ARM9BINFILES:.bin=.o) $(ARM9CFILES:.c=.o) $(ARM9SFILES:.s=.o)
export ARM9INC	:=	-I$(BUILDDIR)/arm9

export ARCH	:=	-mthumb -mthumb-interwork

export ARM9FLAGS	:=	$(ARCH) -march=armv5te -mtune=arm946e-s -DARM9

export BASEFLAGS	:=	-g -Wall -O2\
				-fomit-frame-pointer\
				-ffast-math \
				-I$(INCDIR)


.PHONY:	all dist docs clean lib/libpcre9.a

#---------------------------------------------------------------------------------
all:	lib/libpcre9.a
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
lib/libpcre9.a: lib $(DEPENDS)/arm9 $(BUILD)/arm9
#---------------------------------------------------------------------------------
	@$(MAKE) -C $(BUILD)/arm9 -f $(BASEDIR)/Makefile.arm9
#---------------------------------------------------------------------------------
$(BUILD)/arm9:
#---------------------------------------------------------------------------------
	mkdir -p $@
#---------------------------------------------------------------------------------
$(DEPENDS)/arm9:
#---------------------------------------------------------------------------------
	mkdir -p $@/arm9

#---------------------------------------------------------------------------------
lib:
#---------------------------------------------------------------------------------
	mkdir -p lib

#---------------------------------------------------------------------------------
clean:
#---------------------------------------------------------------------------------
	rm -fr $(DEPENDS) $(BUILD) *.bz2 
