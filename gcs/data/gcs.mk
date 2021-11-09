# Copyright (c) 2002 Gran Telescopio de Canarias, S.A. (GRANTECAN)
# All Rights Reserved


# Description:
# Global makefile imported by all makefiles

# Environment variables used:
# - PLATFORM
# - MY_GCS
# - GCS
# - MK
# - TAO

# Makefile variables used:
# - OS_SRC from os.mk

optimize = 0
fast     = 0

ifeq (vx,$(findstring vx,$(PLATFORM)))
	debug = 0
else
	debug = 1
endif

include $(MK)/wrapper_macros.GNU
include $(MK)/macros.GNU
include $(MK)/rules.tao.GNU
include $(MK)/rules.common.GNU
include $(MK)/rules.nonested.GNU
include $(MK)/rules.local.GNU
include $(MK)/taoconfig.mk
include $(MK)/gslconfig.mk
include $(MK)/fitsioconfig.mk
include $(MK)/slaconfig.mk
include $(MK)/tcsPKconfig.mk
include $(MK)/wcsconfig.mk
include $(MK)/esdcan4config.mk
include $(MK)/snapperconfig.mk
include $(MK)/xpaconfig.mk
include $(MK)/sqliteconfig.mk
include $(MK)/modbusconfig.mk
include $(MK)/jsoncppconfig.mk
include $(MK)/mxml.mk
include $(MK)/googleTest.mk
include $(MK)/hDcamconfig.mk
include $(MK)/opencv.mk
include $(MK)/libusb.mk
include $(MK)/fastdds.mk



ifeq (solsun,$(PLATFORM))
include $(MK)/os.mk
endif

# Global makefile variable definitions:
SHELL    := /bin/ksh
CFLAGS   += $(PIC)            # Always Position Independent Code ON
ifeq (vx,$(PLATFORM))
	CPPFLAGS += -I. -Iidlc++/solgnu -I$(MY_GCS)/include -I$(MY_GCS)/include/solgnu -I$(GCS)/include  -I$(GCS)/include/solgnu
else
	CPPFLAGS += -I. -Iidlc++/$(PLATFORM) -I$(MY_GCS)/include -I$(MY_GCS)/include/$(PLATFORM) -I$(GCS)/include -I$(GCS)/include//$(PLATFORM)
endif
ifeq (solsun,$(PLATFORM))
CFLAGS   += -DSOLSUN
endif

ifeq (solgnu,$(PLATFORM))
CFLAGS   += -DSOLGNU
include $(MK)/mysqlconfig.mk
include $(MK)/jsoncppconfig.mk
endif

ifeq (linux,$(PLATFORM))
CFLAGS   += -DLINUX
include $(MK)/bsdconfig.mk
include $(MK)/mysqlconfig.mk
include $(MK)/jsoncppconfig.mk
include $(MK)/sqliteconfig.mk
include $(MK)/megaraconfig.mk
include $(MK)/curlconfig.mk
include $(MK)/geosconfig.mk
endif

# Global libraries
SSL_LIBS=-lArray -lArray_IO -lConfigFileMgr -lBasicTypes -lOSWrappers -lTrace
DSL_DEV_LIBS=-lCoordinator -lDCF -lSK -lDAF -lDGCSTypes -lTK -lTS -lTask -lPeriodicTask
DSLPRO_DEV_LIBS=-lCoordinator -lDCF -lDCFSim -lDSM -lSK -lDAF -lDAFPro -lTask -lPeriodicTask -lProcess -lDPhysicalQuantity -lDGCSTypes -lTK -lTS
DSL_SVR_LIBS=-lSK -lDAF -lDGCSTypes -lTK -lTS
CANF_LIBS= -lCANOpenDriveSim -lCANOpenMotorSim -lCANOpenPositionDrive -lCANOpenMotor -lCANOpenBaseProfile -lCANOpenVariable -lCANOpenLayerPDO -lCANOpenLayer -lCANOpenHandler -lCANUtil -lCAN4Driver $(NTCAN_LIBS)
CAN_LIBS= -lCANOpenNMotorsController $(CANF_LIBS)
DF_LIBS =-lDDPKFCorba -lRFCorba -lDPhysicalQuantityCorba
SF_COMMON_LIBS=-lNumericStruct -lAsynchronousCallGroupManager
SF_MEC_LIBS=-lMechanismSet -lMechanismProxy
SF_DET_LIBS=-lDetectorProxy
SF_LIBS=$(SF_MEC_LIBS) $(SF_DET_LIBS) $(SF_COMMON_LIBS)
INSTRUMENT_LIBS=-lInstrument -lAK -lInstrumentCorba -lObservingEngineCorba -lOECommonCorba -lDPhysicalQuantityCorba
DF_LIBS= -lPhysicalQuantity -lDPhysicalQuantity -lRF -lParserLibrary -lFilters -lDPKF_IO -lDPKF -lDDPKF
AG_DF_LIBS=-lAGObsResult -lAGTypes_IO -lAGRecipes -lAGFilters -lAGTypes -lDAGTypes -lCatalog -lDataDisplay $(DF_LIBS)


