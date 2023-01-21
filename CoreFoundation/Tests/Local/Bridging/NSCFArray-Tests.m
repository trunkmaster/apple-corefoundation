// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2023 Ethan Charoenpitaks

#include "CoreFoundation/CFBase.h"
#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/NSCFArray.h>

@interface NSCFArrayTests: XCTestCase
@end

@implementation NSCFArrayTests

- (void) testCFtoNSconversion {
    CFArrayRef cfArray = CFArrayCreate(kCFAllocatorDefault, (void const**)(id[2]){@"hello", @"world"}, 2, NULL);
    XCTAssert(cfArray, "CFArray is NULL");
    NSArray* nscfArray = (NSArray*)cfArray;
    XCTAssertEqualObjects(nscfArray[0], @"hello");
}

@end
