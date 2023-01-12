// SPDX-License-Identifier: LicenseRef-BSD-3-Clause-Apple-Sample-Code
// SPDX-FileCopyrightText: 2010 Apple Inc. <>

//     File: CFPreferences.c
// Abstract: Sample code to show one way to use the CFPreferences API's to access user preferences.
//  Version: 1.1
// 
// Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
// Inc. ("Apple") in consideration of your agreement to the following
// terms, and your use, installation, modification or redistribution of
// this Apple software constitutes acceptance of these terms.  If you do
// not agree with these terms, please do not use, install, modify or
// redistribute this Apple software.
// 
// In consideration of your agreement to abide by the following terms, and
// subject to these terms, Apple grants you a personal, non-exclusive
// license, under Apple's copyrights in this original Apple software (the
// "Apple Software"), to use, reproduce, modify and redistribute the Apple
// Software, with or without modifications, in source and/or binary forms;
// provided that if you redistribute the Apple Software in its entirety and
// without modifications, you must retain this notice and the following
// text and disclaimers in all such redistributions of the Apple Software.
// Neither the name, trademarks, service marks or logos of Apple Inc. may
// be used to endorse or promote products derived from the Apple Software
// without specific prior written permission from Apple.  Except as
// expressly stated in this notice, no other rights or licenses, express or
// implied, are granted by Apple herein, including but not limited to any
// patent rights that may be infringed by your derivative works or by other
// works in which the Apple Software may be incorporated.
// 
// The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
// MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
// THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
// OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
// 
// IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
// OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
// MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
// AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
// STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
// 
// Copyright (C) 2010 Apple Inc. All Rights Reserved.
// 
// ****************************************************
#pragma mark -
#pragma mark * complation directives * 
// ----------------------------------------------------
 
#define kMaxNumHighScores 10
 
// ****************************************************
#pragma mark -
#pragma mark * includes & imports * 
// ----------------------------------------------------
 
#include <Carbon/Carbon.h>
#include <CoreFoundation/CFPreferences.h>
#include <stdio.h>
 
// ****************************************************
#pragma mark -
#pragma mark * typedef's, struct's, enums, defines, etc. *
// ----------------------------------------------------
 
#define kHighScoresKeyCFStr CFSTR( "High Scores" )
 
// ****************************************************
#pragma mark -
#pragma mark * local ( static ) function prototypes * 
// ----------------------------------------------------
 
static char * Copy_CFStringRefToCString( CFStringRef inCFStringRef );
static void HighScores_Dump( void );
static __inline__ int random_UInt32_between( UInt32 inStart, UInt32 inStop );
static Boolean HighScores_Update( const char * inPlayer, SInt32 inScore );
static Boolean HighScores_Reset( void );
 
// ****************************************************
#pragma mark -
#pragma mark * exported globals * 
// ----------------------------------------------------
 
// ****************************************************
#pragma mark -
#pragma mark * local ( static ) globals * 
// ----------------------------------------------------
 
// ****************************************************
#pragma mark -
#pragma mark * exported function implementations * 
// ----------------------------------------------------
 
// *****************************************************
//
//  Routine:    main ( )
//
//  Purpose:  Generates 100 random scores and attempts to add them to the high score preference
//
//  Inputs:     none
//
//  Returns:    int - error code ( 0 == no error )
//
 
int main( void )
{
    SInt32 idx;
    UInt32 score;
    Boolean again = TRUE;
    
#if TRUE    // enable to extract CFBundleGetInfoString from bundle
    {
        CFBundleRef     bundleRef = CFBundleGetMainBundle( );
        
        if ( bundleRef ) {
            CFTypeRef tCFTypeRef = CFBundleGetValueForInfoDictionaryKey( bundleRef, CFSTR( "CFBundleGetInfoString" ) );
            
            if ( tCFTypeRef ) {
                char * versionStrPtr = Copy_CFStringRefToCString( tCFTypeRef );
                printf( "\nWelcome to %s!\n", versionStrPtr );
                DisposePtr( versionStrPtr );
                CFRelease( tCFTypeRef );
            }
        }
    }
#endif
    printf("Before: ");
    HighScores_Dump( );
    
    while ( again ) {
        // generate one hundred random scores...
        for ( idx = 0; idx < 100; idx++ ) {
            Str255  playerString;
            
            sprintf( ( Ptr ) playerString, "Player #%.3ld", idx );
            
            score = random_UInt32_between( 0, 100000 );
 
            // update the high scores...
            // ... if our socre is a high score...
            if ( HighScores_Update( ( Ptr ) playerString, score ) ) {
                again = FALSE; // terminate outer loop
            }
        }
 
        // if we didn't generate any new high scores...
        if ( again ) {
            // ... reset the high scores list (pref)
            printf( "Resetting the high scores list...\n" );
            again = HighScores_Reset( );
        }
    }
 
    printf("After: ");
    HighScores_Dump( );
    
    return 0;
}   // main
 
