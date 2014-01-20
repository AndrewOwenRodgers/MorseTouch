//
//  NSString+MorseCode.m
//  Morse Torch
//
//  Created by Andrew Rodgers on 1/20/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//

#import "NSString+MorseCode.h"

@implementation NSString (MorseCode)

- (NSArray *) symbolsForLetter
{
    NSString *noSpaces = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSMutableArray *tempArray = [NSMutableArray new];
    
    for (int i = 0; i < noSpaces.length; i++)
    {
        [tempArray addObject:[noSpaces symbolForSingleLetter:[noSpaces substringWithRange:NSMakeRange(i, 1)]]];
    }
    return ([NSArray arrayWithArray:tempArray]);
}

- (NSString *) symbolForSingleLetter:(NSString *)letter
{
    letter = [letter uppercaseString];
    return letter;
}

@end
