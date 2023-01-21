# Bridging

## Class initialization

In its `-load` method, each class should call `_CFRuntimeBridgeTypeToClass`, and in an `__attribute__((destructor))`, it should call `_CFRuntimeUnregisterClassWithTypeID`.

```objc
@implementation CFExampleObject

+ (void) load {
    _CFRuntimeBridgeTypeToClass(_kCFRuntimeIDCFExampleObject, self);
}

@end

__attribute__((destructor))
static void __CFExampleObjectUnload(void) {
    _CFRuntimeUnregisterClassWithTypeID(_kCFRuntimeIDCFExampleObject);
}
```

## Object instantiation

`+allocWithZone:` returns the class, which implements the `-init` methods as class methods.

## Method implementations

Each method will call `CF_OBJC_FUNCDISPATCHV` from `CFInternal.h`.

Example:
```objc
CFIndex CFArrayGetCount(CFArrayRef array) {
    CF_OBJC_FUNCDISPATCHV(_kCFRuntimeIDCFArray, CFIndex, (NSArray *)array, count);
    // Do CF stuff here
}
```

This will detect if `array`'s CFTypeID is `_kCFRuntimeIDCFArray`, and if not, will
return `(CFIndex)[array count]`.

## Enabling `CF_OBJC` macros

Before relying on `CF_OBJC` macros, you must `#define CF_BRIDGING_IMPLEMENTED_FOR_THIS_FILE 1`. This means that you gurarantee that any type IDs passed to `CF_OBJC` macros are actually bridged to Objective-C types and registered with `_CFRuntimeBridgeTypeToClass`.

## Bridging helpers

`BridgeHelpers.h` includes many useful macros which you can use in your bridged types.

### `BRIDGED_CLASS_REQUIRED_IMPLS`

Provides implementation for important methods, including `+allocWithZone:`, load and unload, reference counting, and `-_cfTypeID`.

* Paramaters:
  * CFBridgedTypeRef:        Name of CF version of a bridged class,                              eg:  CFArrayRef
  * kCFTypeID:               CFTypeID of CFBridgedTypeRef,                                       eg:  kCFArrayTypeID
  * NSBridgedType:           Name of NS version of a bridged class,                              eg:  NSArray
  * NSCFBridgedType:         Name of NSCF implementation of a bridged class,                     eg:  NSCFArray

### `BRIDGED_CLASS_FOR_CODER`

Implements `-classForCoder`, which affects `-classForArchiver` and `-classForKeyedArchiver`.
Use this for an immutable bridged class.

### `BRIDGED_MUTABLE_CLASS_FOR_CODER`

Implements `-classForCoder`, which affects `-classForArchiver` and `-classForKeyedArchiver`. 
Checks whether the instance is mutable to determine which type to return.
Use this for a mutable bridged class.

* Paramaters:
  * CFBridgedTypeRef:        Name of CF version of a bridged class,                              eg: CFStringRef
  * ISMutableFN:             Function that checks if the instance is mutable,                    eg: __CFStrIsMutable
  * NSBridgedType:           Name of NS version of a bridged class,                              eg: NSString
  * NSMutableBridgedType:    Name of mutable NS version of a bridged class,                      eg: NSMutableString

### Example

```objc
#import <CoreFoundation/BridgeHelpers.h>
#import "NSCFSomething.h"

@implementation NSCFSomething
BRIDGED_CLASS_REQUIRED_IMPLS(CFStringRef, _kCFRuntimeIDCFString, NSString, NSString)
BRIDGED_CLASS_FOR_CODER(NSCFSomething)
@end
```

## Status

* [X] `CFArray`
* [ ] `CFAttributedString`
* [ ] `CFBoolean`
* [ ] `CFCalendar`
* [ ] `CFCharacterSet`
* [ ] `CFData`
* [ ] `CFDate`
* [X] `CFDictionary`
* [ ] `CFError`
* [X] `CFLocale`
* [X] `CFMutableArray`
* [ ] `CFMutableAttributedString`
* [ ] `CFMutableCharacterSet`
* [ ] `CFMutableData`
* [X] `CFMutableDictionary`
* [ ] `CFMutableSet`
* [X] `CFMutableString`
* [ ] `CFNull`
* [ ] `CFNumber`
* [ ] `CFReadStream`
* [ ] `CFRunLoopTimer`
* [ ] `CFSet`
* [X] `CFString`
* [ ] `CFTimeZone`
* [ ] `CFURL`
* [ ] `CFWriteStream`


## References

* [(2012) Toll-Free Bridging - Concepts in Objective-C Programming](https://developer.apple.com/library/archive/documentation/General/Conceptual/CocoaEncyclopedia/Toll-FreeBridgin/Toll-FreeBridgin.html#//apple_ref/doc/uid/TP40010810-CH2)
* [(2013) Toll-Free Bridged Types - Core Foundation Design Concepts](https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFDesignConcepts/Articles/tollFreeBridgedTypes.html)
* [`__bridge`* qualifiers](https://blogs.remobjects.com/2013/04/02/cocoacorefoundation-bridging-explained/)
* [Mike Ash - Toll-Free Bridging Internals](https://www.mikeash.com/pyblog/friday-qa-2010-01-22-toll-free-bridging-internals.html)
* [WinObjC design document](https://github.com/microsoft/WinObjC/blob/develop/docs/CoreFoundation/CoreFoundationDevDesign.md)
* [WinObjC design document for `NSError`](https://github.com/microsoft/WinObjC/blob/develop/docs/CoreFoundation/NSCFErrorDesign.md)
* [Ridiculous Fish - Bridge](http://web.archive.org/web/20101223180747if_/https://ridiculousfish.com/blog/archives/2006/09/09/bridge/#fish_made_a_mess)