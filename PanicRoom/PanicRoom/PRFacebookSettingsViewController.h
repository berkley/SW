//
//  PRFacebookSettingsViewController.h
//  SafeRoom
//
//  Created by Chad Berkley on 2/15/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "PRFacebookService.h"

@interface PRFacebookSettingsViewController : UIViewController
{
    __weak IBOutlet UIButton *logoutButton;
    __weak IBOutlet UILabel *statusLabel;
    __weak IBOutlet UITextView *testMessageTextView;
    __weak IBOutlet UITextView *eMessageTextView;
    PRFacebookService *service;
}

@property (nonatomic, retain) PRFacebookService *service;

@end
