// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2023 Ethan Charoenpitaks

#import "NSCFType.h"
#import <CoreFoundation/CFRuntime_Internal.h>
#import <CoreFoundation/GSCFInternal.h>
#import <CoreFoundation/BridgeHelpers.h>

@implementation NSCFType
BRIDGED_CLASS_REQUIRED_IMPLS(CFTypeRef, _kCFRuntimeIDCFType, NSObject, NSCFType)
@end

@implementation NSObject(CFType)
- (BOOL) isCF {
    return NO;
}
- (CFTypeID) _cfTypeID {
    return _kCFRuntimeIDNotAType;
}
- (CFStringRef) _copyDescription {
    return (CFStringRef)[[self description] copy];
}
@end