// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2016 Microsoft Corporation
//                         2023 Ethan Charoenpitaks

//******************************************************************************
//
// Copyright (c) 2016 Microsoft Corporation. All rights reserved.
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
#if !defined(__COREFOUNDATION_BRIDGEHELPERS__)
#define __COREFOUNDATION_BRIDGEHELPERS__ 1
#include <stdbool.h>

/// Provides implementation for important methods, including `+allocWithZone:`, load and unload, reference counting, and `-_cfTypeID`.
/// * Paramaters:
///     * CFBridgedTypeRef:        Name of CF version of a bridged class,                              eg:  CFArrayRef
///     * kCFTypeID:               CFTypeID of CFBridgedTypeRef,                                       eg:  kCFArrayTypeID
///     * NSBridgedType:           Name of NS version of a bridged class,                              eg:  NSArray
///     * NSCFBridgedType:         Name of NSCF implementation of a bridged class,                     eg:  NSCFArray
// clang-format off
#define BRIDGED_CLASS_REQUIRED_IMPLS(CFBridgedTypeRef, kCFTypeID, NSBridgedType, NSCFBridgedType) \
 \
+ (instancetype)allocWithZone: (NSZone*) zone { \
    return (NSCFBridgedType*)self; \
} \
+ (void)load { \
    /* self here is referring to the Class object since its a + method. */ \
    _CFRuntimeBridgeTypeToClass(kCFTypeID, self); \
} \
__attribute__((destructor)) \
static void __##NSCFBridgedType##Unload(void) { \
    _CFRuntimeUnregisterClassWithTypeID(kCFTypeID); \
} \
 \
- (id)retain { \
    CFRetain((CFBridgedTypeRef)(self)); \
    return self; \
} \
 \
- (oneway void)release { \
    CFRelease((CFBridgedTypeRef)(self)); \
} \
 \
- (id)autorelease { \
    return (id)(CFAutorelease((CFBridgedTypeRef)(self))); \
} \
 \
- (NSUInteger)retainCount { \
    return CFGetRetainCount((CFBridgedTypeRef)(self)); \
} \
 \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wobjc-missing-super-calls\"") \
- (void)dealloc { \
    /* No-op for bridged classes. This is because the CF system is responsible for the allocation and dealloc of the backing memory. */ \
    /* This is all handled via the CFRelease calls. */ \
    /* When its CF ref count drops to 0 the CF version of dealloc is invoked */ \
    /* so by the time the NSObject dealloc is called, there is nothing left to do. */ \
} \
 \
_Pragma("clang diagnostic pop") \
\
-(CFTypeID)_cfTypeID {                                                             \
    return kCFTypeID;                                                         \
}
// We need to implement this somewhere else.
// + (NSBridgedConcreteType*)allocWithZone:(NSZone*)zone { \
//     FAIL_FAST(); \
//     return nullptr; \
// }

/// Implements `-classForCoder`, which affects `-classForArchiver` and `-classForKeyedArchiver`. 
///
/// Use this for an immutable bridged class.
#define BRIDGED_CLASS_FOR_CODER(NSBridgedType) \
- (Class)classForCoder { \
    return [NSBridgedType class];\
}

/// Implements `-classForCoder`, which affects `-classForArchiver` and `-classForKeyedArchiver`. 
///
/// Checks whether the instance is mutable to determine which type to return.
/// Use this for a mutable bridged class.
///
/// * Paramaters:
///  * CFBridgedTypeRef:        Name of CF version of a bridged class,                              eg: CFStringRef
///  * ISMutableFN:             Function that checks if the instance is mutable,                    eg: __CFStrIsMutable
///  * NSBridgedType:           Name of NS version of a bridged class,                              eg: NSString
///  * NSMutableBridgedType:    Name of mutable NS version of a bridged class,                      eg: NSMutableString
#define BRIDGED_MUTABLE_CLASS_FOR_CODER(CFBridgedTypeRef, ISMutableFN, NSBridgedType, NSMutableBridgedType) \
- (Class)classForCoder { \
    if (ISMutableFN((CFBridgedTypeRef)self)) { \
      return [NSMutableBridgedType class]; \
    } \
    return [NSBridgedType class]; \
}
// clang-format on

// Helper macro for prototype classes - they must not be retained or released
#define PROTOTYPE_CLASS_REQUIRED_IMPLS(NSCFClass) \
    +(void)initialize {                           \
        [NSCFClass self];                         \
    }                                             \
                                                  \
    -(id)retain {                                 \
        /* No-op, prototypes are singletons */    \
        return self;                              \
    }                                             \
                                                  \
    -(oneway void)release{                        \
        /* No-op, prototypes are singletons */    \
    }                                             \
                                                  \
        - (id)autorelease {                       \
        return self;                              \
    }

// Helper to determine if a concrete class should be used.
// In order to determine if a concrete class should be used, the self pointer *must* be
// one of the classes along the abstract class inheritance from derived back to base.
// Consider the following:
//     NSObject
//         |
//     NSArray ----- NSDerivedArray
//         |
//     NSMutableArray ---- NSDerivedMutableArray
//         |
//     NSArrayConcrete
//
// In the above example *only* when self is NSArray or NSMutableArray should a concrete class be substituted in.
static inline bool shouldUseConcreteClass(Class self, Class base, Class derived) {
    // Note that all inheritance walking here is probably very quick as not many levels should exist (2 usually)
    do {
        if (self == derived) {
            return true;
        }

        derived = [derived superclass];

    } while (derived != [base superclass]);

    return false;
}

// Helper macro to stamp out calling through to inner class
#define INNER_BRIDGE_CALL(InnerObject, ReturnValue, ...) \
    (ReturnValue) __VA_ARGS__ {                          \
        return [InnerObject __VA_ARGS__];                \
    }

// Helper macro for implementing allocWithZone
#define ALLOC_PROTOTYPE_SUBCLASS_WITH_ZONE(NSBridgedType, NSBridgedPrototypeType)                            \
    (NSObject*)allocWithZone : (NSZone*)zone {                                                               \
        if (self == [NSBridgedType class]) {                                                                 \
            static NSBridgedPrototypeType* prototype = [NSBridgedPrototypeType allocWithZone:zone];          \
            return prototype;                                                                                \
        }                                                                                                    \
                                                                                                             \
        return [super allocWithZone:zone];                                                                   \
    }

// Helper macro for base classes
#define BASE_CLASS_REQUIRED_IMPLS(NSBridgedType, NSBridgedPrototypeType, kCFTypeID) \
    /* +ALLOC_PROTOTYPE_SUBCLASS_WITH_ZONE(NSBridgedType, NSBridgedPrototypeType); */  \
                                                                                       \
    -(CFTypeID)_cfTypeID {                                                             \
        return kCFTypeID;                                                         \
    }

#define BRIDGED_COLLECTION_FAST_ENUMERATION(CFBridgedType)                                                                           \
    (NSUInteger) countByEnumeratingWithState : (NSFastEnumerationState*)state objects : (id*)stackBuf count : (NSUInteger)maxCount { \
        return _##CFBridgedType##FastEnumeration((CFBridgedType##Ref)self, state, stackBuf, maxCount);                               \
    }

#define BRIDGED_THROW_IF_IMMUTABLE(ISMutableFN, CFBridgedType) \
    if (!ISMutableFN((CFBridgedType)self)) {                   \
        [self doesNotRecognizeSelector:_cmd];                  \
    }

#endif // !__COREFOUNDATION_BRIDGEHELPERS__
