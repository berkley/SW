//
//  PRSMSSettingsViewController.h
//  SafeRoom
//
//  Created by Chad Berkley on 2/16/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "Constants.h"
#import "PRSMSService.h"
#import "PRSession.h"

@interface PRSMSSettingsViewController : UIViewController
<UIAlertViewDelegate, UITextViewDelegate, UITextFieldDelegate>
{
    __weak IBOutlet UITextField *serviceNameTextField;
    __weak IBOutlet UITextField *phoneNumberTextField;
    __weak IBOutlet UIButton *deleteButton;
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UITextView *emergenyMessageTextView;
    __weak IBOutlet UITextView *testMessageTextView;
    __weak IBOutlet UILabel *testCharCountLabel;
    __weak IBOutlet UILabel *emergencyCharCountLabel;
    UIBarButtonItem *doneButton;
    PRSMSService *service;
    PRSMSService *serviceToSave;
    NSInteger testCharCount;
    NSInteger emergencyCharCount;
}

@property (nonatomic, retain) PRSMSService *service;

@end
