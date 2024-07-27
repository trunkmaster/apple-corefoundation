include $(GNUSTEP_MAKEFILES)/common.make

LIBRARY_NAME = libCoreFoundation

# AppServices.subproj/CFUserNotification.m and RunLoop.subproj/CFMachPort_Lifetime.m, RunLoop.subproj/CFMessagePort.m require a Mach kernel.
# Collections.subproj/CFBasicHashFindBucket.m is meant to be included, but it's a source file.
libCoreFoundation_OBJC_FILES += \
	Base.subproj/CFBase.m Base.subproj/CFFileUtilities.m Base.subproj/CFKnownLocations.m \
	Base.subproj/CFPlatform.m Base.subproj/CFRuntime.m Base.subproj/CFSortFunctions.m \
	Base.subproj/CFSystemDirectories.m Base.subproj/CFUtilities.m Base.subproj/CFUUID.m \
	Base.subproj/CFVersion.m Base.subproj/CFWindowsUtilities.m \
	\
	Base.subproj/NSCFType.m \
	\
	Collections.subproj/CFArray.m Collections.subproj/CFBag.m \
	Collections.subproj/CFBasicHash.m Collections.subproj/CFBinaryHeap.m \
	Collections.subproj/CFBitVector.m Collections.subproj/CFData.m \
	Collections.subproj/CFDictionary.m Collections.subproj/CFSet.m \
	Collections.subproj/CFStorage.m Collections.subproj/CFTree.m \
	\
	Collections.subproj/NSCFCollectionSupport.m \
	Collections.subproj/NSCFDictionary.m Collections.subproj/NSCFArray.m \
	\
	Error.subproj/CFError.m \
	\
	Locale.subproj/CFCalendar_Enumerate.m Locale.subproj/CFCalendar.m \
	Locale.subproj/CFDateComponents.m Locale.subproj/CFDateFormatter.m \
	Locale.subproj/CFDateIntervalFormatter.m Locale.subproj/CFDateInterval.m \
	Locale.subproj/CFLocaleIdentifier.m Locale.subproj/CFLocaleKeys.m \
	Locale.subproj/CFLocale.m Locale.subproj/CFNumberFormatter.m \
	\
	Locale.subproj/NSCFLocale.m \
	\
	NumberDate.subproj/CFBigNumber.m NumberDate.subproj/CFDate.m \
	NumberDate.subproj/CFNumber.m NumberDate.subproj/CFTimeZone.m \
	\
	Parsing.subproj/CFBinaryPList.m Parsing.subproj/CFOldStylePList.m \
	Parsing.subproj/CFPropertyList.m Parsing.subproj/CFXMLInterface.m \
	\
	PlugIn.subproj/CFBundle_Binary.m PlugIn.subproj/CFBundle_DebugStrings.m \
	PlugIn.subproj/CFBundle_Executable.m PlugIn.subproj/CFBundle_Grok.m \
	PlugIn.subproj/CFBundle_InfoPlist.m PlugIn.subproj/CFBundle_Locale.m \
	PlugIn.subproj/CFBundle.m PlugIn.subproj/CFBundle_Main.m \
	PlugIn.subproj/CFBundle_ResourceFork.m PlugIn.subproj/CFBundle_Resources.m \
	PlugIn.subproj/CFBundle_SplitFileName.m PlugIn.subproj/CFBundle_Strings.m \
	PlugIn.subproj/CFBundle_Tables.m PlugIn.subproj/CFPlugIn.m \
	\
	Preferences.subproj/CFApplicationPreferences.m Preferences.subproj/CFPreferences.m \
	Preferences.subproj/CFXMLPreferencesDomain.m \
	\
	RunLoop.subproj/CFRunLoop.m RunLoop.subproj/CFSocket.m \
	\
	Stream.subproj/CFConcreteStreams.m Stream.subproj/CFSocketStream.m Stream.subproj/CFStream.m \
	Stream.subproj/CFFileDescriptor.m \
	\
	StringEncodings.subproj/CFBuiltinConverters.m StringEncodings.subproj/CFICUConverters.m \
	StringEncodings.subproj/CFPlatformConverters.m \
	StringEncodings.subproj/CFStringEncodingConverter.m \
	StringEncodings.subproj/CFStringEncodingDatabase.m StringEncodings.subproj/CFUniChar.m \
	StringEncodings.subproj/CFUnicodeDecomposition.m StringEncodings.subproj/CFUnicodePrecomposition.m \
	\
	String.subproj/CFAttributedString.m String.subproj/CFBurstTrie.m String.subproj/CFCharacterSet.m \
	String.subproj/CFRegularExpression.m String.subproj/CFRunArray.m String.subproj/CFStringEncodings.m \
	String.subproj/CFString.m String.subproj/CFStringScanner.m String.subproj/CFStringTransform.m \
	String.subproj/CFStringUtilities.m \
	\
	String.subproj/NSCFString.m \
	\
	URL.subproj/CFURLAccess.m URL.subproj/CFURLComponents.m URL.subproj/CFURLComponents_URIParser.m \
	URL.subproj/CFURL.m URL.subproj/CFURLSessionInterface.m

