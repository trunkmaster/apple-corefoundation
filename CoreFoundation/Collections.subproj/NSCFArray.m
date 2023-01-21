// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2023 Ethan Charoenpitaks
//                         

#include "CoreFoundation/CFArray.h"
#include "Foundation/NSEnumerator.h"
#define CF_BRIDGING_IMPLEMENTED_FOR_THIS_FILE 1
#import <CoreFoundation/GSCFInternal.h>
#import <CoreFoundation/BridgeHelpers.h>
#import <CoreFoundation/CFRuntime_Internal.h>
#import "NSCFArray.h"
#import "NSCFCollectionSupport.h"

/* Flag bits */
enum {		/* Bits 0-1 */
    __kCFArrayImmutable = 0,
    __kCFArrayDeque = 2,
};

CF_INLINE BOOL _NSCFArrayIsMutable(CFArrayRef array) {
    CFIndex type = __CFRuntimeGetValue(array, 1, 0);
    return type != __kCFArrayImmutable;
}

static CFArrayCallBacks _NSCFArrayCallBacks = {
    0, _NSCFCallbackRetain, _NSCFCallbackRelease, _NSCFCallbackCopyDescription, _NSCFCallbackEquals,
};

CF_EXPORT unsigned long _CFArrayFastEnumeration(CFArrayRef array, NSFastEnumerationState *state, void *stackbuffer, unsigned long count);


@implementation NSCFArray

BRIDGED_CLASS_REQUIRED_IMPLS(CFArrayRef, _kCFRuntimeIDCFArray, NSArray, NSCFArray)
BRIDGED_MUTABLE_CLASS_FOR_CODER(CFArrayRef, _NSCFArrayIsMutable, NSArray, NSMutableArray)

+ (instancetype)init {
    return [self initWithObjects:NULL count:0];
}

+ (_Nullable instancetype)initWithObjects:(id _Nonnull const* _Nullable)objects count:(NSUInteger)count {
    NSMutableArray* array = [self initWithCapacity:count];
    for (unsigned int i = 0; i < count; i++) {
        [array addObject:objects[i]];
    }

    return (NSCFArray*)(array);
}

+ (_Nullable instancetype)initWithCapacity:(NSUInteger)numItems {
    return (NSCFArray*)(NSArray*)((CFArrayCreateMutable(kCFAllocatorDefault, numItems, &_NSCFArrayCallBacks)));
}

- (NSUInteger)count {
    return CFArrayGetCount((CFArrayRef)self);
}

- (id)objectAtIndex:(NSUInteger)index {
    if (index >= CFArrayGetCount((CFArrayRef)self)) {
        [NSException raise:@"Array out of bounds"
                    format:@"objectAtIndex: index > count (%lu > %lu), throwing exception\n",
                           (unsigned long)index,
                           (unsigned long)CFArrayGetCount((CFArrayRef)self)];
        return nil;
    }
    return (id)CFArrayGetValueAtIndex((CFArrayRef)self, index);
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    BRIDGED_THROW_IF_IMMUTABLE(_NSCFArrayIsMutable, CFArrayRef);
    CFArrayRemoveValueAtIndex((CFMutableArrayRef)(self), index);
}

- (void)removeLastObject {
    BRIDGED_THROW_IF_IMMUTABLE(_NSCFArrayIsMutable, CFArrayRef);
    NSUInteger count = [self count];

    if (count > 0) {
        CFArrayRemoveValueAtIndex((CFMutableArrayRef)(self), count - 1);
    }
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(NSObject*)obj {
    BRIDGED_THROW_IF_IMMUTABLE(_NSCFArrayIsMutable, CFArrayRef);
    NS_COLLECTION_THROW_IF_NULL_REASON(obj, [NSString stringWithFormat:@"*** %@ object cannot be nil", NSStringFromSelector(_cmd)]);
    //  Fastpath
    CFRange range;
    range.location = index;
    range.length = 1;
    _CFArrayReplaceValues((CFMutableArrayRef)(self), range, (const void**)(&obj), 1);
}

- (void)insertObject:(NSObject*)objAddr atIndex:(NSUInteger)index {
    BRIDGED_THROW_IF_IMMUTABLE(_NSCFArrayIsMutable, CFArrayRef);
    NS_COLLECTION_THROW_IF_NULL_REASON(objAddr, [NSString stringWithFormat:@"*** %@ object cannot be nil", NSStringFromSelector(_cmd)]);
    CFArrayInsertValueAtIndex((CFMutableArrayRef)(self), index, (const void*)(objAddr));
}

- (void)exchangeObjectAtIndex:(NSUInteger)atIndex withObjectAtIndex:(NSUInteger)withIndex {
    BRIDGED_THROW_IF_IMMUTABLE(_NSCFArrayIsMutable, CFArrayRef);
    CFArrayExchangeValuesAtIndices((CFMutableArrayRef)(self), atIndex, withIndex);
}

- (void)removeAllObjects {
    BRIDGED_THROW_IF_IMMUTABLE(_NSCFArrayIsMutable, CFArrayRef);
    CFArrayRemoveAllValues((CFMutableArrayRef)self);
}

- (void)addObject:(NSObject*)objAddr {
    BRIDGED_THROW_IF_IMMUTABLE(_NSCFArrayIsMutable, CFArrayRef);
    NS_COLLECTION_THROW_IF_NULL_REASON(objAddr, [NSString stringWithFormat:@"*** %@ object cannot be nil", NSStringFromSelector(_cmd)]);
    CFArrayAppendValue((CFMutableArrayRef)self, (const void*)objAddr);
}

- (NSObject*)copyWithZone:(NSZone*)zone {
    if (_NSCFArrayIsMutable((CFMutableArrayRef)self)) {
        return (NSObject*)CFArrayCreateCopy(kCFAllocatorDefault, (CFArrayRef)self);
    }

    return [self retain];
}

- (NSObject*)mutableCopyWithZone:(NSZone*)zone {
    return (NSObject*)CFArrayCreateMutableCopy(kCFAllocatorDefault, 0, (CFArrayRef)self);
}

- BRIDGED_COLLECTION_FAST_ENUMERATION(CFArray);

@end