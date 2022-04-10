// lstat needs the following headers.
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#include <CoreFoundation/CoreFoundation_Prefix.h>
#include <CoreFoundation/ForSwiftFoundationOnly.h>
#include <CoreFoundation/CFPriv.h>
#include <CoreFoundation/CFInternal.h>

// This used to be in CFRuntime.h, but it's mysteriously disappeared, causing CFRuntime.m not to compile.

#define __kCFAllocatorTypeID_CONST	2