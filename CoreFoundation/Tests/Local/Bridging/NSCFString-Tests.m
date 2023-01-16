// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2023 Ethan Charoenpitaks

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/NSCFString.h>

@interface NSCFStringTests: XCTestCase
@end

@implementation NSCFStringTests

- (void) testCFConstantString {
    NSString* string = (NSString*)CFSTR("Hello, world!");
    NSLog(@"%@", [string class]);
    NSLog(@"%@", [string uppercaseString]);
}

- (void) testCFPad {
    NSMutableString* mutString = [NSMutableString stringWithCString: "abc"];
    CFStringPad((CFMutableStringRef)mutString, (CFStringRef)@"abc", 9, 1);
    NSLog(@"%@", mutString);
    XCTAssertEqualObjects(mutString, @"abcbcabca", @"\"%@\" should be \"abcbcabca\"", mutString);
}

- (void) testCFTrim {
    NSMutableString* mutString = [NSMutableString stringWithCString: "* * * *abc * "];
    CFStringTrim((CFMutableStringRef)mutString, (CFStringRef)@"* ");
    NSLog(@"%@", mutString);
    XCTAssertEqualObjects(mutString, @"*abc ", @"\"%@\" should be \"*abc \"", mutString);
}

- (void) testCapitalize {
    NSString* myString = @"Hello, world of foobars.";
    XCTAssertNotNil([myString capitalizedStringWithLocale: [NSLocale currentLocale]]);
}

@end
