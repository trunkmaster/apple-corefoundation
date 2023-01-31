// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2023 Ethan Charoenpitaks

#if !defined(__COREFOUNDATION_NSCFTYPE__)
#define __COREFOUNDATION_NSCFTYPE__ 1

#import <Foundation/NSObject.h>
#import <CoreFoundation/CFBase.h>

@interface NSCFType: NSObject
@end

@interface NSObject(CFType)
- (CFTypeID) _cfTypeID;
// Returns whether this object is a CF type. If self is nil, returns NO.
- (BOOL) isCF;
- (CFStringRef) _copyDescription;
@end

#endif // __COREFOUNDATION_NSCFTYPE__