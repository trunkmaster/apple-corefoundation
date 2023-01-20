// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2023 Ethan Charoenpitaks
//                         2018 Microsoft Corporation

#include "Foundation/NSEnumerator.h"
#include "Foundation/NSObjCRuntime.h"
#define CF_BRIDGING_IMPLEMENTED_FOR_THIS_FILE 1

#import <CoreFoundation/GSCFInternal.h>
#import <CoreFoundation/BridgeHelpers.h>
#import <CoreFoundation/CFRuntime_Internal.h>
#import <Foundation/Foundation.h>
#import "NSCFDictionary.h"
#import "NSCFCollectionSupport.h"

// Defined in CFDictionary.m
CF_EXPORT Boolean _CFDictionaryIsMutable(CFDictionaryRef hc);
CF_EXPORT unsigned long _CFDictionaryFastEnumeration(CFDictionaryRef hc, NSFastEnumerationState *state, void *stackbuffer, unsigned long count);
CF_EXPORT void _CFDictionarySetCapacity(CFMutableDictionaryRef hc, CFIndex cap);

static CFDictionaryKeyCallBacks _NSCFDictionaryKeyCallBacks = {
    0, _NSCFCallbackCopy, _NSCFCallbackRelease, _NSCFCallbackCopyDescription, _NSCFCallbackEquals, _NSCFCallbackHash,
};

static CFDictionaryValueCallBacks _NSCFDictionaryValueCallBacks = {
    0, _NSCFCallbackRetain, _NSCFCallbackRelease, _NSCFCallbackCopyDescription, _NSCFCallbackEquals,
};

@interface NSCoder()
- (NSSet*) allowedClasses;
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbridge-cast"
@implementation NSCFDictionary

BRIDGED_CLASS_REQUIRED_IMPLS(CFDictionaryRef, _kCFRuntimeIDCFDictionary, NSDictionary, NSCFDictionary)
BRIDGED_MUTABLE_CLASS_FOR_CODER(CFDictionaryRef, _CFDictionaryIsMutable, NSDictionary, NSMutableDictionary)

- (id)objectForKey:(id)key {
    if (key == nil) {
        NSWarnLog(@"Warning: objectForKey called with nil\n");
        return nil;
    }

    return (id)CFDictionaryGetValue((CFDictionaryRef)self, (const void*)key);
}

- (NSUInteger)count {
    return CFDictionaryGetCount((CFDictionaryRef)self);
}

- (NSEnumerator*)keyEnumerator {
    // This snapshots the keys at this moment,
    // but mutation during enumeration is considered invalid, so it should be okay.
    return [[self allKeys] objectEnumerator];
}

- (void)setObject:(id)object forKey:(id)key {
    BRIDGED_THROW_IF_IMMUTABLE(_CFDictionaryIsMutable, CFDictionaryRef);
    NS_COLLECTION_THROW_IF_NULL_REASON(object,
                                       [NSString
                                           stringWithFormat:@"*** %@ object cannot be nil (key: %@)", NSStringFromSelector(_cmd), key]);
    CFDictionarySetValue((CFMutableDictionaryRef)self, (const void*)key, (void*)object);
}

- (void)removeObjectForKey:(id)key {
    BRIDGED_THROW_IF_IMMUTABLE(_CFDictionaryIsMutable, CFDictionaryRef);
    CFDictionaryRemoveValue((CFMutableDictionaryRef)self, (void*)key);
}

- (void)removeAllObjects {
    BRIDGED_THROW_IF_IMMUTABLE(_CFDictionaryIsMutable, CFDictionaryRef);
    CFDictionaryRemoveAllValues((CFMutableDictionaryRef)self);
}

- (NSArray*)allValues {
    int count = CFDictionaryGetCount((CFDictionaryRef)(self));

    if (count == 0) {
        return [NSArray array];
    }

    id values[count];
    CFDictionaryGetKeysAndValues((CFDictionaryRef)self, NULL, (const void**)values);

    return [NSArray arrayWithObjects:values count:count];
}

- (NSArray*)allKeys {
    int count = CFDictionaryGetCount((CFDictionaryRef)(self));

    if (count == 0) {
        return [NSArray array];
    }

    id keys[count];
    CFDictionaryGetKeysAndValues((CFDictionaryRef)self, (const void**)keys, NULL);

    return [NSArray arrayWithObjects:keys count:count];
}

- (NSObject*)copyWithZone:(NSZone*)zone {
    if (_CFDictionaryIsMutable((CFDictionaryRef)self)) {
        return (NSObject*)CFDictionaryCreateCopy(kCFAllocatorDefault, (CFDictionaryRef)self);
    }

    return [self retain];
}

- (NSObject*)mutableCopyWithZone:(NSZone*)zone {
    return (NSObject*)CFDictionaryCreateMutableCopy(kCFAllocatorDefault, 0, (CFDictionaryRef)self);
}

- BRIDGED_COLLECTION_FAST_ENUMERATION(CFDictionary);

//// Initialization

/**
 @Status Interoperable
*/
+ (instancetype)dictionaryWithObjects:(id const*)vals forKeys:(id<NSCopying> const*)keys count:(NSUInteger)count {
    return [[[self alloc] initWithObjects:vals forKeys:keys count:count] autorelease];
}

/**
 @Status Interoperable
*/
+ (instancetype)dictionaryWithDictionary:(NSDictionary*)dictionary {
    return [[[self alloc] initWithDictionary:dictionary] autorelease];
}

