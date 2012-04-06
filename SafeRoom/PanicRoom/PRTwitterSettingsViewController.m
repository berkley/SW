//
//  PRTwitterSettingsViewController.m
//  SafeRoom
//
//  Created by Chad Berkley on 3/20/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import "PRTwitterSettingsViewController.h"

@implementation PRTwitterSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    statusLabel = nil;
    accountPicker = nil;
    accountPickerView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)authorizeTwitterAndShowAccountPicker:(BOOL)bShowAccountPicker
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
             NSLog(@"User rejected access to his account.");
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Failed" message:@"To send alerts via Twitter, you must authorized you account.  Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
         else
         {
             NSLog(@"User accepted twitter access");
             twitterAccounts = [store accountsWithAccountType:twitterAccountType];
             for(ACAccount *acct in twitterAccounts)
             {
                 NSLog(@"twitter account: %@", acct.username);
             }
             
             if([twitterAccounts count] > 1)
             {
                 [self performSelectorOnMainThread:@selector(showPicker) withObject:nil waitUntilDone:NO];
             } 
             else if([twitterAccounts count] > 0)
             {
                 ACAccount *twitterAccount = [twitterAccounts objectAtIndex:0];
                 statusLabel.text = [NSString stringWithFormat:@"User: @%@", twitterAccount.username];
             }
             else 
             {
                 NSLog(@"Authorize twitter: No accounts available");
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Twitter Accounts" message:@"You do not have any Twitter accounts configured. Please configure your Twitter accounts in Settings on your device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 [alert show];
             }
         }
     }];
}

- (void)showPicker
{
    CGFloat y = 480 - 60 - accountPickerView.frame.size.height;
    accountPickerView.frame = CGRectMake(0, y, 320, accountPickerView.frame.size.height);
    [self.view addSubview:accountPickerView];
}

- (IBAction)saveButtonTouched:(id)sender
{
    [self authorizeTwitterAndShowAccountPicker:NO];
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
    NSString *username = ((ACAccount*)[twitterAccounts objectAtIndex:row]).username;
    NSLog(@"user selected %@", username);
    [accountPickerView removeFromSuperview];
}


@end
