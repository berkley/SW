//
//  PRTwitterSettingsViewController.m
//  SafeRoom
//
//  Created by Chad Berkley on 3/20/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import "PRTwitterSettingsViewController.h"

@implementation PRTwitterSettingsViewController
@synthesize service;

- (void)updateCharCounts
{
//    NSString *testStr = [PRSession createMessage:testMessageTextView.text withLocation:[PRSession instance].locationManager.location];
//    NSString *emergStr = [PRSession createMessage:emergenyMessageTextView.text withLocation:[PRSession instance].locationManager.location];
    NSInteger generatedMessageLength = [PRSession generatedMessageLength];
    
    testCharCount = 140 - (generatedMessageLength + [testMessageTextView.text length]);
    testCharCountLabel.text = [NSString stringWithFormat:@"%i", testCharCount];
    if(testCharCount < 0)
        testCharCountLabel.textColor = [UIColor redColor];
    else
        testCharCountLabel.textColor = [UIColor whiteColor];
    
    emergencyCharCount = 140 - (generatedMessageLength + [emergenyMessageTextView.text length]);
    emergencyCharCountLabel.text = [NSString stringWithFormat:@"%i", emergencyCharCount];
    if(emergencyCharCount < 0)
        emergencyCharCountLabel.textColor = [UIColor redColor];
    else
        emergencyCharCountLabel.textColor = [UIColor whiteColor];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
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
    deleteButton.hidden = YES;
}

- (void)viewDidUnload
{
    statusLabel = nil;
    accountPicker = nil;
    accountPickerView = nil;
    cancelButton = nil;
    deleteButton = nil;
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(service)
    {
        serviceNameTextField.text = service.name;
        emergenyMessageTextView.text = service.emergencyMessage;
        testMessageTextView.text = service.testMessage;
        deleteButton.hidden = NO;
        statusLabel.text = [NSString stringWithFormat:@"User: @%@", service.username];
    }
    else
    {
        deleteButton.hidden = YES;
        emergenyMessageTextView.text = [PRSession instance].alertMessage;
        testMessageTextView.text = @"I'm testing SafeRoom for emergency alerts. Please disregard.";
    }
    [self updateCharCounts];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)accountSavedWithUsername:(ACAccount*)account
{
    PRTwitterService *s = [[PRTwitterService alloc] init];
    s.name = serviceNameTextField.text;
    s.testMessage = testMessageTextView.text;
    s.emergencyMessage = emergenyMessageTextView.text;
    s.username = account.username;
    
    if(![[PRSession instance] addService:s])
    {
        NSString *msg = [NSString stringWithFormat:@"A service with the name %@ already exists. Are you sure you want to overwrite it?", service.name];
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
    }}

- (void)authorizeTwitterAndShowAccountPicker:(BOOL)showAccountPicker
{
    //  First, we need to obtain the account instance for the user's Twitter account
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [store
                                         accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //  Request access from the user for access to his Twitter accounts
    [store requestAccessToAccountsWithType:twitterAccountType
                     withCompletionHandler:^(BOOL granted, NSError *error) 
     {
         if (!granted)
         {
             // The user rejected your request
             [self performSelectorOnMainThread:@selector(showRejectedAccessAlert) withObject:nil waitUntilDone:NO];
         }
         else
         {
             NSLog(@"User accepted twitter access");
             twitterAccounts = [store accountsWithAccountType:twitterAccountType];
             
             if([twitterAccounts count] > 1)
             {
                 [self performSelectorOnMainThread:@selector(showPicker) withObject:nil waitUntilDone:NO];
             } 
             else if([twitterAccounts count] > 0)
             {
                  ACAccount *twitterAccount = [twitterAccounts objectAtIndex:0];
                 [self performSelectorOnMainThread:@selector(updateAccountLabel:) withObject:twitterAccount waitUntilDone:NO];
             }
             else 
             {
                 [self performSelectorOnMainThread:@selector(showNoAccountsAlert) withObject:nil waitUntilDone:NO];
             }
         }
     }];
}
             
- (void)updateAccountLabel:(ACAccount*)account
{
    statusLabel.text = [NSString stringWithFormat:@"User: @%@", account.username];
    [self accountSavedWithUsername:account];
}

- (void)showRejectedAccessAlert
{
    NSLog(@"User rejected access to his account.");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Failed" 
                                                    message:@"To send alerts via Twitter, you must authorized you account.  Please try again." 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)showNoAccountsAlert
{
    NSLog(@"Authorize twitter: No accounts available");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Twitter Accounts" 
                                                    message:@"You do not have any Twitter accounts configured. Please configure your Twitter accounts in Settings on your device." 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    [alert show];
}

- (void)showPicker
{
    CGFloat y = 480 - 60 - accountPickerView.frame.size.height;
    accountPickerView.frame = CGRectMake(0, y, 320, accountPickerView.frame.size.height);
    [self.view addSubview:accountPickerView];
}

#pragma mark - UIPickerView delegate and datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSLog(@"number of picker rows: %i", [twitterAccounts count]);
    return [twitterAccounts count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *s = ((ACAccount*)[twitterAccounts objectAtIndex:row]).accountDescription;
    NSLog(@"returning data for picker: %@", s);
    return s;
}

- (IBAction)pickerDoneButtonTouched:(id)sender 
{
    NSInteger row = [accountPicker selectedRowInComponent:0];
    ACAccount *account = (ACAccount*)[twitterAccounts objectAtIndex:row];
    NSString *username = account.username;
    NSLog(@"user selected: %@", username);
    statusLabel.text = [NSString stringWithFormat:@"User: @%@", username];
    [accountPickerView removeFromSuperview];
    [self accountSavedWithUsername:account];
}

#pragma mark - button selectors

- (IBAction)saveButtonTouched:(id)sender
{
    [self authorizeTwitterAndShowAccountPicker:NO];
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

- (IBAction)cancelButtonTouched:(id)sender 
{
    [self.navigationController popViewControllerAnimated:YES];
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
            NSLog(@"serviceToSave: %@", serviceToSave.username);
            [[PRSession instance] addService:serviceToSave];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_SERVICE_LIST object:nil];
        }
    }
}

#pragma mark - scroll and keyboard events

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
