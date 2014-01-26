//
//  TheUltimateConversionOperation.m
//  Morse Torch
//
//  Created by Andrew Rodgers on 1/24/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//

#import "TheUltimateConversionOperation.h"

@interface TheUltimateConversionOperation()

@property (nonatomic) NSMutableArray *morseStrings;

@end


@implementation TheUltimateConversionOperation


- (id) initWithStrings:(NSMutableArray *)fireStrings
{
    self = [super init];
    
    for (NSString *fireString in fireStrings)
    {
        [self convertString:fireString];
    }
    return self;
}

-(void) convertString:(NSString *)morseString
{
    
}

@end
