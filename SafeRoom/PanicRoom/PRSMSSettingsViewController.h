//
//  PRSMSSettingsViewController.h
//  SafeRoom
//
//  Created by Chad Berkley on 2/16/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "PRSMSService.h"
#import "PRSession.h"

@interface PRSMSSettingsViewController : UIViewController
{
    __weak IBOutlet UITextField *serviceNameTextField;
    __weak IBOutlet UITextField *phoneNumberTextField;
    __weak IBOutlet UIButton *deleteButton;
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UITextView *emergenyMessageTextView;
    __weak IBOutlet UITextView *testMessageTextView;
    UIBarButtonItem *doneButton;
    PRSMSService *service;
}

@property (nonatomic, retain) PRSMSService *service;

@end
