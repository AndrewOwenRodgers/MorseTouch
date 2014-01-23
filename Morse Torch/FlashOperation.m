//
//  FlashOperation.m
//  Morse Torch
//
//  Created by Andrew Rodgers on 1/21/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//
//  Flash Operation utilizes the Cocoa Pod MBProgressHUD, Copyright (c) 2013 Matej Bukovinski

#import "FlashOperation.h"
#import "NSString+MorseCode.h"
#import <QuartzCore/QuartzCore.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface FlashOperation()

@property MBProgressHUD *hud;
@property NSString *morseString;

@end

@implementation FlashOperation

-(id) initWithString:(NSString *)inputString
{
    self = [super init];
    self.morseString = inputString;
    return self;
}

- (void) main
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:
    ^{
        [_delegate flipEnabling];
        _hud = [MBProgressHUD showHUDAddedTo:_delegate.view animated:YES];
        _hud.userInteractionEnabled = NO;
    }];
    
    @autoreleasepool
    {
        NSArray *tempArray = self.morseString ? [self.morseString symbolsForLetter] : @[@"String Was Nil"]; //Checks to make sure it's not a null array
        if (tempArray != nil)
        {
            for (int i = 0; i < [tempArray count]; i++) //Checks through the morse code strings
            {
                if (self.isCancelled)
                {
                    break;
                }
                _hud.labelText = [NSString stringWithFormat:@"%c", [self.morseString characterAtIndex:i]];
                if ([[tempArray objectAtIndex:i] isEqualToString:@" "]) //Stops flashing for .5 seconds for spaces between words
                {
                    [NSThread sleepForTimeInterval:0.5];
                }
                else
                {
                    for (int j = 0; j < [[tempArray objectAtIndex:i] length]; j++) //Iterates the morse code symbols
                    {
                        if (self.isCancelled)
                        {
                            break;
                        }
                        NSLog(@"%c", [[tempArray objectAtIndex:i] characterAtIndex:j]);
                        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo]; //Turns on torch
                        if ([device hasTorch])
                        {
                            [device lockForConfiguration:nil];
                            [device setTorchMode:AVCaptureTorchModeOn];
                            [device unlockForConfiguration];
                        }
                
                        if ([[tempArray objectAtIndex:i] characterAtIndex:j] == '.') //Checks which morse code character it is and then delays for a long or short period
                        {
                            [NSThread sleepForTimeInterval:0.1];
                        }
                        else
                        {
                            [NSThread sleepForTimeInterval:0.3];
                        }
                
                        if ([device hasTorch]) //Turns off torch
                        {
                            [device lockForConfiguration:nil];
                            [device setTorchMode:AVCaptureTorchModeOff];
                            [device unlockForConfiguration];
                        }
                        sleep(.1); //Sleeps for .1 second between characters
                    }
                }
            }
        }
        else //Displays an error message if it receives a nil string
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^(void)
            {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You suck"
                                                                 message:@"Letters and numbers only, please!"
                                                                delegate:nil
                                                       cancelButtonTitle:@"I agree to play by the rules"
                                                       otherButtonTitles:nil];
                [alert show];
            }];
        }
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:
     ^{
         [_delegate flipEnabling];
         [MBProgressHUD hideHUDForView:_delegate.view animated:YES];
     }];
}

@end
