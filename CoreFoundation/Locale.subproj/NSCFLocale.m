// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2015 Microsoft Corporation
//                         2023 Ethan Charoenpitaks

//******************************************************************************
//
// Copyright (c) 2015 Microsoft Corporation. All rights reserved.
//
// This code is licensed under the MIT License (MIT).
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//******************************************************************************

#define CF_BRIDGING_IMPLEMENTED_FOR_THIS_FILE 1
#include "CoreFoundation/CFLocale.h"
#include "CoreFoundation/CFRuntime_Internal.h"
#import <CoreFoundation/GSCFInternal.h>
#import "NSCFLocale.h"
#import <CoreFoundation/BridgeHelpers.h>

// @implementation NSLocalePrototype

// PROTOTYPE_CLASS_REQUIRED_IMPLS(NSCFLocale)

// - (instancetype)init {
//     return [self initWithLocaleIdentifier:@""];
// }

// - (instancetype)initWithLocaleIdentifier:(NSString*)string {
//     return reinterpret_cast<NSLocalePrototype*>(
//         (NSLocale*)(CFLocaleCreate(kCFAllocatorDefault, (CFStringRef)(string))));
// }

// @end

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wbridge-cast"
@implementation NSCFLocale

BRIDGED_CLASS_REQUIRED_IMPLS(CFLocaleRef, _kCFRuntimeIDCFLocale, NSLocale, NSCFLocale)
BRIDGED_CLASS_FOR_CODER(NSLocale)

- (NSString*)displayNameForKey:(id)key value:(id)value {
    return [((NSString*)(CFLocaleCopyDisplayNameForPropertyValue((CFLocaleRef)(self),
                                                                 (CFStringRef)(key),
                                                                 (CFStringRef)(value))))
            autorelease];
}

- (id)objectForKey:(id)key {
    return (id)(CFLocaleGetValue((CFLocaleRef)(self), (CFStringRef)(key)));
}

- (NSString*)localeIdentifier {
    return (NSString*)(CFLocaleGetIdentifier((CFLocaleRef)(self)));
}

/**
 @Status Interoperable
*/
+ (instancetype)localeWithLocaleIdentifier:(NSString*)identifier {
    return [[[self alloc] initWithLocaleIdentifier:identifier] autorelease];
}

/**
 @Status Interoperable
*/
+ (NSArray*)availableLocaleIdentifiers {
    return [(NSArray*)(CFLocaleCopyAvailableLocaleIdentifiers()) autorelease];
}

/**
 @Status Interoperable
*/
+ (NSArray*)ISOCountryCodes {
    return [(NSArray*)(CFLocaleCopyISOCountryCodes()) autorelease];
}

/**
 @Status Interoperable
*/
+ (NSArray*)ISOLanguageCodes {
    return [(NSArray*)(CFLocaleCopyISOLanguageCodes()) autorelease];
}

/**
 @Status Interoperable
*/
+ (NSArray*)ISOCurrencyCodes {
    return [(NSArray*)(CFLocaleCopyISOCurrencyCodes()) autorelease];
}

/**
 @Status Interoperable
*/
+ (NSArray*)commonISOCurrencyCodes {
    return [(NSArray*)(CFLocaleCopyCommonISOCurrencyCodes()) autorelease];
}

/**
 @Status Interoperable
*/
+ (NSString*)canonicalLocaleIdentifierFromString:(NSString*)string {
    return [(NSString*)(CFLocaleCreateCanonicalLocaleIdentifierFromString(kCFAllocatorDefault, (CFStringRef)(string)))
        autorelease];
}

/**
 @Status Interoperable
*/
+ (NSDictionary*)componentsFromLocaleIdentifier:(NSString*)identifier {
    return [(NSDictionary*)(
        CFLocaleCreateComponentsFromLocaleIdentifier(kCFAllocatorDefault, (CFStringRef)(identifier))) autorelease];
}

/**
 @Status Interoperable
*/
+ (NSString*)localeIdentifierFromComponents:(NSDictionary*)components {
    return [(NSString*)(
        CFLocaleCreateLocaleIdentifierFromComponents(kCFAllocatorDefault, (CFDictionaryRef)(components))) autorelease];
}

/**
 @Status Interoperable
*/
+ (NSString*)canonicalLanguageIdentifierFromString:(NSString*)string {
    return [(NSString*)(
        CFLocaleCreateCanonicalLanguageIdentifierFromString(kCFAllocatorDefault, (CFStringRef)(string))) autorelease];
}

