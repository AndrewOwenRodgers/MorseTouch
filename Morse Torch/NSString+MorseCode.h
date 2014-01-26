//
//  NSString+MorseCode.h
//  Morse Torch
//
//  Created by Andrew Rodgers on 1/20/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MorseCode)

- (NSArray *) symbolsForLetter;
+ (NSString *) letterForSingleMorseCodeSymbol:(NSString *)letter;
+ (BOOL) isAlphaNumeric:(NSString *)string;

@end
