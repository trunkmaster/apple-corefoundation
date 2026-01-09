##===----------------------------------------------------------------------===##
##
## This source file is part of the Swift open source project
##
## Copyright (c) 2024 Apple Inc. and the Swift project authors
## Licensed under Apache License v2.0
##
## See LICENSE.txt for license information
## See CONTRIBUTORS.md for the list of Swift project authors
##
## SPDX-License-Identifier: Apache-2.0
##
##===----------------------------------------------------------------------===##

include(CoreFoundationAddFramework)
add_framework(CoreFoundation 
                SHARED
              FRAMEWORK_DIRECTORY
                CoreFoundation_FRAMEWORK_DIRECTORY
              PRIVATE_HEADERS
                internalInclude/CFAsmMacros.h
                internalInclude/CFBasicHash.h
                internalInclude/CFBundle_Internal.h
                internalInclude/CFBundle_SplitFileName.h
                internalInclude/CFCalendar_Internal.h
                internalInclude/CFCollections_Internal.h
                internalInclude/CFICUConverters.h
                internalInclude/CFICULogging.h
                internalInclude/CFInternal.h
                internalInclude/CFLocaleInternal.h
                internalInclude/CFMachPort_Internal.h
                internalInclude/CFMachPort_Lifetime.h
                internalInclude/CFPlugIn_Factory.h
                internalInclude/CFPropertyList_Internal.h
                internalInclude/CFRuntime_Internal.h
                internalInclude/CFStreamInternal.h
                internalInclude/CFStringLocalizedFormattingInternal.h
                internalInclude/CFString_Internal.h
                internalInclude/CFTimeZone_WindowsMapping.h
                internalInclude/CFURL.inc.h
                internalInclude/CFURLComponents_Internal.h
                internalInclude/CFUniCharBitmapData.h
                internalInclude/CFUniCharBitmapData.inc.h
                internalInclude/CFUniCharCompatibilityDecompositionData.inc.h
                internalInclude/CFUniCharDecompositionData.inc.h
                internalInclude/CFUniCharPrecompositionData.inc.h
                internalInclude/CFUniCharPriv.h
                internalInclude/CFUniCharPropertyDatabase.inc.h
                internalInclude/CFUnicodeCaseMapping-B.inc.h
                internalInclude/CFUnicodeCaseMapping-L.inc.h
                internalInclude/CFUnicodeData-B.inc.h
                internalInclude/CFUnicodeData-L.inc.h
                internalInclude/CoreFoundation_Prefix.h
                internalInclude/uuid.h
              PUBLIC_HEADERS
                include/CFArray.h
                include/CFAttributedString.h
                include/CFAttributedStringPriv.h
                include/CFAvailability.h
                include/CFBag.h
                include/CFBase.h
                include/CFBigNumber.h
                include/CFBinaryHeap.h
                include/CFBitVector.h
                include/CFBundle.h
                include/CFBundlePriv.h
                include/CFBundle_BinaryTypes.h
                include/CFBurstTrie.h
                include/CFByteOrder.h
                include/CFCalendar.h
                include/CFCalendarPriv.h
                include/CFCharacterSet.h
                include/CFCharacterSetPriv.h
                include/CFConstantKeys.h
                include/CFData.h
                include/CFDate.h
                include/CFDateComponents.h
                include/CFDateFormatter.h
                include/CFDateFormatter_Private.h
                include/CFDateInterval.h
                include/CFDateIntervalFormatter.h
                include/CFDictionary.h
                include/CFError.h
                include/CFError_Private.h
                include/CFFileDescriptor.h
                include/CFKnownLocations.h
                include/CFListFormatter.h
                include/CFLocale.h
                include/CFLocale_Private.h
                include/CFLocking.h
                include/CFLogUtilities.h
                include/CFMachPort.h
                include/CFMessagePort.h
                include/CFNotificationCenter.h
                include/CFNumber.h
                include/CFNumberFormatter.h
                include/CFNumber_Private.h
                include/CFOverflow.h
                include/CFPlugIn.h
                include/CFPlugInCOM.h
                include/CFPreferences.h
                include/CFPriv.h
                include/CFPropertyList.h
                include/CFPropertyList_Private.h
                include/CFRegularExpression.h
                include/CFRelativeDateTimeFormatter.h
                include/CFRunArray.h
                include/CFRunLoop.h
                include/CFRuntime.h
                include/CFSet.h
                include/CFSocket.h
                include/CFStorage.h
                include/CFStream.h
                include/CFStreamAbstract.h
                include/CFStreamPriv.h
                include/CFString.h
                include/CFStringDefaultEncoding.h
                include/CFStringEncodingConverter.h
                include/CFStringEncodingConverterExt.h
                include/CFStringEncodingConverterPriv.h
                include/CFStringEncodingDatabase.h
                include/CFStringEncodingExt.h
                include/CFString_Private.h
                include/CFTargetConditionals.h
                include/CFTimeZone.h
                include/CFTree.h
                include/CFURL.h
                include/CFURLAccess.h
                include/CFURLComponents.h
                include/CFURLPriv.h
                include/CFUUID.h
                include/CFUniChar.h
                include/CFUnicodeDecomposition.h
                include/CFUnicodePrecomposition.h
                include/CFUserNotification.h
                include/CFUtilities.h
                include/CoreFoundation.h
                include/ForFoundationOnly.h
                include/ForSwiftFoundationOnly.h
              SOURCES
                CFFileDescriptor.c
                CFNotificationCenter.c
                CFApplicationPreferences.c
                CFArray.c
                CFAttributedString.c
                CFBag.c
                CFBase.c
                CFBasicHash.c
                CFBigNumber.c
                CFBinaryHeap.c
                CFBinaryPList.c
                CFBitVector.c
                CFBuiltinConverters.c
                CFBundle_Binary.c
                CFBundle_DebugStrings.c
                CFBundle_Executable.c
                CFBundle_Grok.c
                CFBundle_InfoPlist.c
                CFBundle_Locale.c
                CFBundle_Main.c
                CFBundle_ResourceFork.c
                CFBundle_Resources.c
                CFBundle_SplitFileName.c
                CFBundle_Strings.c
                CFBundle_Tables.c
                CFBundle.c
                CFBurstTrie.c
                CFCalendar_Enumerate.c
                CFCalendar.c
                CFCharacterSet.c
                CFConcreteStreams.c
                CFData.c
                CFDate.c
                CFDateComponents.c
                CFDateFormatter.c
                CFDateInterval.c
                CFDateIntervalFormatter.c
                CFDictionary.c
                CFError.c
                CFFileUtilities.c
                CFICUConverters.c
                CFKnownLocations.c
                CFListFormatter.c
                CFLocale.c
                CFLocaleIdentifier.c
                CFLocaleKeys.c
                CFNumber.c
                CFNumberFormatter.c
                CFOldStylePList.c
                CFPlatform.c
                CFPlatformConverters.c
                CFPlugIn.c
                CFPreferences.c
                CFPropertyList.c
                CFRegularExpression.c
                CFRelativeDateTimeFormatter.c
                CFRunArray.c
                CFRunLoop.c
                CFRuntime.c
                CFSet.c
                CFSocket.c
                CFSocketStream.c
                CFSortFunctions.c
                CFStorage.c
                CFStream.c
                CFString.c
                CFStringEncodingConverter.c
                CFStringEncodingDatabase.c
                CFStringEncodings.c
                CFStringScanner.c
                CFStringTransform.c
                CFStringUtilities.c
                CFSystemDirectories.c
                CFTimeZone.c
                CFTimeZone_WindowsMapping.c
                CFTree.c
                CFUniChar.c
                CFUnicodeDecomposition.c
                CFUnicodePrecomposition.c
                CFURL.c
                CFURLAccess.c
                CFURLComponents_URIParser.c
                CFURLComponents.c
                CFUtilities.c
                CFUUID.c
                CFWindowsUtilities.c
                CFXMLPreferencesDomain.c
                uuid.c)