// ****************************************************
#pragma mark -
#pragma mark * local ( static ) function implementations *
// ----------------------------------------------------
 
// *****************************************************
//
//  Routine:    Copy_CFStringRefToCString ( inCFStringRef )
//
//  Purpose:    return a C string from a CFString
//
//  Note:       If not NULL the result has to be DisposePtr'ed.
//
//  Inputs:     inCFStringRef - the CFString to extract the C string from
//
//  Returns:    char * - pointer to C string buffer or NULL on error
//
 
static char * Copy_CFStringRefToCString( CFStringRef inCFStringRef )
{
    char * result = NULL;
    
    if ( inCFStringRef ) {
        CFIndex length = sizeof( UniChar ) * CFStringGetLength( inCFStringRef ) + 1;
        
        result = ( char * ) NewPtrClear( length );
        if ( result ) {
            if ( !CFStringGetCString( inCFStringRef, result, length, kCFStringEncodingASCII ) ) {
                if ( !CFStringGetCString( inCFStringRef, result, length, kCFStringEncodingUTF8 ) ) {
                    DisposePtr( result );
                    result = NULL;
                }
            }
        }
    }
    return result;
}   // Copy_CFStringRefToCString
 
// *****************************************************
//
//  Routine:    random_UInt32_between ( inStart, inStop )
//
//  Purpose:    generate a random UInt32 between start & stop ( inclusive )
//
//  Inputs:     inStart - UInt32 bottom of range
//              inStop  - UInt32 top of range
//
//  Returns:    UInt32  - the random number
//
 
static __inline__ int random_UInt32_between( UInt32 inStart, UInt32 inStop )
{
    UInt32 range = ( ( inStart < inStop ) ? ( inStop - inStart ) : ( inStart - inStop ) ) + 1;
    static UInt32 seed = 0;
    
    if ( !seed ) {  // if the seed is zero...
        seed = CFAbsoluteTimeGetCurrent( );
        srandom( seed );
    }
    seed = range * ( ( float ) random( ) / ( float ) RAND_MAX );
 
    return ( ( inStart < inStop ) ? inStart : inStop ) + seed;
}   // random_UInt32_between
 
// *****************************************************
//
//  Routine:    HighScores_Dump ( )
//
//  Purpose:    dump the high scores (duh!)
//
//  Inputs:     none
//
//  Returns:    none
//
 
static void HighScores_Dump( void )
{
    // get the current high scores
    CFArrayRef  prefCFArrayRef = CFPreferencesCopyAppValue( kHighScoresKeyCFStr, kCFPreferencesCurrentApplication );
    
    if ( !prefCFArrayRef )
        return;
    
    // how many did we get?
    CFIndex countHighScores, idx;
    countHighScores = CFArrayGetCount( prefCFArrayRef );
    
    // print them out
    printf( "The high scores are:\n" );
    for ( idx = 0;idx < countHighScores;idx++ ) {
        
        // get one of the high score elements
        CFArrayRef  dataCFArrayRef;
        dataCFArrayRef = CFArrayGetValueAtIndex( prefCFArrayRef, idx );
        if ( !dataCFArrayRef ) continue;
        
        // extract the players name...
        CFStringRef playerCFStringRef;
        playerCFStringRef = CFArrayGetValueAtIndex( dataCFArrayRef, 0 );
        if ( !playerCFStringRef ) continue;
        char *  playerStrPtr = Copy_CFStringRefToCString( playerCFStringRef );
        if ( !playerStrPtr ) continue;
        
        // and their score
        SInt32      score = 0;
        CFNumberRef scoreCFNumber = CFArrayGetValueAtIndex( dataCFArrayRef, 1 );
        if ( scoreCFNumber ) {
            if ( !CFNumberGetValue( scoreCFNumber, kCFNumberSInt32Type, &score ) ) {
                score = 0;
            }        
            printf( "\t%ld\t\"%s\"\t%ld\n", idx, playerStrPtr, score );
        }
        // free the player's string
        free( playerStrPtr );
    }
    CFRelease( prefCFArrayRef );
}   // HighScores_Dump
 
