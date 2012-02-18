//
//  PRFacebookSettingsViewController.m
//  SafeRoom
//
//  Created by Chad Berkley on 2/15/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import "PRFacebookSettingsViewController.h"

@implementation PRFacebookSettingsViewController
@synthesize service;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.navigationItem.title = @"Facebook";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    statusLabel = nil;
    logoutButton = nil;
    testMessageTextView = nil;
    eMessageTextView = nil;
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.service = (PRFacebookService*)[[PRSession instance] serviceWithName:@"Facebook"];
    if(service == nil || service.accessToken == nil)
    {
        logoutButton.titleLabel.text = @"Login";
        statusLabel.text = @"Not Logged In";
        eMessageTextView.text = [PRSession instance].alertMessage;
        testMessageTextView.text = [PRSession instance].testMessage;
    }
    else
    {
        logoutButton.titleLabel.text = @"Logout";
        statusLabel.text = @"Logged In";
        eMessageTextView.text = service.emergencyMessage;
        testMessageTextView.text = service.testMessage;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    service.emergencyMessage = eMessageTextView.text;
    service.testMessage = testMessageTextView.text;
}

#pragma mark - selectors

- (IBAction)logoutButtonTouched:(id)sender 
{
    if(service.accessToken == nil)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_AUTHORIZE_FACEBOOK 
                                                            object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FACEBOOK_LOGOUT object:nil];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

@end