# Only .cpp and .c files are considered:
# Object files from the library's root directory:
NAME             := $(basename $(notdir $(shell pwd)))
C_CORBA_LIB_NAME := $(PLATFORM).O/lib$(NAME)Corba.so
S_CORBA_LIB_NAME := $(PLATFORM).O/lib$(NAME)CorbaSkel.so
SHARED_LIB_NAME  := $(PLATFORM).O/lib$(NAME).so
STATIC_LIB_NAME  := $(PLATFORM).O/lib$(NAME).a
BINARY_NAME      := $(PLATFORM).O/$(NAME)
LIBOBJS          := $(patsubst %.cpp,$(PLATFORM).O/%.o,$(wildcard *.cpp))
LIBOBJS_C        := $(patsubst %.c,$(PLATFORM).O/%.o,$(wildcard *.c))
LIBOBJS          += $(LIBOBJS_C)
LIBOBJS          += $(OS_OBJ)

INSBIN        = $(MY_GCS)/bin/$(PLATFORM)   # Default installation directory for executable files
FILES        := $(wildcard *.cpp)
FILES_AUX    := $(patsubst %.cpp,%.o,$(FILES))
PROCESSOBJS  := $(addprefix $(PLATFORM).O/,$(FILES_AUX))
OBJS_C       := $(patsubst %.c,$(PLATFORM).O/%.o,$(wildcard *.c))
PROCESSOBJS  += $(OBJS_C)


# If the environment variable LD_LIBRARY_PATH is well assigned (it should)
# there is no need to supply -L directives. This is only valid with SUN C++.
LDFLAGS += -L$(MY_GCS)/lib/$(PLATFORM) -L$(GCS)/lib/$(PLATFORM) \
	   $(TAO_LDFLAGS) $(FITSIO_LDFLAGS) $(ESDCAN4_LDFLAGS) \
	   $(SNAPPER_LDFLAGS) $(WCS_LDFLAGS) $(SLA_LDFLAGS) \
	   $(GSL_LDFLAGS) $(XPA_LDFLAGS) $(MYSQL_LDFLAGS) \
	   $(JSON_LDFLAGS) $(SQLITE_LDFLAGS) $(BSD_LDFLAGS) $(MXML_LDFLAGS) $(CURL_LDFLAGS) $(GEOS_LDFLAGS) $(HDCAM_LDFLAGS) $(OPENCV_LDFLAGS) $(MEGARA_LDFLAGS)

# ACE specific variables definitions:
ifeq ($(trace),0)
  override trace =
endif # trace

ifdef trace
  CPPFLAGS += -DACE_NTRACE=0
endif


# IDL specific variables definitions:
# Flags for the IDL compiler
# -as --> Silence any diagnostic output for anonymous types (default). Anonymous types are deprecated by the OMG spec. This behavior can be selected globally by defining IDL_ANON_SILENT in config.h. It may then be overridden locally by -aw or -ae
# -Yp,path --> defines location of preprocessor
# -g <gperf_path> --> Path for the GPERF program. Default is $ACE_ROOT/bin/ace_gperf
# -Sg --> Disable generation of unique preprocessor guards for generated header files. The guards will still be generated, but without the unique random extension.	This option is useful when a system has several versions of a generated header file, and only the newest version is to be included by the preprocessor. The default behavior will generate a unique extension for each version, subverting the desired function of the preprocessor in such a system.
#

ifeq (linux,$(PLATFORM))
override TAO_IDLFLAGS += -Sg -as -Yp,$(CPP) -I$(MY_GCS)/include \
                  -I$(MY_GCS)/include/$(PLATFORM) -I$(GCS)/include -I$(GCS)/include/$(PLATFORM) -I$(TAO)/include/idl -g gperf -o idlc++/$(PLATFORM)
else
override TAO_IDLFLAGS += -Yp,$(CPP) -I$(MY_GCS)/include \
                 -I$(MY_GCS)/include/$(PLATFORM) -I$(GCS)/include -I$(GCS)/include/$(PLATFORM) -I$(TAO)/include/idl -Sc -g gperf -o idlc++/$(PLATFORM)
