// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2023 Ethan Charoenpitaks

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/NSCFLocale.h>

@interface NSCFLocaleTests: XCTestCase
@end

@implementation NSCFLocaleTests

- (void) testCFtoNSconversion {
    CFLocaleRef cfLocale = CFLocaleGetSystem();
    XCTAssert(cfLocale, "CFLocaleGetSystem is NULL");
    NSLocale* nscfLocale = (NSLocale*)cfLocale;
    NSLog(@"%d", [[nscfLocale objectForKey: NSLocaleUsesMetricSystem] boolValue]);
}

@end
