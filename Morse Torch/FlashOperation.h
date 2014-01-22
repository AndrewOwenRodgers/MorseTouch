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

@protocol flashOpProtocol <NSObject>

@property UIView *view;
- (void) flipEnabling;

@end

@interface FlashOperation : NSOperation

@property (unsafe_unretained) id <flashOpProtocol> delegate;

-(id) initWithString:(NSString *)inputString;

@end