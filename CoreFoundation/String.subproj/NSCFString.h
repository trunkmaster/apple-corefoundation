// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2023 Ethan Charoenpitaks

#import <Foundation/NSString.h>
#import <CoreFoundation/CFString.h>

// Not all NSCFStrings are mutable!
@interface NSCFString: NSMutableString
@end

@interface NSCFMutableString: NSCFString
@end

@interface NSCFConstantString: NSCFString
@end

@interface NSString(CFString)
- (BOOL) _encodingCantBeStoredInEightBitCFString;
- (const char*) _fastCStringContents: (BOOL) requiresNullTermination;
- (const unichar*) _fastCharacterContents;
- (BOOL) _getCString: (char*)buffer 
           maxLength: (NSUInteger)maxLength 
            encoding: (CFStringEncoding)encoding;
- (CFStringEncoding) _smallestEncodingInCFStringEncoding;
- (CFStringEncoding) _fastestEncodingInCFStringEncoding;
- (instancetype) _cfNormalize: (CFStringNormalizationForm)form;
- (NSString*) lowercaseStringWithLocale: (NSLocale*) locale;
- (NSString*) uppercaseStringWithLocale: (NSLocale*) locale;
- (NSString*) capitalizedStringWithLocale: (NSLocale*) locale;
@end

@interface NSMutableString(CFString)
- (void) appendCharacters: (const unichar*)characters
                   length: (NSUInteger)length;
- (void) _cfAppendCString: (const char*)cString
                   length: (NSUInteger)length;
/// Enlarges a string, padding it with specified characters, or truncates the string.
/// * Paramaters:
///   * padString: A string containing the characters with which to fill the extended character buffer. Pass NULL to truncate the string. 
///   * length: The new length of theString. If this length is greater than the current length, padding takes place; if it is less, truncation takes place. 
///   * indexIntoPad: The index of the character in padString with which to begin padding. If you are truncating the string represented by the object, this parameter is ignored.
- (void) _cfPad: (CFStringRef)padString 
         length: (uint32_t)length 
       padIndex: (uint32_t)indexIntoPad;
/// CFStringTrim() will trim the specified string from both ends of the string.
/// CFStringTrim("  abc ", " ") -> "abc"
/// CFStringTrim("* * * *abc * ", "* ") -> "*abc "
- (void) _cfTrim: (CFStringRef)trimString;
- (void) _cfTrimWS;
- (void) _cfLowercase: (NSLocale*)locale;
- (void) _cfUppercase: (NSLocale*)locale;
- (void) _cfCapitalize: (NSLocale*)locale;
@end