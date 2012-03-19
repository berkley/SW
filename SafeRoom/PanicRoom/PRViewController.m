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
    welcomeShown = NO;
    
    if([PRSession instance].testMode)
        testEmergencySegCon.selectedSegmentIndex = 0;
    else
        testEmergencySegCon.selectedSegmentIndex = 1;
    
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
    testEmergencySegCon = nil;
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *msg;
    if(!welcomeShown)
    {
        if([[PRSession instance].services count] > 1)
            msg = [NSString stringWithFormat:@"Welcome to SafeRoom. You have %i configured services.\n", 
                   [[PRSession instance].services count]];
        else if([[PRSession instance].services count] == 1)
            msg = [NSString stringWithFormat:@"Welcome to SafeRoom. You have 1 configured service.\n", 
                   [[PRSession instance].services count]];
        else
            msg = @"Welcome to SafeRoom.  You need to configure one or more services.  Touch the 'Settings' button below to get started.";
        welcomeShown = YES;
    }
    else
    {
        if([[PRSession instance].services count] > 1)
            msg = [NSString stringWithFormat:@"You have %i configured services.\n", 
                   [[PRSession instance].services count]];
        else if([[PRSession instance].services count] == 1)
            msg = [NSString stringWithFormat:@"You have 1 configured service.\n", 
                   [[PRSession instance].services count]];
        else
            msg = @"You need to configure one or more services to publish alerts to.  Touch the 'Settings' button below to get started.";
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"text", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_STATUS_TEXT object:nil userInfo:dict];

}

#pragma mark - selectors

- (IBAction)testEmergencySegConValueChanged:(id)sender 
{
    if(testEmergencySegCon.selectedSegmentIndex == 0)
    { //text
        [PRSession instance].testMode = YES;
    }
    else
    {
        [PRSession instance].testMode = NO;
    }
}

- (void)updateStatusText:(NSString*)text
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm:ss";
    NSString *timestamp = [formatter stringFromDate:date];
    statusTextView.text = [NSString stringWithFormat:@"** %@: %@\n%@",timestamp, text, statusTextView.text];    
}

- (void)updateStatusTextView:(NSNotification*)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSString *text = [userInfo objectForKey:@"text"];
    [self updateStatusText:text];
}

- (void)sendMessages
{
//    NSLog(@"currentLocation: %@ updateCounter: %i horizAcc: %f", currentLocation, [PRSession instance].locationUpdateCounter, currentLocation.horizontalAccuracy);
    if(currentLocation != nil &&
       ([PRSession instance].locationUpdateCounter >= VALID_LOCATION_COUNT || 
       currentLocation.horizontalAccuracy <= MIN_LOCATION_ACCURACY))
    { //try 5 times to achieve min_accuracy
        NSLog(@"sending messages to services");
        NSString *msg = @"";
        
        for(PRService *service in [PRSession instance].services)
        {
            if([PRSession instance].testMode && !service.testMessage)
                msg = [PRSession instance].testMessage;
            else if(![PRSession instance].testMode && !service.emergencyMessage)
                msg = [PRSession instance].alertMessage;       
            else if(![PRSession instance].testMode && service.emergencyMessage)
                msg = service.emergencyMessage;
            else if([PRSession instance].testMode && service.testMessage)
                msg = service.testMessage;
            
            
            NSString *mapURL = [CommonUtil getShortenedURLForURL:[CommonUtil createStaticMapURLForLocation:currentLocation]];
            
            msg = [NSString stringWithFormat:@"%@ - My location is: latitude: %f longitude: %f %@", msg, currentLocation.coordinate.latitude, currentLocation.coordinate.longitude, mapURL];
            
            [service sendMessage:msg];
        }
        [[PRSession instance] stopLocationServices];
    }
    else
    {
        [self performSelector:@selector(sendMessages) withObject:nil afterDelay:1];
    }
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
        [self performSelector:@selector(sendMessages) withObject:nil afterDelay:1];
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

- (void)locationUpdated:(NSNotification*)notification
{
    currentLocation = [notification.userInfo objectForKey:@"newLocation"];
}

@end
