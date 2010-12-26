EE_LIB_DIR = lib
EE_INC_DIR = include
EE_SRC_DIR = src

EE_LIB = $(EE_LIB_DIR)/libSMSCDVD.a
EE_INCS = -I./include
EE_OBJS = $(EE_SRC_DIR)/SMS_CDDA.o $(EE_SRC_DIR)/SMS_CDVD.o
EE_LIBS = -lc

all: $(EE_LIB_DIR) $(EE_LIB)

$(EE_LIB_DIR) : 
	mkdir -p $(EE_LIB_DIR)

install: all
	mkdir -p $(DESTDIR)$(PS2SDK)/ports/include
	mkdir -p $(DESTDIR)$(PS2SDK)/ports/lib
	cp -f $(EE_LIB) $(DESTDIR)$(PS2SDK)/ports/lib
	cp -f $(EE_INC_DIR)/SMS_CDDA.h $(DESTDIR)$(PS2SDK)/ports/include
	cp -f $(EE_INC_DIR)/SMS_CDVD.h $(DESTDIR)$(PS2SDK)/ports/include

clean:
	/bin/rm -rf $(EE_OBJS) $(EE_LIB) $(EE_LIB_DIR)

include $(PS2SDK)/samples/Makefile.pref
include $(PS2SDK)/samples/Makefile.eeglobal
