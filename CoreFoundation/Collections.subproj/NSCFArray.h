// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2023 Ethan Charoenpitaks

#if !defined(__COREFOUNDATION_NSCFARRAY__)
#define __COREFOUNDATION_NSCFARRAY__ 1

#import <Foundation/NSArray.h>

// Note that not all CFArrays are mutable.
@interface NSCFArray: NSMutableArray
@end

@interface NSCFMutableArray: NSMutableArray
@end

#endif // __COREFOUNDATION_NSCFARRAY__
