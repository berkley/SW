//
//  PRSettingsViewController.h
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRSession.h"
#import "PRNewServiceViewController.h"
#import "PRFacebookSettingsViewController.h"
#import "PRLabelTextFieldTableCell.h"
#import "PROnOffTableCell.h"

@interface PRSettingsViewController : UITableViewController
{
    PRLabelTextFieldTableCell *alertMessageCell;
    PRLabelTextFieldTableCell *testMessageCell;
    PROnOffTableCell *testModeCell;
    PRLabelTextFieldTableCell *intervalCell;
}

@end