/**
 @Status Interoperable
*/
+ (instancetype)dictionaryWithObjects:(NSArray*)vals forKeys:(NSArray*)keys {
    return [[[self alloc] initWithObjects:vals forKeys:keys] autorelease];
}

/**
 @Status Interoperable
*/
+ (instancetype) initWithObjects:(id)vals forKeys:(id)keys {
    int count = [vals count];

    id flatValues[count];
    id flatKeys[count];

    for (int i = 0; i < count; i++) {
        flatValues[i] = [vals objectAtIndex:i];
        flatKeys[i] = [keys objectAtIndex:i];
    }

    return [self initWithObjects:flatValues forKeys:flatKeys count:count];
}

/**
 @Status Interoperable
*/
+ (instancetype) initWithObject:(id)val forKey:(id)key {
    return [self initWithObjects:&val forKeys:&key count:1];
}

+ (instancetype) initWithObjects:(const id*)vals forKeys:(const id<NSCopying> _Nonnull[])keys count:(NSUInteger)count {
    NSDictionary* dictionary = (NSDictionary*)(CFDictionaryCreate(kCFAllocatorDefault,
                                                                             (const void**)(keys),
                                                                             (const void**)(vals),
                                                                             count,
                                                                             &_NSCFDictionaryKeyCallBacks,
                                                                             &_NSCFDictionaryValueCallBacks));

    return (NSCFDictionary*)(dictionary);
}

/**
 @Status Interoperable
*/
+ (BOOL)supportsSecureCoding {
    return YES;
}

/**
 @Status Interoperable
*/
- (id)initWithCoder:(NSCoder*)coder {
    NSArray* keys = [coder respondsToSelector:@selector(allowedClasses)]
                    ? [coder decodeObjectOfClasses:coder.allowedClasses forKey:@"NS.keys"]
                    : [coder decodeObjectForKey:@"NS.keys"];
    NSArray* values = [coder respondsToSelector:@selector(allowedClasses)]
                    ? [coder decodeObjectOfClasses:coder.allowedClasses forKey:@"NS.objects"]
                    : [coder decodeObjectForKey:@"NS.objects"];

    return [self initWithObjects:values forKeys:keys];
}

@end
#pragma clang diagnostic pop // -Wbridge-cast

@implementation NSCFMutableDictionary
/**
 @Status Interoperable
*/
+ (instancetype)dictionary {
    return [[self new] autorelease];
}

/**
 @Status Interoperable
*/
+ (instancetype)dictionaryWithCapacity:(NSUInteger)capacity {
    return [[(NSCFMutableDictionary*)[self alloc] initWithCapacity:capacity] autorelease];
}

/**
 @Status Interoperable
*/
+ (instancetype)dictionaryWithDictionary:(NSDictionary*)dictionary {
    return [[[self alloc] initWithDictionary:dictionary] autorelease];
}

/**
 @Status Caveat
 @Notes Ignores input keyset and returns an empty NSMutableDictionary* without any optimization
*/
+ (NSMutableDictionary*)dictionaryWithSharedKeySet:(id)keyset {
    return [NSCFMutableDictionary dictionary];
}
@end

// All code below was written by Ethan Charoenpitaks.

@implementation NSDictionary(CFDictionary)
// !! turns it into a Boolean value.
/// Returns the number of times a key occurs in a dictionary.
/// Equivalent to casting -containsKey: to a CFIndex.
/// This method is provided only to implement nonsensical CF API.
- (NSInteger) countForKey: (id)key {
    return !![self objectForKey: key];
}
/// Returns a Boolean value that indicates whether a given key is in a dictionary.
- (BOOL) containsKey: (id)key {
    return !![self objectForKey: key];
}
/// Counts the number of times a given value occurs in the dictionary.
- (NSInteger) countForObject: (id)object {
    NSInteger count = 0;

    if(!object) {
        return 0;
    }

    for(id key in self) {
        if([self objectForKey: key] == object) {
            count++;
        }
    }
    return count;
}
/// Returns a Boolean value that indicates whether a given value is in a dictionary.
- (BOOL) containsObject: (id)object {
    if(!object) {
        return NO;
    }

    for(id key in self) {
        if([self objectForKey: key] == object) {
            return YES;
        }
    }
    return NO;
}
/// Returns a Boolean value that indicates whether a given value for a given key 
/// is in a dictionary, and returns that value indirectly if it exists.
- (BOOL) __getValue: (id*)value forKey: (id)key {
    id object = [self objectForKey: key];
    if(object) {
        *value = object;
        return YES;
    } else {
        return NO;
    }
}
/// Calls a function once for each key-value pair in a dictionary.
- (void) __apply: (CFDictionaryApplierFunction)applier context: (void*)context {
    for(id key in self) {
        applier(key, [self objectForKey: key], context);
    }
}
@end

@implementation NSMutableDictionary(CFDictionary)
/// Adds a key-value pair to a dictionary if the specified key is not already present.
- (void) __addObject: (id)object forKey: (id)key {
    if(![self objectForKey: object]) {
        [self setObject: object forKey: key];
    }
}
/// Replaces a value corresponding to a given key if the specified key is already present.
- (void) replaceObject: (id)object forKey: (id)key {
    if([self objectForKey: object]) {
        [self setObject: object forKey: key];
    }
}
/// Equivalent to -setObject:forKey:
- (void) __setObject: (id)object forKey: (id)key {
    [self setObject: object forKey: key];
}
@end