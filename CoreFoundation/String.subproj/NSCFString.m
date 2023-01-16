// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2023 Ethan Charoenpitaks

#define CF_BRIDGING_IMPLEMENTED_FOR_THIS_FILE 1

#import <CoreFoundation/GSCFInternal.h>
#import <CoreFoundation/BridgeHelpers.h>
#import <CoreFoundation/CFRuntime_Internal.h>
#import <Foundation/Foundation.h>
#import "NSCFString.h"

#import <unicode/urename.h>
#import <unicode/ustring.h>
#import <unicode/ustdio.h>

enum {
    // These are bit numbers - do not use them as masks
    __kCFIsMutable = 0,
    // !!! Bit 1 has been freed up
    __kCFHasLengthByte = 2,
    __kCFHasNullByte = 3,
    __kCFIsUnicode = 4,
};

CF_INLINE Boolean __CFStrIsMutable(CFStringRef str)
    {return __CFRuntimeGetFlag(str, __kCFIsMutable);}

struct objc_class
{
	/**
	 * Pointer to the metaclass for this class.  The metaclass defines the
	 * methods use when a message is sent to the class, rather than an
	 * instance.
	 */
	Class                      isa;
	/**
	 * Pointer to the superclass.  The compiler will set this to the name of
	 * the superclass, the runtime will initialize it to point to the real
	 * class.
	 */
	Class                      super_class;
	/**
	 * The name of this class.  Set to the same value for both the class and
	 * its associated metaclass.
	 */
	const char                *name;
	/**
	 * The version of this class.  This is not used by the language, but may be
	 * set explicitly at class load time.
	 */
	long                       version;
	/**
	 * A bitfield containing various flags.  See the objc_class_flags
	 * enumerated type for possible values.  
	 */
	unsigned long              info;
	/**
	 * The size of this class.  For classes using the non-fragile ABI, the
	 * compiler will set this to a negative value The absolute value will be
	 * the size of the instance variables defined on just this class.  When
	 * using the fragile ABI, the instance size is the size of instances of
	 * this class, including any instance variables defined on superclasses.
	 *
	 * In both cases, this will be set to the size of an instance of the class
	 * after the class is registered with the runtime.
	 */
	long                       instance_size;
	/**
	 * Metadata describing the instance variables in this class.
	 */
	struct objc_ivar_list     *ivars;
	/**
	 * Metadata for for defining the mappings from selectors to IMPs.  Linked
	 * list of method list structures, one per class and one per category.
	 */
	struct objc_method_list   *methods;
	/**
	 * The dispatch table for this class.  Intialized and maintained by the
	 * runtime.
	 */
	void                      *dtable;
	/**
	 * A pointer to the first subclass for this class.  Filled in by the
	 * runtime.
	 */
	Class                      subclass_list;
	/**
	 * Pointer to the .cxx_construct method if one exists.  This method needs
	 * to be called outside of the normal dispatch mechanism.
	 */
	IMP                        cxx_construct;
	/**
	 * Pointer to the .cxx_destruct method if one exists.  This method needs to
	 * be called outside of the normal dispatch mechanism.
	 */
	IMP                        cxx_destruct;
	/**
	 * A pointer to the next sibling class to this.  You may find all
	 * subclasses of a given class by following the subclass_list pointer and
	 * then subsequently following the sibling_class pointers in the
	 * subclasses.
	 */
	Class                      sibling_class;

	/**
	 * Metadata describing the protocols adopted by this class.  Not used by
	 * the runtime.
	 */
	struct objc_protocol_list *protocols;
	/**
	 * Linked list of extra data attached to this class.
	 */
	struct reference_list     *extra_data;
	/**
	* The version of the ABI used for this class.  Currently always zero for v2
	* ABI classes.
	*/
	long                       abi_version;
	/**
	* List of declared properties on this class (NULL if none).
	*/
	struct objc_property_list *properties;
};

void *__CFConstantStringClassReferencePtr;
struct objc_class __CFConstantStringClassReference;

@implementation NSCFConstantString
+ (void) load {
    __CFConstantStringClassReferencePtr = self;
    __CFConstantStringClassReference = *(struct objc_class*)self;
}
@end

