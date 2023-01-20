// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2023 Ethan Charoenpitaks

#include "CoreFoundation/CFBase.h"
#include "CoreFoundation/CFDictionary.h"
#include "XCTest/XCTestAssertions.h"
#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/NSCFDictionary.h>

@interface NSCFDictionaryTests: XCTestCase
@end

@implementation NSCFDictionaryTests

- (void) testCFtoNSconversion {
    NSCFDictionary* nscfDictionary = [NSCFDictionary dictionaryWithObjects: @[@"Hello, World!", @"Foobar"]
                                                                   forKeys: @[@"helloworld", @"foobar"]];
    XCTAssertEqualObjects(CFDictionaryGetValue((CFDictionaryRef)nscfDictionary, @"helloworld"),
                          @"Hello, World!");
}

@end
