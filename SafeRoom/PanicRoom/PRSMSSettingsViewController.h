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
    __weak IBOutlet UITextField *recipientNameTextField;
    __weak IBOutlet UIButton *deleteButton;
    PRSMSService *service;
}

@property (nonatomic, retain) PRSMSService *service;

@end
