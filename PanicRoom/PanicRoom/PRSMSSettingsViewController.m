//
//  PRSMSSettingsViewController.m
//  SafeRoom
//
//  Created by Chad Berkley on 2/16/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import "PRSMSSettingsViewController.h"

@implementation PRSMSSettingsViewController
@synthesize service;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        service = nil;
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
    self.navigationItem.title = @"SMS";
}

- (void)viewDidUnload
{
    serviceNameTextField = nil;
    phoneNumberTextField = nil;
    recipientNameTextField = nil;
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(service)
    {
        serviceNameTextField.text = service.name;
        phoneNumberTextField.text = service.phoneNumber;
        recipientNameTextField.text = service.receiverName;
    }
}

- (IBAction)saveButtonTouched:(id)sender 
{
    PRSMSService *s = [[PRSMSService alloc] init];
    s.name = serviceNameTextField.text;
    s.phoneNumber = phoneNumberTextField.text;
    s.receiverName = recipientNameTextField.text;
    if(![[PRSession instance] addService:s])
    {
        NSString *msg = [NSString stringWithFormat:@"A service named %@ already exists. Please choose another name.", s.name];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Duplicate Name" 
                                                        message:msg 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_SERVICE_LIST object:nil];
    }
}

- (IBAction)cancelButtonTouched:(id)sender 
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
