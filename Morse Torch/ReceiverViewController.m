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
    self.backgroundQueue = [[NSOperationQueue alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOnMagicEventDetected:) name:@"flashIsOn" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOnMagicEventNotDetected:) name:@"flashIsOff" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)startReception:(id)sender
{
    if (self.receiveButton.tag == 0)
    {
        self.receiveButton.tag = 1;
        self.receiveButton.titleLabel.text = @"Stop";
        self.receiveButton.backgroundColor = [UIColor redColor];
        [_cfMagicEvents startCapture];
    }
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
//    Notes when it was fired
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.stopDate)
        {
            if (([[NSDate date] timeIntervalSinceDate:self.stopDate]) > 0.5)
            {
                [self.stringsToConvert addObject:self.morseString];
                self.morseString = [@"" mutableCopy];
            }
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
