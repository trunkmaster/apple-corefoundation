include $(GNUSTEP_MAKEFILES)/common.make

BUNDLE_NAME = CFBridgingTests
CFBridgingTests_OBJC_FILES = \
	NSCFLocale-Tests.m NSCFString-Tests.m NSCFDictionary-Tests.m NSCFArray-Tests.m
CFBridgingTests_OBJC_LIBS = -lCoreFoundation
CFBridgingTests_LIB_DIRS = -L../../../obj
CFBridgingTests_INCLUDE_DIRS = -I../../../Headers

include $(GNUSTEP_MAKEFILES)/bundle.make

check::
	LD_LIBRARY_PATH=${PWD}/../../../obj:${LD_LIBRARY_PATH} xctest CFBridgingTests.bundle

.PHONY: gdbcheck
gdbcheck::
	LD_LIBRARY_PATH=${PWD}/../../../obj:${LD_LIBRARY_PATH} gdb --args xctest CFBridgingTests.bundle