// *****************************************************
//
//  Routine:    HighScores_Update ( inPlayer, inScore )
//
//  Purpose:    update the saved high scores
//
//  Inputs:     inPlayer - char * pointer to players name
//              inScore - SInt32 score
//
//  Returns:    TRUE if it's a new high score
//
 
static Boolean HighScores_Update( const char * inPlayer, SInt32 inScore )
{
    CFArrayRef  prefCFArrayRef = CFPreferencesCopyAppValue( kHighScoresKeyCFStr, kCFPreferencesCurrentApplication );
    Boolean     dirty = FALSE;
    
    if ( !prefCFArrayRef ) {   // If they don't exist create a new empty array for high scores
        prefCFArrayRef = CFArrayCreate( kCFAllocatorDefault, NULL, 0, &kCFTypeArrayCallBacks );
        dirty = TRUE;
    }
 
    // how many high scores are there?
    CFIndex     countHighScores;
    countHighScores = CFArrayGetCount( prefCFArrayRef );
    if ( countHighScores > kMaxNumHighScores ) {
        countHighScores = kMaxNumHighScores;
    } else if ( countHighScores < kMaxNumHighScores ) {
        dirty = TRUE;
    }
    
    CFArrayRef  dataCFArrayRef = NULL;
    CFStringRef playerCFStringRef;  // the player's name 
    CFNumberRef scoreCFNumberRef;   // the player's score
 
    // for each of the existing high scores
    UInt32      idx;
    for ( idx = 0; idx < countHighScores; idx++ ) {
        SInt32      score;
        
        // extract the high score data
        dataCFArrayRef = CFArrayGetValueAtIndex( prefCFArrayRef, idx );
        if ( !dataCFArrayRef ) break;
        
        // extract the score
        scoreCFNumberRef = CFArrayGetValueAtIndex( dataCFArrayRef, 1 );
        if ( !CFNumberGetValue( scoreCFNumberRef, kCFNumberSInt32Type, &score ) )
            score = 0;
        
        if ( score < inScore )    // if our score is higher than this score...
            break;
    }
    
    // if dirty ( new array or count < max ) or our score is higher than a score in the list
    if ( dirty || ( idx < countHighScores ) ) {
        void * data[2];
        
        // create player name & score CF types
        playerCFStringRef = CFStringCreateWithCString( kCFAllocatorDefault, inPlayer, kCFStringEncodingASCII );
        scoreCFNumberRef = CFNumberCreate( kCFAllocatorDefault, kCFNumberSInt32Type, &inScore );
        
        data[0] = ( void * ) playerCFStringRef;
        data[1] = ( void * ) scoreCFNumberRef;
        
        // create an array of the name / score pair
        dataCFArrayRef = CFArrayCreate( kCFAllocatorDefault, ( void * ) data, 2, &kCFTypeArrayCallBacks );
        
        CFRelease( playerCFStringRef );
        CFRelease( scoreCFNumberRef );
        
        // create a mutable copy of our high score array
        CFMutableArrayRef tCFMutableArrayRef;
        tCFMutableArrayRef = CFArrayCreateMutableCopy( kCFAllocatorDefault, kMaxNumHighScores, prefCFArrayRef );
        
        // If we're replacing the last entry delete it first
        if ( countHighScores == kMaxNumHighScores ) {
            CFArrayRemoveValueAtIndex( tCFMutableArrayRef, kMaxNumHighScores - 1 );
        }
        
        // insert our new name / score / date pair into the prefs array
        CFArrayInsertValueAtIndex( tCFMutableArrayRef, idx, dataCFArrayRef );
        CFRelease( dataCFArrayRef );
        
        CFPreferencesSetAppValue( kHighScoresKeyCFStr, tCFMutableArrayRef, kCFPreferencesCurrentApplication );
        CFRelease( tCFMutableArrayRef );
        
        dirty = CFPreferencesAppSynchronize( kCFPreferencesCurrentApplication );
        
    }
    CFRelease( prefCFArrayRef );
 
    return dirty;
}   // HighScores_Update
 
// *****************************************************
//
//  Routine:    HighScores_Reset ( )
//
//  Purpose:    reset the saved high scores
//
//  Inputs:     none
//
//  Returns:    TRUE if successful
//
 
static Boolean HighScores_Reset( void )
{
    // NULL is passed to delete this preference
    CFPreferencesSetAppValue( kHighScoresKeyCFStr, NULL, kCFPreferencesCurrentApplication );
    return CFPreferencesAppSynchronize( kCFPreferencesCurrentApplication );
}   // HighScores_Reset