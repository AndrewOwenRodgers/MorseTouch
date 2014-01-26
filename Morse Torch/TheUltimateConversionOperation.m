//
//  TheUltimateConversionOperation.m
//  Morse Torch
//
//  Created by Andrew Rodgers on 1/24/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//

#import "TheUltimateConversionOperation.h"
#import "NSString+MorseCode.h"

@interface TheUltimateConversionOperation()

@property (nonatomic) NSMutableArray *morseStrings;
@property (nonatomic) NSMutableString *returnString;

@end


@implementation TheUltimateConversionOperation


- (id) initWithStrings:(NSMutableArray *)fireStrings
{
    self = [super init];
    
    for (NSString *fireString in fireStrings)
    {
        [self convertString:fireString];
    }
    _delegate.morseCodeStringLabel.text = self.returnString;
    return self;
}

-(void) convertString:(NSString *)morseString
{
    NSArray *strings = [morseString componentsSeparatedByString:@" "];
    [self.returnString appendString:@" "];
    
    for (NSString *letter in strings)
    {
        [self.returnString stringByAppendingString:[NSString letterForSingleMorseCodeSymbol:letter]];
    }
}

@end
