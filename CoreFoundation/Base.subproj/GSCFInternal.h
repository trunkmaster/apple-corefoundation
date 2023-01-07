// lstat needs the following headers.
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#include <CoreFoundation/CoreFoundation_Prefix.h>
#include <CoreFoundation/ForSwiftFoundationOnly.h>
#include <CoreFoundation/CFPriv.h>
#include <CoreFoundation/CFInternal.h>

#define DEPLOYMENT_RUNTIME_SWIFT 0
#define DEPLOYMENT_RUNTIME_OBJC 0
#define DEPLOYMENT_RUNTIME_GNUSTEP_LIBOBJC2 1

#if __OBJC__
    #import <Foundation/Foundation.h>
#endif

// This used to be in CFRuntime.h, but it's mysteriously disappeared, causing CFRuntime.m not to compile.

#define __kCFAllocatorTypeID_CONST	2