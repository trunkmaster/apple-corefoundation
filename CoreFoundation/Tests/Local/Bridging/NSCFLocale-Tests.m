// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2023 Ethan Charoenpitaks

#include "CoreFoundation/CFBase.h"
#include "XCTest/XCTestAssertions.h"
#define CF_BUILDING_CF 1
#define INCLUDE_OBJC 1
#import <CoreFoundation/GSCFInternal.h>
#include "CoreFoundation/CFLocale.h"
#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

@interface NSCFLocaleTests: XCTestCase
@end

@implementation NSCFLocaleTests

- (void) testCFtoNSconversion {
    CFLocaleRef cfLocale = CFLocaleCreate(kCFAllocatorSystemDefault, (CFStringRef)@"");
    NSLog(@"%@", (Class)((CFRuntimeBase*)cfLocale)->_cfisa);
    CFLocaleGetSystem();
    XCTAssert(cfLocale, "CFLocaleGetSystem is NULL");
    NSLocale* nscfLocale = (NSLocale*)cfLocale;
    NSLog(@"%d", [[nscfLocale objectForKey: NSLocaleUsesMetricSystem] boolValue]);
}

@end
