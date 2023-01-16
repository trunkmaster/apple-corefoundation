// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2016 Microsoft Corporation
//                         2023 Ethan Charoenpitaks

//******************************************************************************
//
// Copyright (c) 2015 Microsoft Corporation. All rights reserved.
//
// This code is licensed under the MIT License (MIT).
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//******************************************************************************
#if !defined(__COREFOUNDATION_NSCFLOCALE__)
#define __COREFOUNDATION_NSCFLOCALE__ 1

#import <Foundation/NSLocale.h>
#import <CoreFoundation/CFBase.h>

@interface NSCFLocale : NSLocale
@end

@interface NSLocale(CFLocale)
// Returning nil is acceptable here because _prefs is used as a cache to store information about the
// current locale. CFLocale only has a private method for getting this information as well which we cannot
// rely on to be there. Additionally, this will only get called from CFLocale and used in DateFormatter and
// NumberFormatter as a way to avoid look ups iff this class is overridden. This means implementing this
// function would provide no value to the developer.
- (NSDictionary*)_prefs;

// Hard coded to return false. This function is used as an optimization step in CFString to fast path
// retrieving the ID of a language for a given locale. By returning false, the attempt to grab an id
// for a given locale will always happpen. To avoid this, NSLocale would need to know if it's an invalid
// locale via this _nullLocale property. For the purposes of bridging, we cannot store this information.
// Thus, the slow path for the _CFStrGetLanguageIdentifierForLocale in CFString will be taken.
- (Boolean)_nullLocale;

// Do nothing as commented above
- (void)_setNullLocale;

// This function will only be called by CFLocale in an overriden class. The use case for this particular
// function seems strange as it seems virtually identical to the displayNameForKey function already
// defined above. With bridging in place as well, this function won't work as intended and would require
// additional work that won't hold value to a developer.
- (NSString*)_copyDisplayNameForKey:(id)key value:(id)value;
@end

#endif // !__COREFOUNDATION_NSCFLOCALE__
