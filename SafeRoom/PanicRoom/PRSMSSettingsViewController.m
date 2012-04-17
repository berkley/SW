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

#pragma mark - private

- (void)updateCharCounts
{
    NSString *testStr = [PRSession createMessage:testMessageTextView.text withLocation:[PRSession instance].locationManager.location];
    NSString *emergStr = [PRSession createMessage:emergenyMessageTextView.text withLocation:[PRSession instance].locationManager.location];
    
    testCharCount = 160 - [testStr length];
    testCharCountLabel.text = [NSString stringWithFormat:@"%i", testCharCount];
    if(testCharCount < 0)
        testCharCountLabel.textColor = [UIColor redColor];
    else
        testCharCountLabel.textColor = [UIColor whiteColor];
    
    emergencyCharCount = 160 - [emergStr length];
    emergencyCharCountLabel.text = [NSString stringWithFormat:@"%i", emergencyCharCount];
    if(emergencyCharCount < 0)
        emergencyCharCountLabel.textColor = [UIColor redColor];
    else
        emergencyCharCountLabel.textColor = [UIColor whiteColor];

}

#pragma mark - init

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
    testCharCount = 0;
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
        testMessageTextView.text = @"I'm testing SafeRoom to send emergency alerts. Please disregard.";
    }

    [self updateCharCounts];
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
        NSString *msg = [NSString stringWithFormat:@"A service with the name %@ already exists. Are you sure you want to overwrite it?", s.name];
        serviceToSave = s;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Duplicate Name" 
                                                        message:msg 
                                                       delegate:self 
                                              cancelButtonTitle:@"No" 
                                              otherButtonTitles:@"Yes", nil];
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

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    { //cancel
        
    }
    else if(buttonIndex == 1)
    { //overwrite
        if(serviceToSave != nil)
        {
            PRService *oldService = [[PRSession instance] serviceWithName:serviceToSave.name];
            if(oldService)
                [[PRSession instance] removeService:oldService];
            [[PRSession instance] addService:serviceToSave];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_SERVICE_LIST object:nil];
        }
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateCharCounts];
    if(textView == emergenyMessageTextView)
    {
        
    }
    else if(textView == testMessageTextView)
    {
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