/**
 @Status Interoperable
*/
+ (NSString*)localeIdentifierFromWindowsLocaleCode:(uint32_t)lcid {
    return [(NSString*)(CFLocaleCreateLocaleIdentifierFromWindowsLocaleCode(kCFAllocatorDefault, lcid)) autorelease];
}

/**
 @Status Interoperable
*/
+ (uint32_t)windowsLocaleCodeFromLocaleIdentifier:(NSString*)localeIdentifier {
    return CFLocaleGetWindowsLocaleCodeFromLocaleIdentifier((CFStringRef)(localeIdentifier));
}

/**
 @Status Interoperable
*/
+ (NSLocaleLanguageDirection)characterDirectionForLanguage:(NSString*)isoLangCode {
    return (NSLocaleLanguageDirection)CFLocaleGetLanguageCharacterDirection((CFStringRef)(isoLangCode));
}

/**
 @Status Interoperable
*/
+ (NSLocaleLanguageDirection)lineDirectionForLanguage:(NSString*)isoLangCode {
    return (NSLocaleLanguageDirection)CFLocaleGetLanguageLineDirection((CFStringRef)(isoLangCode));
}

/**
 @Status Interoperable
*/
+ (NSLocale*)currentLocale {
    return [(NSCFLocale*)(NSLocale*)(CFLocaleCopyCurrent()) autorelease];
}

/**
 @Status Interoperable
*/
+ (NSLocale*)systemLocale {
    return (NSCFLocale*)(NSLocale*)(CFLocaleGetSystem());
}

/**
 @Status Interoperable
*/
+ (NSLocale*)autoupdatingCurrentLocale {
    return [self currentLocale];
}

/**
 @Status Interoperable
*/
+ (NSArray*)preferredLanguages {
    return [(NSArray*)(CFLocaleCopyPreferredLanguages()) autorelease];
}

/**
 @Status Interoperable
*/
- (id)copyWithZone:(NSZone*)zone {
    return [self retain];
}

/**
 @Status Interoperable
*/
- (instancetype)initWithCoder:(NSCoder*)coder {
    if ([coder allowsKeyedCoding]) {
        return [self initWithLocaleIdentifier:[coder decodeObjectOfClass:[NSString class] forKey:@"NS.localeIdentifier"]];
    } else {
        NSLog(@"NSLocale initWithCoder: with non-keyed NSCoder currently unsupported");
        [self release];
        return nil;
    }
}

/**
 @Status Interoperable
*/
- (void)encodeWithCoder:(NSCoder*)coder {
    [coder encodeObject:[self localeIdentifier] forKey:@"NS.localeIdentifier"];
}

/**
 @Status Interoperable
*/
+ (BOOL)supportsSecureCoding {
    return YES;
}

- (NSUInteger)hash {
    return [[self localeIdentifier] hash];
}

- (BOOL)isEqual:(id)anObject {
    if (self == anObject) {
        return YES;
    }
    if (![anObject isKindOfClass:[NSLocale class]]) {
        return NO;
    }

    return [[self localeIdentifier] isEqual:[(NSLocale*)(anObject) localeIdentifier]];
}

@end

@implementation NSLocale(CFLocale)
// Returning nil is acceptable here because _prefs is used as a cache to store information about the
// current locale. CFLocale only has a private method for getting this information as well which we cannot
// rely on to be there. Additionally, this will only get called from CFLocale and used in DateFormatter and
// NumberFormatter as a way to avoid look ups iff this class is overridden. This means implementing this
// function would provide no value to the developer.
- (NSDictionary*)_prefs {
    return nil;
}

// Hard coded to return false. This function is used as an optimization step in CFString to fast path
// retrieving the ID of a language for a given locale. By returning false, the attempt to grab an id
// for a given locale will always happpen. To avoid this, NSLocale would need to know if it's an invalid
// locale via this _nullLocale property. For the purposes of bridging, we cannot store this information.
// Thus, the slow path for the _CFStrGetLanguageIdentifierForLocale in CFString will be taken.
- (Boolean)_nullLocale {
    return false;
}

// Do nothing as commented above
- (void)_setNullLocale {
}

// This function will only be called by CFLocale in an overriden class. The use case for this particular
// function seems strange as it seems virtually identical to the displayNameForKey function already
// defined above. With bridging in place as well, this function won't work as intended and would require
// additional work that won't hold value to a developer.
- (NSString*)_copyDisplayNameForKey:(id)key value:(id)value {
    return [self displayNameForKey:key value:value];
}
@end
#pragma GCC diagnostic pop // -Wbridge-cast
