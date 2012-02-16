//
//  PRFacebookSettingsViewController.m
//  SafeRoom
//
//  Created by Chad Berkley on 2/15/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import "PRFacebookSettingsViewController.h"

@implementation PRFacebookSettingsViewController

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
    [super viewDidUnload];
}

#pragma mark - selectors

- (IBAction)logoutButtonTouched:(id)sender 
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FACEBOOK_LOGOUT object:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
