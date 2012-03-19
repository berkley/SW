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
        doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                   target:self 
                                                                   action:@selector(doneButtonTouched)];
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(refreshDisplay:) 
                                                     name:NOTIFICATION_REFRESH_SERVICE_LIST 
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(keyboardWillShow:) 
                                                     name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(keyboardWillHide:) 
                                                     name:UIKeyboardWillHideNotification object:nil];
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
    scrollView = nil;
    [super viewDidUnload];
}

- (void)doViewDidAppear
{
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self doViewDidAppear];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    service = (PRFacebookService*)[[PRSession instance] serviceWithName:@"Facebook"];
    service.emergencyMessage = eMessageTextView.text;
    service.testMessage = testMessageTextView.text;
    [[PRSession instance] removeService:service];
    [[PRSession instance] addService:service];
}

#pragma mark - selectors

- (void)refreshDisplay:(NSNotification*)notification
{
    [self doViewDidAppear];
}

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

#pragma mark - keyboard notifications

- (void)keyboardWillShow:(NSNotification*)notification
{
    self.navigationItem.rightBarButtonItem = doneButton;
    scrollView.frame = CGRectMake(0, 0, 320, 250);
    scrollView.contentSize = CGSizeMake(320, 350);
    if([testMessageTextView isFirstResponder])
        [scrollView scrollRectToVisible:CGRectMake(0, 200, 320, 85) animated:YES];
    else
        [scrollView scrollRectToVisible:CGRectMake(0, 302, 320, 85) animated:YES];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    self.navigationItem.rightBarButtonItem = nil;
    scrollView.frame = CGRectMake(0, 0, 320, 480);
    
}

- (void)doneButtonTouched
{
    [testMessageTextView resignFirstResponder];
    [eMessageTextView resignFirstResponder];
}

@end
