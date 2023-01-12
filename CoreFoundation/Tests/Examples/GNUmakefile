include $(GNUSTEP_MAKEFILES)/common.make

TOOL_NAME = plconvert date_test PrefsExample3
plconvert_OBJC_FILES = plconvert.m
date_test_OBJC_FILES = date_test.m
# PrefsExample2_OBJC_FILES = PrefsExample2.m # Requires Carbon
PrefsExample3_OBJC_FILES = PrefsExample3.m
# CFFTPSample_OBJC_FILES = CFFTPSample.m # Requires CoreServices

ADDITIONAL_TOOL_LIBS += -lCoreFoundation
ADDITIONAL_OBJC_FLAGS += -fconstant-cfstrings

include $(GNUSTEP_MAKEFILES)/tool.make