libCoreFoundation_HEADER_FILES_DIR = Headers/CoreFoundation
libCoreFoundation_HEADER_FILES_INSTALL_DIR = CoreFoundation
libCoreFoundation_HEADER_FILES = CFArray.h CFAsmMacros.h CFAttributedString.h \
	CFAttributedStringPriv.h CFAvailability.h CFBag.h CFBase.h CFBasicHash.h \
	CFBigNumber.h CFBinaryHeap.h CFBitVector.h CFBundle_BinaryTypes.h CFBundle.h \
	CFBundle_Internal.h CFBundlePriv.h CFBundle_SplitFileName.h CFBurstTrie.h \
	CFByteOrder.h CFCalendar.h CFCalendar_Internal.h CFCharacterSet.h CFCharacterSetPriv.h \
	CFCollections_Internal.h CFData.h CFDateComponents.h CFDateFormatter.h \
	CFDateFormatter_Private.h CFDate.h CFDateIntervalFormatter.h CFDateInterval.h \
	CFDictionary.h CFError.h CFError_Private.h CFFileDescriptor.h CFICUConverters.h \
	CFICULogging.h CFInternal.h CFKnownLocations.h CFLocale.h CFLocaleInternal.h CFLocale_Private.h \
	CFLocking.h CFLogUtilities.h CFMachPort.h CFMachPort_Internal.h CFMachPort_Lifetime.h \
	CFMessagePort.h CFNotificationCenter.h CFNumberFormatter.h CFNumber.h CFNumber_Private.h \
	CFOverflow.h CFPlugInCOM.h CFPlugIn_Factory.h CFPlugIn.h CFPreferences.h CFPriv.h \
	CFPropertyList.h CFPropertyList_Private.h CFRegularExpression.h CFRunArray.h \
	CFRunLoop.h CFRuntime.h CFRuntime_Internal.h CFSet.h CFSocket.h CFStorage.h \
	CFStreamAbstract.h CFStream.h CFStreamInternal.h CFStreamPriv.h CFStringDefaultEncoding.h \
	CFStringEncodingConverterExt.h CFStringEncodingConverter.h CFStringEncodingConverterPriv.h \
	CFStringEncodingDatabase.h CFStringEncodingExt.h CFString.h CFString_Internal.h \
	CFStringLocalizedFormattingInternal.h CFTimeZone.h CFTree.h CFUniChar.h CFUniCharPriv.h \
	CFUnicodeDecomposition.h CFUnicodePrecomposition.h CFURLAccess.h CFURLComponents.h \
	CFURLComponents_Internal.h CFURL.h CFURL.inc.h CFURLPriv.h CFURLSessionInterface.h \
	CFUserNotification.h CFUtilities.h CFUUID.h CFXMLInterface.h CoreFoundation.h \
	CoreFoundation_Prefix.h ForFoundationOnly.h ForSwiftFoundationOnly.h GSCFInternal.h \
	TargetConditionals.h BridgeHelpers.h \
	\
	NSCFLocale.h NSCFString.h NSCFType.h NSCFDictionary.h NSCFArray.h

libCoreFoundation_INCLUDE_DIRS += -I./Headers
libCoreFoundation_OBJCFLAGS	+= -DCF_BUILDING_CF -DINCLUDE_OBJC -Wno-unused-function -DBINARY_SUPPORT_DLFCN -Wno-error=int-conversion -Wno-error=incompatible-function-pointer-types -D_GNU_SOURCE

# Set up libdispatch
libCoreFoundation_OBJCFLAGS	+= -D__HAS_DISPATCH__
libCoreFoundation_LIBRARIES_DEPEND_UPON += -ldispatch

# Set up libxml2
libCoreFoundation_INCLUDE_DIRS += -I/usr/include/libxml2
libCoreFoundation_LIBRARIES_DEPEND_UPON += -lxml2

# Set up libicu
libCoreFoundation_LIBRARIES_DEPEND_UPON += $(shell pkg-config --libs-only-l icu-uc icu-io)
libCoreFoundation_LIB_DIRS += $(shell pkg-config --libs-only-L icu-uc icu-io)
libCoreFoundation_LDFLAGS += $(shell pkg-config --libs-only-other icu-uc icu-io)
libCoreFoundation_INCLUDE_DIRS += $(shell pkg-config --cflags-only-I icu-uc icu-io)
libCoreFoundation_OBJCFLAGS += $(shell pkg-config --cflags-only-other icu-uc icu-io)

include $(GNUSTEP_MAKEFILES)/library.make