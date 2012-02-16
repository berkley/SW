//
//  PRViewController.m
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import "PRViewController.h"

@implementation PRViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    PRSettingsViewController *vc = [[PRSettingsViewController alloc] initWithNibName:@"PRSettingsViewController" bundle:nil];
    settingsViewController = [[PRSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    settingsViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    statusTextView.text = @"";
    numTimerFired = 0;

    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateStatusTextView:) 
                                                 name:NOTIFICATION_UPDATE_STATUS_TEXT 
                                               object:nil];
}

- (void)viewDidUnload
{
    activationSlider = nil;
    settingsBarButtonItem = nil;
    toolbar = nil;
    slideLabel = nil;
    headingLabel = nil;
    distressActiveLabel = nil;
    statusTextView = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark - selectors

- (void)updateStatusText:(NSString*)text
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm:ss";
    NSString *timestamp = [formatter stringFromDate:date];
    statusTextView.text = [NSString stringWithFormat:@"%@: %@\n%@",timestamp, text, statusTextView.text];    
}

- (void)updateStatusTextView:(NSNotification*)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSString *text = [userInfo objectForKey:@"text"];
    [self updateStatusText:text];
}

- (void)activeTimerFired:(id)sender
{
    distressActiveLabel.hidden = !distressActiveLabel.hidden;
    if(distressActiveLabel.hidden)
        activationSlider.thumbTintColor = [UIColor redColor];
    else
        activationSlider.thumbTintColor = [UIColor whiteColor];
    NSString *newMessage = @"Broadcasting...";
    NSString *text = [NSString stringWithFormat:@"%@%i", newMessage, numTimerFired];
    [self updateStatusText:text];
//    NSRange range = NSMakeRange(numStatusTextViewMessages, 1);
    numTimerFired++;
//    [statusTextView scrollRangeToVisible:range];
}

- (IBAction)settingsButtonTouched:(id)sender 
{
    [self presentModalViewController:settingsNavigationController animated:YES];
}

- (IBAction)activationSliderValueChanged:(id)sender 
{
    if(activationSlider.value == 1 && !distressCallIsActive)
    {
        if(activeTimer)
        {
            [activeTimer invalidate];
            activeTimer = nil;
        }
        slideLabel.text = @"Slide to Deactivate";
        activeTimer = [NSTimer scheduledTimerWithTimeInterval:ACTIVE_TIME_INTERVAL target:self selector:@selector(activeTimerFired:) userInfo:nil repeats:YES];
        distressActiveLabel.hidden = NO;
        distressCallIsActive = YES;
    }
    else if(activationSlider.value == 0 && distressCallIsActive)
    {
        slideLabel.text = @"Slide to Activate";
        [activeTimer invalidate];
        activeTimer = nil;
        distressActiveLabel.hidden = YES;
        distressCallIsActive = NO;
    }
}

@end
