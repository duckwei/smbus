#
# This file and its contents are supplied under the terms of the
# Common Development and Distribution License ("CDDL"), version 1.0.
# You may only use this file in accordance with the terms of version
# 1.0 of the CDDL.
#
# A full copy of the text of the CDDL should have accompanied this
# source.  A copy of the CDDL is also available via the Internet at
# http://www.illumos.org/license/CDDL.
#

#
# Copyright 2011 Grigale Ltd.  All rights reserved.
#

.KEEP_STATE:

SRCS		= smbus.c
OBJ_DIR32	= obj32
OBJ_DIR64	= obj64
OBJ_FILES32	= $(SRCS:%.c=$(OBJ_DIR32)/%.o)
OBJ_FILES64	= $(SRCS:%.c=$(OBJ_DIR64)/%.o)

OBJ_DIRS	= $(OBJ_DIR32) $(OBJ_DIR64)

TARGET32	= $(OBJ_DIR32)/smbus
TARGET64	= $(OBJ_DIR64)/smbus
TARGETS		= $(TARGET32) $(TARGET64)

MACH32		= -m32
MACH64		= -m64 -xmodel=kernel

CFLAGS_KERNEL	= -D_KERNEL
CFLAGS_COMMON	= -c -O0
CFLAGS32	= $(CFLAGS_COMMON) $(CFLAGS_KERNEL) $(MACH32)
CFLAGS64	= $(CFLAGS_COMMON) $(CFLAGS_KERNEL) $(MACH64)

LDFLAGS		= -dy -r

MKDIR		= mkdir
CP		= cp

all:	$(OBJ_DIRS) $(TARGETS)

$(OBJ_DIRS):
	$(MKDIR) $@

$(TARGET32):	$(OBJ_FILES32)
	$(LD) $(LDFLAGS) -o $@ $(OBJ_FILES32)

$(TARGET64):	$(OBJ_FILES64)
	$(LD) $(LDFLAGS) -o $@ $(OBJ_FILES64)

$(OBJ_DIR32)/%.o:	%.c
	$(CC) $(CFLAGS32) -o $@ $<

$(OBJ_DIR64)/%.o:	%.c
	$(CC) $(CFLAGS64) -o $@ $<

clean:
	$(RM) $(OBJ_FILES32) $(OBJ_FILES64) $(TARGETS)


install:
	$(CP) $(TARGET32) /usr/kernel/drv
	$(CP) $(TARGET64) /usr/kernel/drv/amd64

add_drv:
	add_drv -i '"pciclass,0c0500"' -vn smbus
