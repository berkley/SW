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
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(keyboardWillShow:) 
                                                     name:UIKeyboardWillShowNotification 
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(keyboardWillHide:) 
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                   target:self 
                                                                   action:@selector(doneButtonTouched)];
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
    deleteButton = nil;
    scrollView = nil;
    emergenyMessageTextView = nil;
    testMessageTextView = nil;
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(service)
    {
        serviceNameTextField.text = service.name;
        phoneNumberTextField.text = service.phoneNumber;
        emergenyMessageTextView.text = service.emergencyMessage;
        testMessageTextView.text = service.testMessage;
        deleteButton.hidden = NO;
    }
    else
    {
        deleteButton.hidden = YES;
        emergenyMessageTextView.text = [PRSession instance].alertMessage;
        testMessageTextView.text = [PRSession instance].testMessage;
    }
}

- (IBAction)saveButtonTouched:(id)sender 
{
    PRSMSService *s = [[PRSMSService alloc] init];
    s.name = serviceNameTextField.text;
    s.phoneNumber = phoneNumberTextField.text;
    s.testMessage = testMessageTextView.text;
    s.emergencyMessage = emergenyMessageTextView.text;
    
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

- (IBAction)deleteButtonTouched:(id)sender 
{
    if(self.service)
    {
        [[PRSession instance] removeService:self.service];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_SERVICE_LIST object:nil];
    }
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    self.navigationItem.rightBarButtonItem = doneButton;
    scrollView.frame = CGRectMake(0, 0, 320, 250);
    scrollView.contentSize = CGSizeMake(320, 460);
    if([testMessageTextView isFirstResponder])
        [scrollView scrollRectToVisible:CGRectMake(0, 200, 280, 84) animated:YES];
    else if([emergenyMessageTextView isFirstResponder])
        [scrollView scrollRectToVisible:CGRectMake(0, 310, 280, 84) animated:YES];

}

- (void)keyboardWillHide:(NSNotification*)notification
{
    self.navigationItem.rightBarButtonItem = nil;
    scrollView.frame = CGRectMake(0, 0, 320, 480);    
}

- (void)doneButtonTouched
{
    [testMessageTextView resignFirstResponder];
    [emergenyMessageTextView resignFirstResponder];
    [serviceNameTextField resignFirstResponder];
    [phoneNumberTextField resignFirstResponder];
}

@end
