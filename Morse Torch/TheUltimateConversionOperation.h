//
//  TheUltimateConversionOperation.h
//  Morse Torch
//
//  Created by Andrew Rodgers on 1/24/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MorseCodeToLetter <NSObject>

@property UILabel *morseCodeStringLabel;

@end

@interface TheUltimateConversionOperation : NSOperation

-(id) initWithStrings:(NSMutableArray *)fireStrings;
@property (unsafe_unretained) id <MorseCodeToLetter> delegate;

@end
