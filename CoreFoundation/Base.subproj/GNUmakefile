include $(GNUSTEP_MAKEFILES)/common.make

LIBRARY_NAME = libCoreFoundation
# Base.subproj
libCoreFoundation_HEADER_FILES = CFAsmMacros.h CFAvailability.h CFBase.h CFByteOrder.h CFInternal.h CFKnownLocations.h CFLocking.h CFLogUtilities.h CFOverflow.h CFPriv.h CFRuntime.h CFRuntime_Internal.h CFUtilities.h CFUUID.h CoreFoundation.h CoreFoundation_Prefix.h ForFoundationOnly.h ForSwiftFoundationOnly.h
libCoreFoundation_HEADER_FILES_INSTALL_DIR = CoreFoundation
libCoreFoundation_OBJC_FILES += CFBase.m CFFileUtilities.m CFKnownLocations.m CFPlatform.m CFRuntime.m CFSortFunctions.m CFSystemDirectories.m CFUtilities.m CFUUID.m CFWindowsUtilities.m
libCoreFoundation_INCLUDE_DIRS += -I../Headers
libCoreFoundation_OBJCFLAGS	+= -DCF_BUILDING_CF -DINCLUDE_OBJC -Wno-unused-function

# Set up libdispatch
libCoreFoundation_OBJCFLAGS	+= -D__HAS_DISPATCH__
libCoreFoundation_LIBRARIES_DEPEND_UPON += -ldispatch

include $(GNUSTEP_MAKEFILES)/library.make