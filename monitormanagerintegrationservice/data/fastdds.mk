# Copyright (c) 2013 Gran Telescopio de Canarias, S.A. (GRANTECAN)
# All Rights Reserved


# Description:
# Definitions for fastdds library

# Environment variables used:
# - GCS
# - PLATFORM


CPPFLAGS += -I/usr/local/include/fastdds -I/usr/local/include/fastrtps

FASTDDS_LDFLAGS  = -L/usr/local/lib
FASTDDS_LIBS     += $(FASTDDS_LDFLAGS) -lfastrtps

