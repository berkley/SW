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
    currentLocation = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateStatusTextView:) 
                                                 name:NOTIFICATION_UPDATE_STATUS_TEXT 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(locationUpdated:) 
                                                 name:NOTIFICATION_LOCATION_CHANGED 
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

    NSLog(@"numTimerFired %i messageInterval %i mod: %i", numTimerFired, [PRSession instance].messageInterval, numTimerFired % [PRSession instance].messageInterval);
    if(numTimerFired % [PRSession instance].messageInterval == 0)
    {
        //turn on location servies, wait for a location, then send messages
        [[PRSession instance] startLocationServices];
    }
    
    numTimerFired++;
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
        numTimerFired = 0;
        if(![PRSession instance].testMode)
            [self updateStatusText:@"Distress Beacon Activated"];
        else
            [self updateStatusText:@"Testing Distress Beacon"];
    }
    else if(activationSlider.value == 0 && distressCallIsActive)
    {
        slideLabel.text = @"Slide to Activate";
        [activeTimer invalidate];
        activeTimer = nil;
        distressActiveLabel.hidden = YES;
        distressCallIsActive = NO;
        [self updateStatusText:@"Beacon Deactivated"];
    }
}

- (void)sendMessages
{
    messageSent = YES;
    NSLog(@"sending messages to services");
    NSString *msg = [PRSession instance].alertMessage;
    if([PRSession instance].testMode)
        msg = [PRSession instance].testMessage;
    
    msg = [NSString stringWithFormat:@"%@ - My location is: latitude: %f longitude: %f", msg, currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
    
    for(PRService *service in [PRSession instance].services)
    {
        [service sendMessage:msg];
    }
}

- (void)locationUpdated:(NSNotification*)notification
{
    currentLocation = [notification.userInfo objectForKey:@"newLocation"];
    if([PRSession instance].locationUpdateCounter >= VALID_LOCATION_COUNT || 
       currentLocation.horizontalAccuracy <= MIN_LOCATION_ACCURACY)
    { //try 5 times to achieve min_accuracy
        if(!messageSent)
            [self sendMessages];
        messageSent = YES;
        [[PRSession instance] stopLocationServices];
    }
}

@end