endif


IDL_IDL_FILES := $(wildcard *.idl)
IDL_FILES     := $(basename $(IDL_IDL_FILES))
AUX           := $(addsuffix S.cpp, $(IDL_FILES)) $(addsuffix C.cpp, $(IDL_FILES))
AUX_STUB      := $(addsuffix C.cpp, $(IDL_FILES))
ifeq (vx,$(PLATFORM))

IDL_CPP_FILES := $(addprefix idlc++/solgnu/, $(AUX) )
IDL_OBJS      := $(patsubst %.cpp,idlc++/solgnu/$(PLATFORM).O/%.o,$(AUX))
IDL_STUBS     := $(patsubst %.cpp,idlc++/solgnu/$(PLATFORM).O/%.o,$(AUX_STUB)) 
IDL_CPP_SKEL_FILES := $(addprefix idlc++/solgnu, $(addsuffix S.cpp, $(IDL_FILES)) )
else
IDL_CPP_FILES := $(addprefix idlc++/$(PLATFORM)/, $(AUX) )
IDL_OBJS      := $(patsubst %.cpp,idlc++/$(PLATFORM)/$(PLATFORM).O/%.o,$(AUX))
IDL_STUBS     := $(patsubst %.cpp,idlc++/$(PLATFORM)/$(PLATFORM).O/%.o,$(AUX_STUB)) 
IDL_CPP_SKEL_FILES := $(addprefix idlc++/$(PLATFORM), $(addsuffix S.cpp, $(IDL_FILES)) )

endif

# Target rules definition:
process: $(BINARY_NAME)

corbalibC: $(C_CORBA_LIB_NAME)

corbalibS: $(S_CORBA_LIB_NAME)

sharedlib: $(SHARED_LIB_NAME)

staticlib: $(STATIC_LIB_NAME)

relink:
	@rm -f $(BINARY_NAME)
	@mk --no-print-directory

showidlvars:
	@print "IDL_OBJS......... $(IDL_OBJS)"
	@print "IDL_IDL_FILES.... $(IDL_IDL_FILES)"
	@print "IDL_STUBS........ $(IDL_STUBS)"
	@print "IDL_FILES........ $(IDL_FILES)"
	@print "IDL_CPP_FILES.... $(IDL_CPP_FILES)"

showgcsvars:
	@print "PLATFORM......... $(PLATFORM)"
	@print "MK............... $(MK)"
	@print "NAME............. $(NAME)"
	@print "LD_LIBRARY_PATH.. $(LD_LIBRARY_PATH)"
	@print "GCS.............. $(GCS)"
	@print "MY_GCS........... $(MY_GCS)"
	@print "MY_INCLUDE....... $(MY_INCLUDE)"
	@print "MY_LIB........... $(MY_LIB)"
	@print "MY_BIN........... $(MY_BIN)"
	@print "MY_DOC........... $(MY_DOC)"

showcompilevars:
	@print "CC............... $(CC)" 
	@print "CXX.............. $(CXX)"
	@print "CC_VERSION....... $(CC_VERSION)"
	@print "CFLAGS........... $(CFLAGS)"
	@print "CPPFLAGS......... $(CPPFLAGS)"
	@print "BINARY_NAME...... $(BINARY_NAME)"
	@print "C_CORBA_LIB_NAME. $(C_CORBA_LIB_NAME)"
	@print "S_CORBA_LIB_NAME. $(S_CORBA_LIB_NAME)"
	@print "SHARED_LIB_NAME.. $(SHARED_LIB_NAME)"
	@print "STATIC_LIB_NAME.. $(STATIC_LIB_NAME)"
	@print "LIBS............. $(LIBS)"
	@print "LDFLAGS.......... $(LDFLAGS)"
	@print "LDLIBS........... $(LDLIBS)"
	@print "LIBOBJS.......... $(LIBOBJS)"
	@print "LIBOBJS_C........ $(LIBOBJS_C)"
	@print "PROCESSOBJS...... $(PROCESSOBJS)"
	@print "IDL_OBJS......... $(IDL_OBJS)"
	@print "OS_OBJ........... $(OS_OBJ)"
	@print "INSBIN........... $(INSBIN)"
	@print "FILES............ $(FILES)"
	@print "FILES_AUX........ $(FILES_AUX)"
	@print "PURIFY........... $(PURIFY)"
	@print "IDL_CPP_FILES.... $(IDL_CPP_FILES)"
	@print "ACE_CC........... $(ACE_CC)"
	@print "MODULE_LIBS...... $(MODULE_LIBS)"

showallvars: showgcsvars showidlvars showcompilevars