CFStringRef _NSCFStringCopyDescription(void* cfTypeRef, const void* locInfo) {
    return (CFStringRef)[[(id)(cfTypeRef) description] copy];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbridge-cast"
@implementation NSCFString

BRIDGED_CLASS_REQUIRED_IMPLS(CFStringRef, _kCFRuntimeIDCFString, NSString, NSCFString)
BRIDGED_MUTABLE_CLASS_FOR_CODER(CFStringRef, __CFStrIsMutable, NSString, NSMutableString)

// Alloc returns NSCFString, so our init methods are class methods.
+ (instancetype) init {
    return [self initWithCString:"" length:0];
}

+ (instancetype) initWithCString:(const char*)cStr length:(NSUInteger)length {
    return (NSCFString*)((NSString*)(
        CFStringCreateWithCString(kCFAllocatorDefault,
                                  cStr,
                                  CFStringConvertNSStringEncodingToEncoding([[self class] defaultCStringEncoding]))));
}

+ (instancetype) initWithUTF8String:(const char*)utf8str {
    return (NSCFString*)(
        (NSString*)(CFStringCreateWithCString(kCFAllocatorDefault, utf8str, kCFStringEncodingUTF8)));
}

+ (instancetype) initWithFormat:(id)formatStr arguments:(va_list)pReader {
    return (NSCFString*)((NSString*)(
        _CFStringCreateWithFormatAndArgumentsAux(kCFAllocatorDefault, &_NSCFStringCopyDescription, NULL, (CFStringRef)(formatStr), pReader)));
}

+ (instancetype) initWithBytes:(const void*)bytes length:(NSUInteger)length encoding:(NSStringEncoding)encoding {
    return (NSCFString*)((NSString*)(CFStringCreateWithBytes(
        kCFAllocatorDefault, (const UInt8*)bytes, length, CFStringConvertNSStringEncodingToEncoding(encoding), false)));
}

+ (instancetype) initWithBytesNoCopy:(void*)bytes
                             length:(NSUInteger)length
                           encoding:(NSStringEncoding)encoding
                       freeWhenDone:(BOOL)freeWhenDone {
    return (NSCFString*)(
        (NSString*)(CFStringCreateWithBytesNoCopy(kCFAllocatorDefault,
                                                             (const UInt8*)bytes,
                                                             length,
                                                             CFStringConvertNSStringEncodingToEncoding(encoding),
                                                             false,
                                                             (freeWhenDone) ? (NULL) : (kCFAllocatorNull))));
}

+ (instancetype) initWithCharacters:(const unichar*)bytes length:(NSUInteger)length {
    return (NSCFString*)((NSString*)(CFStringCreateWithCharacters(kCFAllocatorDefault, bytes, length)));
}

+ (instancetype) initWithCharactersNoCopy:(unichar*)bytes length:(NSUInteger)length freeWhenDone:(BOOL)freeWhenDone {
    return (NSCFString*)((NSString*)(
        CFStringCreateWithCharactersNoCopy(kCFAllocatorDefault, bytes, length, (freeWhenDone) ? (NULL) : (kCFAllocatorNull))));
}

+ (instancetype) initWithCString:(const char*)bytes encoding:(NSStringEncoding)encoding {
    return (NSCFString*)(
        (NSString*)(CFStringCreateWithCString(kCFAllocatorDefault, bytes, CFStringConvertNSStringEncodingToEncoding(encoding))));
}

+ (instancetype) initWithString:(NSString*)otherStr {
    return (NSCFString*)((NSString*)(
        CFStringCreateWithSubstring(kCFAllocatorDefault, (CFStringRef)(otherStr), (CFRange){ 0, [otherStr length] })));
}

+ (instancetype) initWithFormat:(NSString*)format locale:(id)locale arguments:(va_list)argList {
    CFStringRef str;

    if (locale == nil) {
        str = _CFStringCreateWithFormatAndArgumentsAux(NULL, &_NSCFStringCopyDescription, NULL, (CFStringRef)(format), argList);
    } else if ([locale isKindOfClass:[NSLocale class]] || [locale isKindOfClass:[NSDictionary class]]) {
        str = _CFStringCreateWithFormatAndArgumentsAux(kCFAllocatorDefault, &_NSCFStringCopyDescription,
                                                       (CFDictionaryRef)(locale),
                                                       (CFStringRef)(format),
                                                       argList);
    } else {
        [NSException raise:NSInvalidArgumentException format:@"Locale parameter must be a NSLocale or a NSDictionary."];
    }
    return (NSCFString*)((NSString*)(str));
}

+ (instancetype) initWithCStringNoCopy:(char*)bytes length:(NSUInteger)length freeWhenDone:(BOOL)freeBuffer {
    return (NSCFString*)((NSString*)(CFStringCreateWithCStringNoCopy(
        kCFAllocatorDefault, bytes, CFStringGetSystemEncoding(), freeBuffer ? kCFAllocatorDefault : kCFAllocatorNull)));
}

// Exception methods for _NSCFString
- (void)_raiseBoundsExceptionForSelector:(SEL)selector andIndex:(NSUInteger)index {
    [NSException raise:NSRangeException
                format:@"-[NSString %@]: Index %lu out of bounds; string length %lu",
                       NSStringFromSelector(selector),
                       (unsigned long)index,
                       (unsigned long)self.length];
}

- (void)_raiseBoundsExceptionForSelector:(SEL)selector andRange:(NSRange)range {
    [NSException raise:NSRangeException
                format:@"-[NSString %@]: Range {%lu, %lu} out of bounds; string length %lu",
                       NSStringFromSelector(selector),
                       (unsigned long)range.location,
                       (unsigned long)range.length,
                       (unsigned long)self.length];
}

// NSString overrides
- (NSUInteger)length {
    return _CFStringGetLength2((CFStringRef)(self));
}

- (NSUInteger)hash {
    return __CFStringHash((CFStringRef)(self));
}

- (unichar)characterAtIndex:(NSUInteger)index {
    unichar ch = 0;
    int err = _CFStringCheckAndGetCharacterAtIndex((CFStringRef)(self), index, &ch);
    if (err == _CFStringErrBounds) {
        [self _raiseBoundsExceptionForSelector:_cmd andIndex:index];
        return 0;
    }
    return ch;
}

- (void)getCharacters:(unichar*)buffer range:(NSRange)range {
    int err = _CFStringCheckAndGetCharacters((CFStringRef)(self), (CFRange){ range.location, range.length }, buffer);
    if (err == _CFStringErrBounds) {
        [self _raiseBoundsExceptionForSelector:_cmd andRange:range];
    }
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString*)replacement {
    int err = __CFStringCheckAndReplace((CFMutableStringRef)(self), (CFRange){ range.location, range.length }, (CFStringRef)(replacement));
    switch (err) {
    case _CFStringErrBounds:
        [self _raiseBoundsExceptionForSelector:_cmd andRange:range];
        break;
    case _CFStringErrNotMutable:
        [self doesNotRecognizeSelector:_cmd];
        break;
    }
}

- (instancetype)copyWithZone:(NSZone*)zone {
    return (NSCFString*)(CFStringCreateCopy(NULL, (CFStringRef)(self)));
}

@end
#pragma clang diagnostic pop // -Wbridge-cast

@implementation NSCFMutableString
+ (instancetype) init {
    return [self initWithCapacity:0];
}

+ (instancetype) initWithCString:(const char*)cStr length:(NSUInteger)length {
    CFMutableStringRef mutableRef = CFStringCreateMutable(kCFAllocatorDefault, 0);
    CFStringAppendCString(mutableRef, cStr, CFStringConvertNSStringEncodingToEncoding([[self class] defaultCStringEncoding]));
    return (NSCFMutableString*)((NSMutableString*)(mutableRef));
}

+ (instancetype) initWithUTF8String:(const char*)utf8str {
    CFMutableStringRef mutableRef = CFStringCreateMutable(kCFAllocatorDefault, 0);
    CFStringAppendCString(mutableRef, utf8str, kCFStringEncodingUTF8);
    return (NSCFMutableString*)((NSMutableString*)(mutableRef));
}

+ (instancetype) initWithFormat:(id)formatStr arguments:(va_list)pReader {
    CFMutableStringRef mutableRef = CFStringCreateMutable(kCFAllocatorDefault, 0);
    _CFStringAppendFormatAndArgumentsAux(mutableRef, &_NSCFStringCopyDescription, NULL, (CFStringRef)(formatStr), pReader);
    return (NSCFMutableString*)((NSMutableString*)(mutableRef));
}

+ (instancetype) initWithBytes:(const void*)bytes length:(NSUInteger)length encoding:(NSStringEncoding)encoding {
    CFMutableStringRef mutableRef = CFStringCreateMutable(kCFAllocatorDefault, 0);

    // This really isn't the most efficient. Unfortunately though, there is no exposed CF append bytes method.
    CFStringAppend(mutableRef,
                   CFStringCreateWithBytesNoCopy(
                       NULL, (const UInt8*)bytes, length, CFStringConvertNSStringEncodingToEncoding(encoding), false, kCFAllocatorNull));
    return (NSCFMutableString*)((NSMutableString*)(mutableRef));
}

+ (instancetype) initWithBytesNoCopy:(void*)bytes
                              length:(NSUInteger)length
                            encoding:(NSStringEncoding)encoding
                        freeWhenDone:(BOOL)freeWhenDone {
    NSCFMutableString* instance = [self initWithBytes:bytes length:length encoding:encoding];

    // Don't take the "NoCopy" hint because a *mutable* string cannot use the provided buffer and reasonably expect
    // to be able to append etc without also taking an external allocator for resizing. Do free the buffer now if they
    // said freeWhenDone since it is "done" at this point. NOTE: this *must* have been allocated with same heap as IwMalloc's.
    if (freeWhenDone && bytes) {
        free(bytes);
    }
    return instance;
}

+ (instancetype) initWithCharacters:(const unichar*)bytes length:(NSUInteger)length {
    CFMutableStringRef mutableRef = CFStringCreateMutable(kCFAllocatorDefault, 0);
    CFStringAppendCharacters(mutableRef, bytes, length);
    return (NSCFMutableString*)((NSMutableString*)(mutableRef));
}

+ (instancetype) initWithCharactersNoCopy:(unichar*)bytes length:(NSUInteger)length freeWhenDone:(BOOL)freeWhenDone {
    NSCFMutableString* instance = [self initWithCharacters:bytes length:length];

    // Don't take the "NoCopy" hint because a *mutable* string cannot use the provided buffer and reasonably expect
    // to be able to append etc without also taking an external allocator for resizing. Do free the buffer now if they
    // said freeWhenDone since it is "done" at this point. NOTE: this *must* have been allocated with same heap as IwMalloc's.
    if (freeWhenDone && bytes) {
        free(bytes);
    }
    return instance;
}

+ (instancetype) initWithCString:(const char*)bytes encoding:(NSStringEncoding)encoding {
    CFMutableStringRef mutableRef = CFStringCreateMutable(kCFAllocatorDefault, 0);
    CFStringAppendCString(mutableRef, bytes, CFStringConvertNSStringEncodingToEncoding(encoding));
    return (NSCFMutableString*)((NSMutableString*)(mutableRef));
}

+ (instancetype) initWithCapacity:(NSUInteger)capacity {
    return (NSCFMutableString*)((NSMutableString*)(CFStringCreateMutable(kCFAllocatorDefault, capacity)));
}

+ (instancetype) initWithString:(NSString*)otherStr {
    CFMutableStringRef mutableRef = CFStringCreateMutable(kCFAllocatorDefault, 0);
    CFStringAppend(mutableRef, (CFStringRef)(otherStr));
    return (NSCFMutableString*)((NSMutableString*)(mutableRef));
}
@end

@implementation NSString(CFString)
- (BOOL) _encodingCantBeStoredInEightBitCFString {
    // It's intended that this detects whether the storage is contiguous ASCII.
    return NO;
}
- (const char*) _fastCStringContents: (BOOL) requiresNullTermination {
    return NULL;
}
- (const unichar*) _fastCharacterContents {
    return NULL;
}
- (BOOL) _getCString: (char*)buffer 
           maxLength: (NSUInteger)maxLength 
            encoding: (CFStringEncoding)encoding {
    return [self getCString: buffer
                  maxLength: maxLength
                   encoding: CFStringConvertEncodingToNSStringEncoding(encoding)];
}
- (CFStringEncoding) _smallestEncodingInCFStringEncoding {
    return CFStringConvertNSStringEncodingToEncoding([self smallestEncoding]);
}
- (CFStringEncoding) _fastestEncodingInCFStringEncoding {
    return CFStringConvertNSStringEncodingToEncoding([self fastestEncoding]);
}
- (NSString*) _cfNormalize: (CFStringNormalizationForm)form {    
    // -precomposedStringWithCanonicalMapping : Form C
    // -precomposedStringWithCompatibilityMapping : Form KC
    // -decomposedStringWithCanonicalMapping : Form D
    // -decomposedStringWithCompatibilityMapping : Form KD
    switch(form) {
    case kCFStringNormalizationFormC:
        return [self precomposedStringWithCanonicalMapping];
    case kCFStringNormalizationFormKC:
        return [self precomposedStringWithCompatibilityMapping];
    case kCFStringNormalizationFormD:
        return [self decomposedStringWithCanonicalMapping];
    case kCFStringNormalizationFormKD:
        return [self decomposedStringWithCompatibilityMapping];
    }
}
// Keep these three in sync.
- (NSString*) lowercaseStringWithLocale: (NSLocale*) locale {
    const char* localeIdentifier = [[locale localeIdentifier] UTF8String];
    unichar sourceBuffer[[self length]];
    [self getCharacters: sourceBuffer];
    const unichar* sourceCharacters = [self _fastCharacterContents] ?: sourceBuffer;
    UErrorCode errorCode = U_ZERO_ERROR;
    int32_t resultSize = u_strToLower(NULL, 0, // No destination
                                      sourceCharacters, [self length],
                                      localeIdentifier, &errorCode);
    // We need to get the size, but doing so will give us a buffer overflow error.
    if(U_FAILURE(errorCode) && errorCode != U_BUFFER_OVERFLOW_ERROR) {
        NSWarnMLog(@"Error getting size when converting '%@' to title case: %s", self, u_errorName(errorCode));
        return nil;
    }
    errorCode = U_ZERO_ERROR;
    unichar resultBuffer[resultSize];
    u_strToLower(resultBuffer, resultSize,
                 sourceCharacters, [self length],
                 localeIdentifier, &errorCode);
    if(U_FAILURE(errorCode)) {
        NSWarnMLog(@"Error converting '%@' to lowercase: %s", self, u_errorName(errorCode));
        return nil;
    }
    return [NSString stringWithCharacters: resultBuffer length: resultSize];
}
- (NSString*) uppercaseStringWithLocale: (NSLocale*) locale {
    const char* localeIdentifier = [[locale localeIdentifier] UTF8String];
    unichar sourceBuffer[[self length]];
    [self getCharacters: sourceBuffer];
    const unichar* sourceCharacters = [self _fastCharacterContents] ?: sourceBuffer;
    UErrorCode errorCode = U_ZERO_ERROR;
    int32_t resultSize = u_strToUpper(NULL, 0, // No destination
                                      sourceCharacters, [self length],
                                      localeIdentifier, &errorCode);
    // We need to get the size, but doing so will give us a buffer overflow error.
    if(U_FAILURE(errorCode) && errorCode != U_BUFFER_OVERFLOW_ERROR) {
        NSWarnMLog(@"Error getting size when converting '%@' to title case: %s", self, u_errorName(errorCode));
        return nil;
    }
    errorCode = U_ZERO_ERROR;
    unichar resultBuffer[resultSize];
    u_strToUpper(resultBuffer, resultSize,
                 sourceCharacters, [self length],
                 localeIdentifier, &errorCode);
    if(U_FAILURE(errorCode)) {
        NSWarnMLog(@"Error converting '%@' to uppercase: %s", self, u_errorName(errorCode));
        return nil;
    }
    return [NSString stringWithCharacters: resultBuffer length: resultSize];
}
- (NSString*) capitalizedStringWithLocale: (NSLocale*) locale {
    const char* localeIdentifier = [[locale localeIdentifier] UTF8String];
    unichar sourceBuffer[[self length]];
    [self getCharacters: sourceBuffer];
    const unichar* sourceCharacters = [self _fastCharacterContents] ?: sourceBuffer;
    UErrorCode errorCode = U_ZERO_ERROR;
    int32_t resultSize = u_strToTitle(NULL, 0, // No destination
                                      sourceCharacters, [self length],
                                      NULL, // standard title iterator
                                      localeIdentifier, &errorCode);
    // We need to get the size, but doing so will give us a buffer overflow error.
    if(U_FAILURE(errorCode) && errorCode != U_BUFFER_OVERFLOW_ERROR) {
        NSWarnMLog(@"Error getting size when converting '%@' to title case: %s", self, u_errorName(errorCode));
        return nil;
    }
    errorCode = U_ZERO_ERROR;
    unichar resultBuffer[resultSize];
    u_strToTitle(resultBuffer, resultSize,
                 sourceCharacters, [self length],
                 NULL, // standard title iterator
                 localeIdentifier, &errorCode);
    if(U_FAILURE(errorCode)) {
        NSWarnMLog(@"Error converting '%@' to title case: %s", self, u_errorName(errorCode));
        u_printf("Returned buffer is %S with size %d", resultBuffer, resultSize);
        return nil;
    }
    return [NSString stringWithCharacters: resultBuffer length: resultSize];
}
@end

@implementation NSMutableString(CFString)
- (void) appendCharacters: (const unichar*)characters
                   length: (NSUInteger)length {
    [self appendString: [NSString stringWithCharacters: characters 
                                                length: length]];
}
- (void) _cfAppendCString: (const char*)cString
                   length: (NSUInteger)length {
    [self appendString: [NSString stringWithUTF8String: cString]];
}

// TODO - Test me
- (void) _cfPad: (CFStringRef)_padString 
         length: (uint32_t)length 
       padIndex: (uint32_t)indexIntoPad {
    NSString* padString = (NSString*)_padString;
    NSUInteger oldLength = [self length];
    if(length < oldLength) {
        [self deleteCharactersInRange: (NSRange){ .location= length,
                                                    .length= oldLength - length}];
        return;
    } else if(length > oldLength) {
        NSUInteger padStringLength = [padString length];
        // First, add the first few characters of padString that we need.
        if(indexIntoPad == 0) {
            [self appendString: padString];
        } else {
            [self appendString: 
        [padString substringWithRange:
                    (NSRange) { .location= indexIntoPad,
                                  .length= padStringLength - indexIntoPad}]];
        }
        // Next, keep adding more padString until we're done.
        while([self length] <= length - padStringLength) {
            [self appendString: padString];
        }
        // Finally, add the last few characters of padString that we need.
        [self appendString: 
    [padString substringWithRange:
                (NSRange) { .location= 0,
                              .length= length - [self length]}]];
    } else {
        // length == oldLength, so we have nothing to do.
        return;
    }
}
- (void) _cfTrim: (CFStringRef)_trimString {
    NSString* trimString = (NSString*)_trimString;
    // Requires GNUstep Base Additions
    while([self hasPrefix: trimString]) [self deletePrefix: trimString];
    while([self hasSuffix: trimString]) [self deleteSuffix: trimString];
}
- (void) _cfTrimWS {
    [self trimSpaces];
}
- (void) _cfLowercase: (NSLocale*)locale {
    [self setString: [self lowercaseStringWithLocale: locale]];
}
- (void) _cfUppercase: (NSLocale*)locale {
    [self setString: [self uppercaseStringWithLocale: locale]];
}
- (void) _cfCapitalize: (NSLocale*)locale {
    [self setString: [self capitalizedStringWithLocale: locale]];
}
@end