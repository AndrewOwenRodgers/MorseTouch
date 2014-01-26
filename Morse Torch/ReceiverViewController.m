//
//  ReceiverViewController.m
//  Morse Torch
//
//  Created by Andrew Rodgers on 1/24/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//  CFMagicEvents and associated code (c) Cedric Floury, used under the MIT License.

#import "ReceiverViewController.h"
#import "CFMagicEvents.h"
#import "TheUltimateConversionOperation.h"

@interface ReceiverViewController ()

@property (nonatomic) CFMagicEvents *cfMagicEvents;
@property (nonatomic) NSMutableString *morseString;
@property (nonatomic) NSMutableArray *stringsToConvert;
@property (nonatomic) NSDate *fireDate;
@property (nonatomic) NSDate *stopDate;
@property (weak, nonatomic) IBOutlet UIButton *receiveButton;
@property (nonatomic) BOOL isReceiving;
@property (nonatomic) NSOperationQueue *backgroundQueue;

@end

@implementation ReceiverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.receiveButton.titleLabel.text = @"Receive";
    self.backgroundQueue = [[NSOperationQueue alloc] init]; //Initializes a background queue for the conversion of morse code to letters
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //Sets up the camera to recognize flashes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOnMagicEventDetected:) name:@"flashIsOn" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOnMagicEventNotDetected:) name:@"flashIsOff" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    //Takes down the notification center for the flashes
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)startReception:(id)sender
{
    //Changes the receive button into a stop button
    if (self.receiveButton.tag == 0)
    {
        self.receiveButton.tag = 1;
        self.receiveButton.titleLabel.text = @"Stop";
        self.receiveButton.backgroundColor = [UIColor redColor];
        [_cfMagicEvents startCapture];
    }
    //Changes the stop button into a receive button
    else if (self.receiveButton.tag == 1)
    {
        self.receiveButton.tag = 0;
        self.receiveButton.titleLabel.text = @"Receive";
        self.receiveButton.backgroundColor = [UIColor blueColor];
        [_cfMagicEvents stopCapture];
        [self.backgroundQueue addOperation:[[TheUltimateConversionOperation alloc] initWithStrings:self.stringsToConvert]];
        self.stopDate = nil;
    }
}

-(void)receiveOnMagicEventDetected:(NSNotification *) notification
{
//Whenever it detects a flash, it creates a new date to note the time. If the camera had already been running, it will also check to see if this flash is for a new letter / new word.
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.stopDate)
        {
            //Checks to see if this is the start of a new word
            if (([[NSDate date] timeIntervalSinceDate:self.stopDate]) > 0.5)
            {
                [self.stringsToConvert addObject:self.morseString];
                self.morseString = [@"" mutableCopy];
            }
            //Checks to see if this is the start of a new letter
            else if (([[NSDate date] timeIntervalSinceDate:self.stopDate]) > 0.1)
            {
                self.morseString = [[self.morseString stringByAppendingString:@" "] mutableCopy];
            }
        }
        if (!self.fireDate)
        {
            self.fireDate = [NSDate date];
        }
    });
}

-(void)receiveOnMagicEventNotDetected:(NSNotification *) notification
{
    //Whenever the sending torch turns off, this creates a date to note when it turned off (so that you can check for spaces by noting how long the gap between new stop and start was). It also converts the NSDate objects into the correct morse code symbol.
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.fireDate)
        {
            if (([[NSDate date] timeIntervalSinceDate:self.fireDate]) > 0.3)
            {
                self.morseString = [[self.morseString stringByAppendingString:@"-"] mutableCopy];
            }
            else if (([[NSDate date] timeIntervalSinceDate:self.fireDate]) > 0.1)
            {
                self.morseString = [[self.morseString stringByAppendingString:@"."] mutableCopy];
            }
            self.stopDate = [NSDate date];
            self.fireDate = nil;
        }
    });
}

@end
