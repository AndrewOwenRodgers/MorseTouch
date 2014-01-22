//
//  FlashOperation.h
//  Morse Torch
//
//  Created by Andrew Rodgers on 1/21/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVFoundation.h>

@interface FlashOperation : NSOperation

-(id) initWithString:(NSString *)inputString andButton:(UIButton *)sendButton;

@end