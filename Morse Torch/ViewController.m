//
//  ViewController.m
//  Morse Torch
//
//  Created by Andrew Rodgers on 1/20/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//

#import "ViewController.h"
#import "FlashOperation.h"

@interface ViewController ()
{
    CGFloat slideheight;
    BOOL enableUnlocked;
}

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.inputTextField.delegate = self;
    [self.sendButton setEnabled:NO];
    enableUnlocked = TRUE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)sendButton:(UIButton *)sender
{
    @autoreleasepool
    {
        NSOperationQueue *flashQueue =[[NSOperationQueue alloc] init];
        FlashOperation *flasher = [[FlashOperation alloc] initWithString:self.inputTextField.text];
        flasher.delegate = self;
        if (sender.tag == 0)
        {
            [flashQueue addOperation:flasher];
        }
        else
        {
            [flashQueue cancelAllOperations];
        }
    }
}

#pragma -Keyboard handling

- (BOOL)textFieldShouldReturn:(UITextField *)textField //Gets rid of the keyboard
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField //Slides the view up when the keyboard appears
{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + (CGFloat)0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - (CGFloat)0.2 * viewRect.size.height;
    CGFloat denominator = (CGFloat)0.6 * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        slideheight = floor((CGFloat)216 * heightFraction);
    }
    else
    {
        slideheight = floor((CGFloat)168 * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= slideheight;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:(CGFloat)0.3];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField //Slides the view back down when the text field is finished being edited
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += slideheight;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:(CGFloat)0.3];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (enableUnlocked)
    {
        if (self.inputTextField.text.length > 0)
        {
            [self.sendButton setEnabled:YES];
            [self.sendButton setBackgroundColor:[UIColor blueColor]];
        }
        else
        {
            [self.sendButton setEnabled:NO];
            [self.sendButton setBackgroundColor:[UIColor grayColor]];
        }
    }
    return YES;
}

- (void) flipEnabling
{
    if (enableUnlocked)
    {
        enableUnlocked = FALSE;
        self.sendButton.tag = 1;
        self.sendButton.titleLabel.text = @"Stop";
        [self.sendButton setBackgroundColor:[UIColor redColor]];
    }
    else
    {
        enableUnlocked = TRUE;
        self.sendButton.tag = 0;
        self.sendButton.titleLabel.text = @"Send";
        [self.sendButton setBackgroundColor:[UIColor blueColor]];
    }
}

@end