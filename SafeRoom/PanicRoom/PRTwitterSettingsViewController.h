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

@interface PRTwitterSettingsViewController : UIViewController
<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray *twitterAccounts;
    __weak IBOutlet UILabel *statusLabel;
    __weak IBOutlet UIPickerView *accountPicker;
    IBOutlet UIView *accountPickerView;
}

@end
