// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2023 Ethan Charoenpitaks

#include "Foundation/NSObjCRuntime.h"
#import <Foundation/NSDictionary.h>
#import <CoreFoundation/CFDictionary.h>

// Not all NSCFDictionaries are mutable!
@interface NSCFDictionary: NSMutableDictionary
@end

@interface NSCFMutableDictionary: NSCFDictionary
@end

@interface NSDictionary(CFDictionary)
/// Returns the number of times a key occurs in a dictionary.
/// Equivalent to casting -containsKey: to a CFIndex.
/// This method is provided only to implement nonsensical CF API.
- (NSInteger) countForKey: (id)key;
/// Returns a Boolean value that indicates whether a given key is in a dictionary.
- (BOOL) containsKey: (id)key;
/// Counts the number of times a given value occurs in the dictionary.
- (NSInteger) countForObject: (id)object;
/// Returns a Boolean value that indicates whether a given value is in a dictionary.
- (BOOL) containsObject: (id)object;
/// Returns a Boolean value that indicates whether a given value for a given key 
/// is in a dictionary, and returns that value indirectly if it exists.
- (BOOL) __getValue: (id*)value forKey: (id)key;
/// Calls a function once for each key-value pair in a dictionary.
- (void) __apply: (CFDictionaryApplierFunction)applier context: (void*)context;
@end

@interface NSMutableDictionary(CFDictionary)
/// Adds a key-value pair to a dictionary if the specified key is not already present.
- (void) __addObject: (id)object forKey: (id)key;
/// Replaces a value corresponding to a given key if the specified key is already present.
- (void) replaceObject: (id)object forKey: (id)key;
/// Equivalent to -setObject:forKey:
- (void) __setObject: (id)object forKey: (id)key;
@end