# target_compile_definitions(CoreFoundation
#                         PRIVATE
#                             $<$<COMPILE_LANGUAGE:ASM>:CF_CHARACTERSET_BITMAP="CharacterSets/CFCharacterSetBitmaps.bitmap">
#                             $<$<COMPILE_LANGUAGE:ASM>:CF_CHARACTERSET_UNICHAR_DB="CharacterSets/CFUniCharPropertyDatabase.data">
#                             $<$<COMPILE_LANGUAGE:ASM>:CF_CHARACTERSET_UNICODE_DATA_B="CharacterSets/CFUnicodeData-B.mapping">
#                             $<$<COMPILE_LANGUAGE:ASM>:CF_CHARACTERSET_UNICODE_DATA_L="CharacterSets/CFUnicodeData-L.mapping">)
#-------------------------------------------

target_compile_definitions(CoreFoundation PRIVATE
  $<$<AND:$<PLATFORM_ID:Windows>,$<NOT:$<BOOL:${BUILD_SHARED_LIBS}>>>:CF_WINDOWS_EXECUTABLE_INITIALIZER>)
target_include_directories(CoreFoundation
    PUBLIC
        include
    PRIVATE
        internalInclude)

target_compile_options(CoreFoundation INTERFACE
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xcc -fmodule-map-file=${CMAKE_CURRENT_SOURCE_DIR}/include/module.modulemap>")

target_compile_options(CoreFoundation PRIVATE
    "SHELL:$<$<COMPILE_LANGUAGE:C>:${_Foundation_common_build_flags}>")

target_precompile_headers(CoreFoundation PRIVATE internalInclude/CoreFoundation_Prefix.h)

target_link_libraries(CoreFoundation
    PRIVATE
        icui18n
        dispatch)

if(CMAKE_SYSTEM_NAME STREQUAL "WASI")
    # On WASI, we use vendored BlocksRuntime instead of the one from libdispatch
    add_subdirectory(BlockRuntime)
    # Add BlocksRuntime object library to CoreFoundation static archive
    target_link_libraries(CoreFoundation PRIVATE BlocksRuntime)
endif()

set_property(GLOBAL APPEND PROPERTY Foundation_EXPORTS CoreFoundation)

# Copy Headers to known directory for direct client (XCTest) test builds
# file(COPY
#         include/
#     DESTINATION
#         ${CMAKE_BINARY_DIR}/_CModulesForClients/CoreFoundation)

# if(NOT BUILD_SHARED_LIBS)
#     set(swift swift_static)
# else()
#     set(swift swift)
# endif()

install(DIRECTORY
            CoreFoundation.framework
        DESTINATION
            ${CMAKE_INSTALL_PREFIX}/Frameworks)

# install(TARGETS CoreFoundation
#     ARCHIVE DESTINATION lib}
#     LIBRARY DESTINATION lib}
#     RUNTIME DESTINATION bin)
