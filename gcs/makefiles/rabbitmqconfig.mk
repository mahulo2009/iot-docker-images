# Copyright (c) 2021 Gran Telescopio de Canarias, S.A. (GRANTECAN)
# All Rights Reserved


# Description:
# Definitions for rabbitmq-c library

# Environment variables used:
# - GCS
# - PLATFORM

ifeq ($(PLATFORM),linux)
	CPPFLAGS += -I$(EXT)/rabbitmq_c_0.11.0/include
	RABBITMQ_C_LDFLAGS += -L$(EXT)/rabbitmq_c_0.11.0/lib/$(PLATFORM)
endif

RABBITMQC_LIBS += $(RABBITMQ_C_LDFLAGS) -lrabbitmq

