//
//  PRTwitterSettingsViewController.h
//  SafeRoom
//
//  Created by Chad Berkley on 3/20/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "PRTwitterService.h"

@interface PRTwitterSettingsViewController : UIViewController
<UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate, UITextViewDelegate>
{
    NSArray *twitterAccounts;
    __weak IBOutlet UILabel *statusLabel;
    __weak IBOutlet UIPickerView *accountPicker;
    IBOutlet UIView *accountPickerView;
    __weak IBOutlet UIButton *cancelButton;
    __weak IBOutlet UIButton *deleteButton;
    PRTwitterService *serviceToSave;
    PRTwitterService *service;
    
    __weak IBOutlet UITextField *serviceNameTextField;
    __weak IBOutlet UITextField *phoneNumberTextField;
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UITextView *emergenyMessageTextView;
    __weak IBOutlet UITextView *testMessageTextView;
    __weak IBOutlet UILabel *testCharCountLabel;
    __weak IBOutlet UILabel *emergencyCharCountLabel;
    UIBarButtonItem *doneButton;
    NSInteger testCharCount;
    NSInteger emergencyCharCount;
}

@end
