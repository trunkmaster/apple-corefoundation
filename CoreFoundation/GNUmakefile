include $(GNUSTEP_MAKEFILES)/common.make

LIBRARY_NAME = libCoreFoundation
# Base.subproj
libCoreFoundation_OBJC_FILES += Base.subproj/CFBase.m Base.subproj/CFFileUtilities.m Base.subproj/CFKnownLocations.m Base.subproj/CFPlatform.m Base.subproj/CFRuntime.m Base.subproj/CFSortFunctions.m Base.subproj/CFSystemDirectories.m Base.subproj/CFUtilities.m Base.subproj/CFUUID.m Base.subproj/CFWindowsUtilities.m
libCoreFoundation_HEADER_FILES_DIR = ./Base.subproj
libCoreFoundation_HEADER_FILES_INSTALL_DIR = CoreFoundation
libCoreFoundation_HEADER_FILES = CFAsmMacros.h CFAvailability.h CFBase.h CFByteOrder.h CFInternal.h CFKnownLocations.h CFLocking.h CFLogUtilities.h CFOverflow.h CFPriv.h CFRuntime.h CFRuntime_Internal.h CFUtilities.h CFUUID.h CoreFoundation.h CoreFoundation_Prefix.h ForFoundationOnly.h ForSwiftFoundationOnly.h

libCoreFoundation_INCLUDE_DIRS += -I./Headers
libCoreFoundation_OBJCFLAGS	+= -DCF_BUILDING_CF

include $(GNUSTEP_MAKEFILES)/library.make