# Copyright (c) 2021 Gran Telescopio de Canarias, S.A. (GRANTECAN)
# All Rights Reserved


# Description:
# Definitions for yaml-cpp library

# Environment variables used:
# - GCS
# - PLATFORM

ifeq ($(PLATFORM),linux)
	CPPFLAGS += -I$(EXT)/yamlcpp_0.7.0/include
	YAMLCPP_LDFLAGS += -L$(EXT)/yamlcpp_0.7.0/lib/$(PLATFORM)
endif

YAMLCPP_LIBS     += $(YAMLCPP_LDFLAGS) -lyaml-cpp
